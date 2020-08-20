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
@property(strong, nonatomic) Game* game;
@property(strong, nonatomic) NSArray<PlayingCardView *> *cardViewArray;
@property(nonatomic) BOOL isPiled;
@end

@implementation CardMatchingViewController

static const CGFloat CARD_WIDTH = 40;
static const CGFloat CARD_HEIGHT = 60;
#define CARD_SIZE CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
#define MARGIN_BETWEEN_CARDS 4
#define DECK_SIZE 52
#define CARD_MOVE_ANIMATION_DURATION 0.5
#define DELAY_BETWEEN_MOVES 1

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


- (void)orientationChanged:(NSNotification *)notification {
  [self resetCardsLocation];
  [self updateUI];
}

-(void)newGame {
  
  self.isPiled = NO;
  self.game = [[Game alloc]initWithCardCount:DECK_SIZE usingDeck:[self createDeck] playingGameType:@"Matching Cards" cardsNumForMatch:3];
  self.boardView = [[GameBoardView alloc]init ];

  [self setSubViews];
  [self constraintAllViews];
  self.cardViewArray = [self createCardViewArray];
  
  
  [self.boardView layoutIfNeeded];
  [self dealNCards:DECK_SIZE];
  
  [self updateUI];
}

- (void)setSubViews {
  
  [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.boardView];
  [self.boardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.view addSubview:self.scoreLabel];
  [self.view addSubview:self.resetButton];
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

-(Deck*) createDeck{
    return [[PlayingCardDeck alloc]init];
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

- (void)constraintAllViews {
  
  [self constraintBoardView];
  [self constraintResetButton];
  [self constraintScoreLabel];
}

#pragma mark -Updating

- (void)updateUI {
  [self checkAndRemoveCards];
  [self checkAndMoveCardsToBetterLocation];
  [self updateScoreLabel];
}


- (void)updateScoreLabel{
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

#pragma mark -Dealing

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
  cardView.index = index;
  
   UITapGestureRecognizer *cardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(cardTap:) ];
  [cardView addGestureRecognizer:cardTapRecognizer];
  
   UIPanGestureRecognizer *cardPanRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(cardPan:) ];
  [cardView addGestureRecognizer:cardPanRecognizer];
  
  [self.boardView addSubview:cardView];

  [self animateCardMovementToNewLocation:cardView usingLocation:nextCardCenterLocation];

}


#pragma mark -Gestures

- (IBAction)resetClick:(id)sender {
    [self newGame];
}

- (void)cardPan:(UITapGestureRecognizer *)gesture {
  if (!self.isPiled) {
    return;
  }
  CGPoint gestureLocation = [gesture locationInView:self.view];
  for (PlayingCardView *cardView in [self.boardView subviews]) {
    [self animateCardMovementToNewLocation:cardView usingLocation:gestureLocation];
  }
}

- (void)cardTap:(UITapGestureRecognizer *)gesture {
  
  if (![self isAllowToTap]){
    [self tapOnPile];
    return;
  }
    
  PlayingCardView *tapedCardView = (PlayingCardView *) gesture.view;
  
  [UIView transitionWithView:tapedCardView duration:0.5
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations:^{
                    if (!tapedCardView.faceUp){
                      tapedCardView.faceUp = !tapedCardView.faceUp;
                    }
                  }
                  completion:nil];
  
  [self.game chooseCardAtIndex:(int)[self.cardViewArray indexOfObject:tapedCardView]];
  [self updateUI];
  
}

- (BOOL) isAllowToTap{
  
  return !(self.isPiled);
}

- (void)tapOnPile{
  self.isPiled = NO;
  [self resetCardsLocation];
  [self updateUI];
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture {
  self.isPiled = YES;
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)) {
    for (PlayingCardView *cardView in [self.boardView subviews]) {
      [self animateCardMovementToNewLocation:cardView
                               usingLocation:[self getLocationOfCardCloserToLocation:cardView location:[self centerOfScreen] scale:gesture.scale ]];
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
  for (PlayingCardView *cardView in [self.boardView subviews]) {
    if (CGPointEqualToPoint(point, cardView.center) ) {
      return NO;
    }
  }
  return YES;
}

- (BOOL) isLocationOutOfBounds:(CGPoint)point {
  return (point.x < 0)||(point.x + CARD_WIDTH/2 >= self.boardView.bounds.size.width || point.y + CARD_HEIGHT/2 >= self.boardView.bounds.size.height);
}

- (void)resetCardsLocation {
  
  NSMutableArray<PlayingCardView *> *tempViewArray = [[NSMutableArray alloc]init ];
  
  for (PlayingCardView *cardView in [self.boardView subviews]) {
    [tempViewArray addObject:cardView];
    [cardView removeFromSuperview];
  }
  for (PlayingCardView *cardView in tempViewArray) {
    cardView.center = CGPointMake(-CARD_WIDTH ,-CARD_HEIGHT);
    [self.boardView addSubview:cardView];
  }
  
}

- (void)checkAndMoveCardsToBetterLocation {
  
  for (int i =0;i <[self.game.cards count];i++) { // check by order of dealing
    PlayingCardView *cardView = self.cardViewArray[i];
    if ([[self.boardView subviews] containsObject:cardView]) {
      [self checkAndMoveCardToBetterLocation:cardView];
    }
  }
}


- (void)checkAndMoveCardToBetterLocation: (PlayingCardView *)cardView {
  
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

- (CGPoint) getLocationOfCardCloserToLocation:(PlayingCardView *)cardView location:(CGPoint)location scale:(CGFloat)scale {
  
  CGPoint currentLocation = cardView.center;
  CGPoint centerOfScreen = [self centerOfScreen];
  CGFloat xDistance  =  (currentLocation.x - centerOfScreen.x) * scale;
  CGFloat yDistance  =  (currentLocation.y - centerOfScreen.y) * scale;
  
  CGPoint newLocation = CGPointMake(centerOfScreen.x + xDistance, centerOfScreen.y + yDistance) ;
  
  return newLocation ;
}


-(NSString*)backgroundImageNameOfCard: (Card*)card{
    return card.chosen? @"cardFront" : @"cardBack" ;
}
-(NSString*)titleOfCard: (Card*)card{
    return card.chosen? card.contents : @"" ;
}



- (void) viewWillLayoutSubviews {
  [self updateUI];
}



- (void)checkAndRemoveCards {
  
  for (PlayingCardView *cardView in [self.boardView subviews]) {
    PlayingCard *card = (PlayingCard *) [self.game cardAtIndex:(int)[self.cardViewArray indexOfObject:cardView]];
    cardView.faceUp = card.chosen;
    [cardView setBackgroundColorByChosen:card.chosen];
    if (card.matched) {
      [self removeCardAndAnimate:cardView];
    }
  }
}

#pragma mark -Animations

- (void)removeCardAndAnimate:(PlayingCardView *)cardView {

  [UIView animateWithDuration:CARD_MOVE_ANIMATION_DURATION
                        delay:DELAY_BETWEEN_MOVES
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
    cardView.alpha = 0.0;
                  }
                   completion:^(BOOL finished){
                    if (finished) {
                      [cardView removeFromSuperview];
                      [self updateUI];
                    }
                  }

   ];
}

- (void)animateCardMovementToNewLocation:(PlayingCardView *)cardView usingLocation:(CGPoint)newLocation{
  
  [UIView animateWithDuration:CARD_MOVE_ANIMATION_DURATION
                   animations:^{
                    cardView.center = newLocation;
                  }
                   completion:nil
   ];
}



@end
