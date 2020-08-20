//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Yossy Carmeli on 10/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "Game.h"
#import "SetCardView.h"
#import "GameBoardView.h"
#import "DeckView.h"

@class Deck;
@class SetCardDeck;
@class SetCard;
@class HistoryViewController;

@interface SetGameViewController()
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet GameBoardView *boardView;
@property (strong, nonatomic) IBOutlet DeckView *deckView;
@property(strong,nonatomic) Game *game;
@property (nonatomic) int drawCount;
@property (strong, nonatomic) NSMutableArray<SetCardView *> *cardViewArray;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@end


@implementation SetGameViewController

static const CGFloat CARD_WIDTH = 40;
static const CGFloat CARD_HEIGHT = 60;
#define CARD_SIZE CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
#define DECK_SIZE 81
#define STARTING_CARDS_NUM 12
#define MARGIN_BETWEEN_CARDS 4

//-(void)viewWillLayoutSubviews{
//  [self newGame];
//
//}


#pragma mark -Constraints

- (void)constraintResetButton {
  [self.resetButton.widthAnchor constraintEqualToConstant:70].active = YES;
  [self.resetButton.leftAnchor constraintEqualToAnchor:self.boardView.leftAnchor].active = YES;
  [self.resetButton.topAnchor constraintEqualToAnchor:self.boardView.bottomAnchor constant:30].active = YES;
}

- (void)constraintScoreLabel {
  
  [self.scoreLabel.leftAnchor constraintEqualToAnchor:self.resetButton.rightAnchor constant:20].active = YES;
  [self.scoreLabel.topAnchor constraintEqualToAnchor:self.resetButton.topAnchor constant:5].active = YES;
}

- (void)constraintBoardView {
  
  self.boardView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.boardView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = YES;
  [self.boardView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:5].active = YES;

  /* Fixed width */
  NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.boardView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:-10];
  /* Fixed Height */
  NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.boardView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeHeight
                                                                     multiplier:1.0
                                                                       constant: -150];
  /* Add the constraints to superview*/
  [self.view addConstraints:@[ widthConstraint, heightConstraint]];
}


- (void)constraintDeckView {
  
  self.deckView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.deckView.topAnchor constraintEqualToAnchor:self.boardView.bottomAnchor constant:10].active = YES;
  [self.deckView.rightAnchor constraintEqualToAnchor:self.boardView.rightAnchor constant:0].active = YES;
  [self.deckView.widthAnchor constraintEqualToConstant:CARD_WIDTH].active = YES;
  [self.deckView.heightAnchor constraintEqualToConstant:CARD_HEIGHT].active = YES;

}

- (void)constraintAllViews {
  
  [self constraintBoardView];
  [self constraintResetButton];
  [self constraintScoreLabel];
  [self constraintDeckView]; //unique
  
}

#pragma mark -Inits

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    [self newGame];
}


- (void)orientationChanged:(NSNotification *)notification{
  [self updateUI];
}

- (void)setSubViews {
  
  [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.boardView];
  [self.boardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.scoreLabel];
  [self.view addSubview:self.resetButton];
  [self.view addSubview:self.deckView]; // unique

}

- (void) newGame {
  
  self.game = [[Game alloc]initWithCardCount:DECK_SIZE usingDeck:[self createDeck] playingGameType:@"SET!" cardsNumForMatch:3];
  //_animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
  self.boardView = [[GameBoardView alloc]init ];
  self.deckView = [[DeckView alloc]initWithFrame:CGRectZero ];
  self.drawCount = 0;

  [self setSubViews];

  [self constraintAllViews];
  self.cardViewArray = [self createCardViewArray];

  UITapGestureRecognizer *deckTapRecognizer =
  [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(deckTap:) ];
  [self.deckView addGestureRecognizer:deckTapRecognizer];

  [self.boardView layoutIfNeeded];
  [self dealNCards:STARTING_CARDS_NUM];
  [self updateUI];

  
  NSLog(@"draw:%d",self.drawCount);
  NSLog(@"board size: [%f X %f]",self.boardView.frame.size.height,self.boardView.frame.size.width);
  NSLog(@"board size: [%f X %f]",self.boardView.widthAnchor.accessibilityFrame.size.width ,self.boardView.bounds.size.width);

}

- (NSMutableArray<SetCardView *> *)createCardViewArray {

  NSMutableArray *cardViewArray = [[NSMutableArray alloc]init];
  CGRect frame;
  frame.size = CARD_SIZE;
  frame.origin = self.deckView.bounds.origin;
  for (SetCard *card in self.game.cards ) {
    SetCardView *cardView = [self createSetCardViewFromSetCard:card usingFrame: frame];

    [cardViewArray addObject:cardView];
  }
  
  return cardViewArray;
}

- (SetCardView *) createSetCardViewFromSetCard:(SetCard *)card usingFrame:(CGRect)frame {
    
  SetCardView *cardView = [[SetCardView alloc]initWithFrame:frame];
  cardView.color = card.color;
  cardView.symbol = card.symbol;
  cardView.numberOfSymbols = [card.numberOfSymbols intValue];
  cardView.fillType = card.fillType;
  
  return cardView;
}

- (BOOL) isOKToDeal:(CGPoint)nextCardCenterLocation {
  return (nextCardCenterLocation.x != -1 && (self.drawCount < [self.game.cards count] ))  ;
}

- (int)dealNCards:(int)cardsNumToDeal {
  int cardsDealt = 0;
  for (int i = 0; i < cardsNumToDeal;i++){
    CGPoint nextCardCenterLocation = [self getNextCardCenterLocation];
    if ( [self isOKToDeal:nextCardCenterLocation ]  ) {
      cardsDealt++;
      [self dealCardTo:nextCardCenterLocation dealsLeft:(cardsNumToDeal-i)];
    }
  }
  return cardsDealt;
}

- (void)dealCardTo:(CGPoint)nextCardCenterLocation dealsLeft:(int)dealsLeft {

  SetCardView *cardView = self.cardViewArray[self.drawCount];
  cardView.index = self.drawCount++;
  
   UITapGestureRecognizer *cardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(cardTap:) ];
  [cardView addGestureRecognizer:cardTapRecognizer];
  

  [self.boardView addSubview:cardView];
  
  [self animateCardMovementToNewLocation:cardView usingLocation:nextCardCenterLocation];

}

#define CARD_DEAL_ANIMATION_DURATION 0.5
#define DELAY_BETWEEN_DEALS 0.5


- (void)animateCardMovementToNewLocation:(SetCardView *)cardView usingLocation:(CGPoint)newLocation{
  
  [UIView animateWithDuration:CARD_DEAL_ANIMATION_DURATION
                   animations:^{
                    cardView.center = newLocation;
                  }
                   completion:^(BOOL finished){
                    if (finished) {
                      //TODO- getNextAnimation?
                    //  [cardView performSelector:@selector(nothing) withObject:nil afterDelay:DELAY_BETWEEN_DEALS];
                    }
                  }

   ];
}

- (CGPoint)getCenterPointFromOrigin: (CGPoint)originPoint{
  
  CGPoint center;
  center.x = originPoint.x + CARD_WIDTH;
  center.y = originPoint.y + CARD_HEIGHT;
  return center;
  
}



- (CGPoint)getNextCardCenterLocation {

  CGFloat startXSearchingValue =  MARGIN_BETWEEN_CARDS + (CARD_WIDTH / 2.0) ;//+ self.boardView.frame.origin.x;
  CGFloat startYSearchingValue =  MARGIN_BETWEEN_CARDS + (CARD_HEIGHT / 2.0);// + self.boardView.frame.origin.y;

  CGFloat boardYLimit = self.boardView.frame.size.height;
  CGFloat boardXLimit = self.boardView.frame.size.width;
  
  for (int y = startYSearchingValue ; y < boardYLimit; y += (CARD_HEIGHT + MARGIN_BETWEEN_CARDS) ) {
    for (int x = startXSearchingValue; x < boardXLimit; x += (CARD_WIDTH + MARGIN_BETWEEN_CARDS) ) {
      if ([self isLocationFree:CGPointMake(x, y)]) {
        return CGPointMake(x  , y );
      }
    }
  }

  return CGPointMake(-1, -1);

}

//- (CGPoint)getNextCardLocation {
//
//  CGFloat startXSearchingValue =  MARGIN_BETWEEN_CARDS;
//  CGFloat startYSearchingValue =  MARGIN_BETWEEN_CARDS;
//  for (int y = startYSearchingValue ; y < self.boardView.bounds.size.height; y += (CARD_HEIGHT + MARGIN_BETWEEN_CARDS) ) {
//    for (int x = startXSearchingValue; x < self.boardView.bounds.size.width; x += (CARD_WIDTH + MARGIN_BETWEEN_CARDS) ) {
//      if ([self isLocationFree:CGPointMake(x, y)]) {
//        return CGPointMake(x  , y );
//      }
//    }
//  }
//
//  return CGPointMake(-1, -1);
//
//}

- (BOOL)isLocationFree:(CGPoint)point {
  if ([self isPointOutOfBounds:point]) {
    return NO;
  }
  for (UIView *cardView in [self.boardView subviews]) {
    if (CGPointEqualToPoint(point, cardView.center) ) {
      return NO;
    }
  }
  return YES;
  
}

- (BOOL) isPointOutOfBounds:(CGPoint)point {
  return (point.x + CARD_WIDTH/2 >= self.boardView.bounds.size.width || point.y + CARD_HEIGHT/2 >= self.boardView.bounds.size.height);
}


- (UIColor *)colorAtIndex:(int)index{
  switch (index){
    case 1: return [UIColor greenColor];
    case 2: return [UIColor purpleColor];
    case 3: return [UIColor redColor];
  }
  return [UIColor blackColor];
}

- (UIColor *)cardToColor:(SetCard *)card {
  return [self colorAtIndex:card.color];
}


- (IBAction)resetClick:(id)sender {
  [self newGame];
  
}

-(Deck *)createDeck {
  return [[SetCardDeck alloc] initWithSymbols:@[@"triangle",@"circle",@"square"] ];
}

#define CARDS_NUM_ON_DEALING 3

- (void)deckTap:(UITapGestureRecognizer *)recognizer {
  
  int dealCount = [self dealNCards:CARDS_NUM_ON_DEALING];
  [self.game drawCardPenalty:dealCount];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
  [self updateUI];
  if (self.drawCount == [self.game.cards count]) {
    [self.deckView removeFromSuperview];
  }
}

- (void)cardTap:(UITapGestureRecognizer *)recognizer {
  
  SetCardView *tapedCardView = (SetCardView *) recognizer.view;
  
  [self.game chooseCardAtIndex:tapedCardView.index];
  [self updateUI];

}

- (void)removeCardAndAnimate:(SetCardView *)cardView {
  
  //TODO ANIMATION OF CARD GET REMOVED
  CGPoint flyingCardLocation;
  flyingCardLocation.y = self.boardView.frame.size.height;
  flyingCardLocation.x = (arc4random() % (int)self.boardView.frame.size.width ) ;
  //[self animateCardMovementToNewLocation:cardView usingLocation:flyingCardLocation];
  
  [UIView animateWithDuration:CARD_DEAL_ANIMATION_DURATION
                   animations:^{
    cardView.alpha = 0.0;
                  }
                   completion:^(BOOL finished){
                    if (finished) {
                   //   [cardView removeFromSuperview];
                      //TODO- getNextAnimation?
                    //  [cardView performSelector:@selector(nothing) withObject:nil afterDelay:DELAY_BETWEEN_DEAL];
                    }
                  }

   ];
  
  
  [cardView removeFromSuperview];
}

- (void)checkAndRemoveCards{
  
  for (SetCardView *cardView in [self.boardView subviews]) {
    SetCard *card = (SetCard *) [self.game cardAtIndex:cardView.index];
    [cardView setBackgroundColorByChosen:card.chosen];
    if (card.matched) {
      [self removeCardAndAnimate:cardView];
    }
  }

}

- (void) updateScoreLabel{
  
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];

}

- (void)updateUI {
  
  [self checkAndRemoveCards];
  [self checkAndMoveCardsToBetterLocation];
  [self updateScoreLabel];
  
}

- (void)checkAndMoveCardsToBetterLocation {
  
  for (int i =0;i <[self.game.cards count];i++) { // check by order of dealing
    SetCardView *cardView = self.cardViewArray[i];
    if ([[self.boardView subviews] containsObject:cardView]) {
      [self checkAndMoveCardToBetterLocation:cardView];
    }
  }

}

- (void)checkAndMoveCardToBetterLocation: (SetCardView *)cardView {
  
  CGPoint nextCardLocation = [self getNextCardCenterLocation]; //changed

  if ([self isNewLocationBetterThanCurrentLocation:nextCardLocation currentLocation:cardView.center] ) {
    [self animateCardMovementToNewLocation:cardView usingLocation:nextCardLocation];
  }
}

- (BOOL)isNewLocationBetterThanCurrentLocation:(CGPoint)locationToCheckIfBetter currentLocation:(CGPoint)currentLocation {
  
  return ( [self isValidLocation:locationToCheckIfBetter] &&
          ( [self isPointOutOfBounds:currentLocation] || [self isNewLocationBeforeThanCurrentLocation:locationToCheckIfBetter currentLocation:currentLocation ] )) ;
}

-(BOOL)isNewLocationBeforeThanCurrentLocation:(CGPoint)locationToCheckIfBefore currentLocation:(CGPoint)currentLocation {
  return ( (locationToCheckIfBefore.y < currentLocation.y) ||
      ( (locationToCheckIfBefore.x < currentLocation.x) && (locationToCheckIfBefore.y == currentLocation.y) ) );
}

- (BOOL)isValidLocation:(CGPoint)location{
  return (location.x != -1);
}








@end
