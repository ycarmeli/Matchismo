//
//  ViewController.m
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import "CardMatchingViewController.h"
#import "PlayingCardDeck.h"
#import "Game.h"
#import "PlayingCardView.h"
#import "GameBoardView.h"

@class HistoryViewController;

@interface CardMatchingViewController ()
@property(weak, nonatomic) IBOutlet UIButton *resetButton;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(strong, nonatomic) IBOutlet GameBoardView *boardView;
@property(strong,nonatomic) Game* game;
@property(strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray<PlayingCardView *> *cardViewArray;

@property (strong, nonatomic) UIDynamicAnimator *animator;


@end

@implementation CardMatchingViewController

static const CGFloat CARD_WIDTH = 40;
static const CGFloat CARD_HEIGHT = 60;
#define CARD_SIZE CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
#define MARGIN_BETWEEN_CARDS 5
#define DECK_SIZE 52
#define CARD_DEAL_ANIMATION_DURATION 0.5
#define DELAY_BETWEEN_DEALS 0.5

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self newGame];
  _image = [[UIImage alloc]init];
  _image = [UIImage imageNamed:@"cardBack"];
}

-(Deck*) createDeck{
    return [[PlayingCardDeck alloc]init];
}

- (void)constraintResetButton {
  [self.resetButton.widthAnchor constraintEqualToConstant:70].active = YES;
}

- (void)constraintBoardView {
  
  self.boardView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.boardView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = YES;
  [self.boardView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20].active = YES;

  /* Fixed width */
  NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.boardView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:-40];
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

- (void)constraintAllViews {
  
  [self constraintResetButton];
  [self constraintBoardView];
  
}

- (void)orientationChanged:(NSNotification *)notification{
  [self updateUI];
}



-(void)newGame {
    
  
    _game = [[Game alloc]initWithCardCount:DECK_SIZE usingDeck:[self createDeck] playingGameType:@"Matching Cards" cardsNumForMatch:3];
  
   self.boardView = [[GameBoardView alloc]init ];
  
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
  
  [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.boardView];
  [self.boardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.scoreLabel];
  [self.view addSubview:self.resetButton];
  
  [self constraintAllViews];
  self.cardViewArray = [self createCardViewArray];
  
  
  [self.boardView layoutIfNeeded];
  [self dealNCards:DECK_SIZE];
  
  [self updateUI];
}

- (NSMutableArray<PlayingCardView *> *)createCardViewArray {

  NSMutableArray *cardViewArray = [[NSMutableArray alloc]init];
  CGRect frame;
  frame.size = CARD_SIZE;
  frame.origin = CGPointZero;
  for (PlayingCard *card in self.game.cards ) {
    PlayingCardView *cardView = [self createPlayCardViewFromPlayCard:card usingFrame:frame];
    [cardViewArray addObject:cardView];
  }
  
  return cardViewArray;
}

- (NSUInteger)stringRankToIndex:(NSString *)rank {
  
  return [[PlayingCard validRanks] indexOfObject:rank] + 1;
}

- (PlayingCardView *) createPlayCardViewFromPlayCard:(PlayingCard *)card usingFrame:(CGRect)frame {
    
  PlayingCardView *cardView = [[PlayingCardView alloc]initWithFrame:frame];
  cardView.rank = [self stringRankToIndex:card.rank];
  cardView.suit = card.suit;
  cardView.faceUp = YES;
  return cardView;
}





- (void)updateUI {//TODO
  
  [self checkAndRemoveCards];
  [self checkAndMoveCardsToBetterLocation];
  [self updateScoreLabel];
}

- (void)updateScoreLabel{
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

- (BOOL) isOKToDeal:(CGPoint)nextCardCenterLocation {
  return (nextCardCenterLocation.x != -1)  ;
}

- (int)dealNCards:(int)cardsNumToDeal {
  int cardsDealt = 0;
  for (int i = 0; i < cardsNumToDeal;i++){
    CGPoint nextCardCenterLocation = [self getNextCardCenterLocation];
    if ( [self isOKToDeal:nextCardCenterLocation ]  ) {
      cardsDealt++;
      [self dealCardITo:nextCardCenterLocation usingIndex:i];
    }
  }
  return cardsDealt;
}

- (void)dealCardITo:(CGPoint)nextCardCenterLocation usingIndex:(int)index {

  PlayingCardView *cardView = self.cardViewArray[index];
  
   UITapGestureRecognizer *cardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(cardTap:) ];
  [cardView addGestureRecognizer:cardTapRecognizer];
  

  [self.boardView addSubview:cardView];
  
  [self animateCardMovementToNewLocation:cardView usingLocation:nextCardCenterLocation];

}

- (void)cardTap:(UITapGestureRecognizer *)recognizer {
  
  if (recognizer.state == UIGestureRecognizerStateEnded) {//TODO
    
    PlayingCardView *tapedCardView = (PlayingCardView *) recognizer.view;
    
    [UIView transitionWithView:tapedCardView duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                      if (!tapedCardView.faceUp){
                        tapedCardView.faceUp = !tapedCardView.faceUp;
                      }
                    }
                    completion:nil];
    
    
    
    [self.game chooseCardAtIndex:[self.cardViewArray indexOfObject:tapedCardView]];
    [self updateUI];
  }
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

- (void)checkAndMoveCardsToBetterLocation {
  
  for (int i =0;i <[self.game.cards count];i++) { // check by order of dealing
    PlayingCardView *cardView = self.cardViewArray[i];
    if ([[self.boardView subviews] containsObject:cardView]) {
      [self checkAndMoveCardToBetterLocation:cardView];
    }
  }

}

- (void)animateCardMovementToNewLocation:(PlayingCardView *)cardView usingLocation:(CGPoint)newLocation{
  
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

- (void)checkAndMoveCardToBetterLocation: (PlayingCardView *)cardView {
  
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


-(NSString*)backgroundImageNameOfCard: (Card*)card{
    return card.chosen? @"cardFront" : @"cardBack" ;
}
-(NSString*)titleOfCard: (Card*)card{
    return card.chosen? card.contents : @"" ;
}

- (IBAction)resetClick:(id)sender {
    [self newGame];
}


- (void)removeCardAndAnimate:(PlayingCardView *)cardView {
  
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
  
  for (PlayingCardView *cardView in [self.boardView subviews]) {
    PlayingCard *card = (PlayingCard *) [self.game cardAtIndex:[self.cardViewArray indexOfObject:cardView]];
    cardView.faceUp = card.chosen;
    [cardView setBackgroundColorByChosen:card.chosen];
    if (card.matched) {
      [self removeCardAndAnimate:cardView];
    }
  }

}



@end
