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
@property(nonatomic) BOOL isPiled;
@end


@implementation SetGameViewController

static const CGFloat CARD_WIDTH = 40;
static const CGFloat CARD_HEIGHT = 60;
#define CARD_SIZE CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
#define DECK_SIZE 81
#define STARTING_CARDS_NUM 12
#define CARDS_NUM_ON_DEALING 3
#define MARGIN_BETWEEN_CARDS 4
#define CARD_MOVE_ANIMATION_DURATION 0.5
#define DELAY_BETWEEN_MOVES 0.5

#pragma mark -Inits

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    //flip screen recognizer
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //pinch screen recognizer
    UIPinchGestureRecognizer *pinchRecognizer =
        [[UIPinchGestureRecognizer alloc] initWithTarget: self action:@selector(pinch:) ];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    [self newGame];
}


- (void)orientationChanged:(NSNotification *)notification{
  [self resetCardsLocationTo:CGPointMake(-CARD_WIDTH ,-CARD_HEIGHT)];
  [self updateUI];
}

- (void) newGame {
  
  self.game = [[Game alloc]initWithCardCount:DECK_SIZE usingDeck:[self createDeck] playingGameType:@"SET!" cardsNumForMatch:3];
  self.boardView = [[GameBoardView alloc]init ];
  self.deckView = [[DeckView alloc]initWithFrame:CGRectZero ];
  self.drawCount = 0;
  
  [self setSubViews];

  [self constraintAllViews];
  [self.deckView layoutIfNeeded];
  
  self.cardViewArray = [self createCardViewArray];

  UITapGestureRecognizer *deckTapRecognizer =
  [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(deckTap:) ];
  [self.deckView addGestureRecognizer:deckTapRecognizer];

  [self.boardView layoutIfNeeded];
  [self dealNCards:STARTING_CARDS_NUM];
  [self updateUI];

}

- (void)setSubViews {
  
  [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.boardView];
  [self.boardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.scoreLabel];
  [self.view addSubview:self.resetButton];
  [self.view addSubview:self.deckView];

}

-(Deck *)createDeck {
  return [[SetCardDeck alloc] initWithSymbols:@[@"triangle",@"circle",@"square"] ];
}

- (NSMutableArray<SetCardView *> *)createCardViewArray {
  [self.deckView layoutIfNeeded];
  NSMutableArray *cardViewArray = [[NSMutableArray alloc]init];
  CGRect frame;
  frame.size = CARD_SIZE;
  frame.origin = [self.deckView convertPoint:self.deckView.bounds.origin toView:self.view];

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


#pragma mark -Constraints

- (void)constraintResetButton {
  self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.resetButton.widthAnchor constraintEqualToConstant:70].active = YES;
  [self.resetButton.leftAnchor constraintEqualToAnchor:self.boardView.leftAnchor].active = YES;
  [self.resetButton.topAnchor constraintEqualToAnchor:self.boardView.bottomAnchor constant:30].active = YES;
}

- (void)constraintScoreLabel {
  self.scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
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
  [self constraintDeckView];
  
}

#pragma mark -Updating

- (void) updateScoreLabel{
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

- (void)updateUI {
  
  [self checkAndRemoveCards];
  [self checkAndMoveCardsToBetterLocation];
  [self updateScoreLabel];
}



#pragma mark-Dealing

- (BOOL) isOKToDeal:(CGPoint)nextCardCenterLocation {
  return (nextCardCenterLocation.x != -1 && (self.drawCount < [self.game.cards count] ))  ;
}

- (int)dealNCards:(int)cardsNumToDeal {
  int cardsDealt = 0;
  for (int i = 0; i < cardsNumToDeal;i++){
    CGPoint nextCardCenterLocation = [self getNextCardCenterLocation];
    if ( [self isOKToDeal:nextCardCenterLocation ]  ) {
      cardsDealt++;
      [self dealCardTo:nextCardCenterLocation];
    }
  }
  return cardsDealt;
}

- (void)dealCardTo:(CGPoint)nextCardCenterLocation{
  

  SetCardView *cardView = self.cardViewArray[self.drawCount];
  cardView.index = self.drawCount++;
  
   UITapGestureRecognizer *cardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(cardTap:) ];
  [cardView addGestureRecognizer:cardTapRecognizer];
  
   UIPanGestureRecognizer *cardPanRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(cardPan:) ];
  [cardView addGestureRecognizer:cardPanRecognizer];
  
  
  [self.boardView addSubview:cardView];
  
  [self animateCardMovementToNewLocation:cardView usingLocation:nextCardCenterLocation];
  
}

#pragma mark-Gestures


- (IBAction)resetClick:(id)sender {
  [self newGame];
}

- (void)cardPan:(UITapGestureRecognizer *)gesture {
  if (!self.isPiled) {
    return;
  }
  CGPoint gestureLocation = [gesture locationInView:self.view];
  for (SetCardView *cardView in [self.boardView subviews]) {
    [self animateCardMovementToNewLocation:cardView usingLocation:gestureLocation];
  }
}

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
  
  if (![self isAllowToTap]){
    [self tapOnPile:[recognizer locationInView:self.view]];
    return;
  }
  
  SetCardView *tapedCardView = (SetCardView *) recognizer.view;
  
  [self.game chooseCardAtIndex:tapedCardView.index];
  [self updateUI];
  
}

- (BOOL) isAllowToTap{
  
  return !(self.isPiled);
}

- (void)tapOnPile:(CGPoint)location{
  self.isPiled = NO;
  [self resetCardsLocationTo:location];
  [self updateUI];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
  self.isPiled = YES;
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)) {
    for (SetCardView *cardView in [self.boardView subviews]) {
      [self animateCardMovementToNewLocation:cardView
                               usingLocation:[self centerOfScreen]];
    }
    gesture.scale = 1.0;
  }
  
}


#pragma mark -Locations

- (CGPoint)getNextCardCenterLocation {

  CGFloat startXSearchingValue =  MARGIN_BETWEEN_CARDS + (CARD_WIDTH / 2.0) ;
  CGFloat startYSearchingValue =  MARGIN_BETWEEN_CARDS + (CARD_HEIGHT / 2.0);

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

- (BOOL)isLocationFree:(CGPoint)point {
  if ([self isLocationOutOfBounds:point]) {
    return NO;
  }
  for (SetCardView *cardView in [self.boardView subviews]) {
    if (CGPointEqualToPoint(point, cardView.center) ) {
      return NO;
    }
  }
  return YES;
  
}

- (BOOL) isLocationOutOfBounds:(CGPoint)point {
  return (![self isLocationInGrid:point]) || (point.x < 0) || (point.x + CARD_WIDTH/2 >= self.boardView.bounds.size.width || point.y + CARD_HEIGHT/2 >= self.boardView.bounds.size.height);
}

- (BOOL) isLocationInGrid:(CGPoint)point {
 
  CGFloat startXSearchingValue =  MARGIN_BETWEEN_CARDS + (CARD_WIDTH / 2.0) ;
  CGFloat startYSearchingValue =  MARGIN_BETWEEN_CARDS + (CARD_HEIGHT / 2.0);

  CGFloat boardYLimit = self.boardView.frame.size.height;
  CGFloat boardXLimit = self.boardView.frame.size.width;
  
  for (int y = startYSearchingValue ; y < boardYLimit; y += (CARD_HEIGHT + MARGIN_BETWEEN_CARDS) ) {
    for (int x = startXSearchingValue; x < boardXLimit; x += (CARD_WIDTH + MARGIN_BETWEEN_CARDS) ) {
      if (CGPointEqualToPoint(point, CGPointMake(x, y))) {
        return YES;
      }
    }
  }
  
  return NO;
}

- (void)resetCardsLocationTo:(CGPoint)location {
  
  NSMutableArray<SetCardView *> *tempViewArray = [[NSMutableArray alloc]init ];
  
  for (SetCardView *cardView in [self.boardView subviews]) {
    [tempViewArray addObject:cardView];
    [cardView removeFromSuperview];
  }
  for (SetCardView *cardView in tempViewArray) {
    cardView.center = location;
    [self.boardView addSubview:cardView];
  }
  
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
  
  CGPoint nextCardLocation = [self getNextCardCenterLocation];

  if ([self isNewLocationBetterThanCurrentLocation:nextCardLocation currentLocation:cardView.center] ) {
    [self animateCardMovementToNewLocation:cardView usingLocation:nextCardLocation];
  }
}

- (BOOL)isNewLocationBetterThanCurrentLocation:(CGPoint)locationToCheckIfBetter currentLocation:(CGPoint)currentLocation {
  
  return ( [self isValidLocation:locationToCheckIfBetter] &&
          ( [self isLocationOutOfBounds:currentLocation] || [self isNewLocationBeforeThanCurrentLocation:locationToCheckIfBetter currentLocation:currentLocation ] )) ;
}

-(BOOL)isNewLocationBeforeThanCurrentLocation:(CGPoint)locationToCheckIfBefore currentLocation:(CGPoint)currentLocation {
  return ( (locationToCheckIfBefore.y < currentLocation.y) ||
      ( (locationToCheckIfBefore.x < currentLocation.x) && (locationToCheckIfBefore.y == currentLocation.y) ) );
}

- (BOOL)isValidLocation:(CGPoint)location{
  return (location.x != -1);
}


- (CGPoint)centerOfScreen {
  return self.view.center;
}

- (CGPoint) getLocationOfCardCloserToLocation:(SetCardView *)cardView location:(CGPoint)location scale:(CGFloat)scale {
  
  CGPoint currentLocation = cardView.center;
  CGPoint centerOfScreen = [self centerOfScreen];
  CGFloat xDistance  =  (currentLocation.x - centerOfScreen.x) * scale;
  CGFloat yDistance  =  (currentLocation.y - centerOfScreen.y) * scale;
  
  CGPoint newLocation = CGPointMake(centerOfScreen.x + xDistance, centerOfScreen.y + yDistance) ;
  
  return newLocation ;
}

- (void) viewWillLayoutSubviews {
  [self updateUI];
}

- (void)checkAndRemoveCards{
  
  for (SetCardView *cardView in [self.boardView subviews]) {
    SetCard *card = (SetCard *) [self.game cardAtIndex:cardView.index];
    cardView.faceUp = card.chosen;
    if (card.matched) {
      [self removeCardAndAnimate:cardView];
    }
  }
  
}

#pragma mark -Animation


- (void)animateCardMovementToNewLocation:(SetCardView *)cardView usingLocation:(CGPoint)newLocation  {

  [UIView animateWithDuration:CARD_MOVE_ANIMATION_DURATION
                   animations:^{cardView.center = newLocation;}
                   completion:nil
   ];
}

- (void)removeCardAndAnimate:(SetCardView *)cardView {
  
  CGPoint flyingCardLocation;
  flyingCardLocation.y = 0;
  flyingCardLocation.x = (arc4random() % (int)self.boardView.frame.size.width ) ;
  [self animateCardMovementToNewLocation:cardView usingLocation:flyingCardLocation];
  [cardView removeFromSuperview];
}









@end
