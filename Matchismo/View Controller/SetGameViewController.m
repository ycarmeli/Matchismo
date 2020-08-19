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
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (strong, nonatomic) IBOutlet GameBoardView *boardView;
@property (strong, nonatomic) IBOutlet DeckView *deckView;
@property (weak, nonatomic) IBOutlet UIView *gameView;
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
#define MARGIN_BETWEEN_CARDS 5


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newGame];
}

- (void) newGame{
  _game = [[Game alloc]initWithCardCount:DECK_SIZE usingDeck:[self createDeck] playingGameType:@"SET!" cardsNumForMatch:3];
  _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
  _boardView = [[GameBoardView alloc]initWithFrame: [self calculateBoardRect] ];
  _deckView = [[DeckView alloc]initWithFrame:[self calculateDeckRect] ];
  _drawCount = 0;
  _cardViewArray = [self createCardViewArray];
  
  [self.gameView addSubview:_boardView];
  [self.gameView addSubview:_deckView];
  [self.gameView addSubview:self.scoreLabel];

  UITapGestureRecognizer *deckTapRecognizer =
  [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(deckTap:) ];
  [self.deckView addGestureRecognizer:deckTapRecognizer];

  
  

  DELAY(2.0);
  
  [self dealNCards:STARTING_CARDS_NUM];
  [self updateUI];

  
}

- (NSMutableArray<SetCardView *> *)createCardViewArray{
  
  NSMutableArray *cardViewArray = [[NSMutableArray alloc]init];
  CGRect frame;
  frame.size = CARD_SIZE;
  frame.origin = self.deckView.frame.origin;
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

- (CGRect)calculateBoardRect {
//  CGRect frame;
//  frame.origin = CGPointMake(0, 0);
//  frame.size = CGSizeMake(10, 10);
//  return frame;
  return CGRectMake(20, 20, 374, 546); //TODO
  //20,20,374,546
}

- (CGRect)calculateDeckRect {
  
  CGRect frame;
  CGFloat deckOriginX = self.boardView.frame.size.width - CARD_WIDTH;
  CGFloat deckOriginY = self.boardView.frame.size.height + MARGIN_BETWEEN_CARDS ;
  deckOriginX += self.boardView.frame.origin.x;
  deckOriginY += self.boardView.frame.origin.y;


  frame.origin = CGPointMake(deckOriginX,deckOriginY);
  frame.size = CARD_SIZE;
  return frame;

}

- (int)dealNCards:(int)cardsNumToDeal {
  int cardsDealt = 0;
  for (int i = 0; i < cardsNumToDeal;i++){
    if ([self getNextCardLocation].x != -1 && (self.drawCount< [self.game.cards count] )  ) {
      cardsDealt++;
      [self dealCard];
    }
  }
  return cardsDealt;
}

- (void)dealCard {
  
  CGPoint cardLocation = [self getNextCardLocation];
  if (cardLocation.x == -1) {
    [self emptyDeckBehavior]; //TODO// NO MORE ROOM FOR CARDS
  }

  SetCardView *cardView = self.cardViewArray[self.drawCount];
  cardView.index = self.drawCount++;
  
//  CGRect updatedFrame;
//  updatedFrame.size = cardView.frame.size;
//  updatedFrame.origin = cardLocation;
//  cardView.frame = updatedFrame;
  
   UITapGestureRecognizer *cardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(cardTap:) ];
  [cardView addGestureRecognizer:cardTapRecognizer];
  

  [self.boardView addSubview:cardView];
  
  [self animateCardMovementToNewLocation:cardView usingLocation:cardLocation];

}

#define CARD_DEAL_ANIMATION_DURATION 0.5
#define DELAY_BETWEEN_DEAL 0.5


- (void)animateCardMovementToNewLocation:(SetCardView *)cardView usingLocation:(CGPoint)newLocation{
  
  CGPoint newCenterLocation = [self getCenterPointFromOrigin:newLocation];
  
// [ UIView animateWithDuration:CARD_DEAL_ANIMATION_DURATION
//                        delay:CARD_DEAL_ANIMATION_DURATION
//                      options:UIViewAnimationOptionLayoutSubviews
//                   animations:^{
//                    cardView.center = newCenterLocation;
//                    }
//                   completion:^(BOOL finished){}
//  ];
  
  
  
  [UIView animateWithDuration:CARD_DEAL_ANIMATION_DURATION
                   animations:^{
                    cardView.center = newCenterLocation;
                  }
                   completion:^(BOOL finished){
                    if (finished) {
                      //TODO- getNextAnimation?
                    //  [cardView performSelector:@selector(nothing) withObject:nil afterDelay:DELAY_BETWEEN_DEAL];
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

- (void)emptyDeckBehavior{
  
  NSLog(@"EMPTY DECK");
  
  return; //TODO
}


#define MARGIN_BETWEEN_CARDS 5

- (CGPoint)getNextCardLocation {

  CGFloat startXSearchingValue =  MARGIN_BETWEEN_CARDS;
  CGFloat startYSearchingValue =  MARGIN_BETWEEN_CARDS;
  for (int y = startXSearchingValue ; y < self.boardView.bounds.size.height; y += (CARD_HEIGHT + MARGIN_BETWEEN_CARDS) ) {
    for (int x = startYSearchingValue; x < self.boardView.bounds.size.width; x += (CARD_WIDTH + MARGIN_BETWEEN_CARDS) ) {
      if ([self isPointFree:CGPointMake(x, y)]) {
        return CGPointMake(x  , y );
      }
    }
  }
  
  return CGPointMake(-1, -1);
  
}

- (BOOL)isPointFree:(CGPoint)point {
  if ([self isPointOutOfBounds:point]) {
    return NO;
  }
  for (UIView *cardView in [self.boardView subviews]) {
    if (CGPointEqualToPoint(point, cardView.frame.origin) ) {
      return NO;
    }
  }
  return YES;
  
}

- (BOOL) isPointOutOfBounds:(CGPoint)point {
  return (point.x + CARD_WIDTH >= self.boardView.bounds.size.width || point.y + CARD_HEIGHT >= self.boardView.bounds.size.height);
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

- (NSAttributedString *)cardToFill:(SetCard *)card {
  
  return nil;
  
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
}

- (void)cardTap:(UITapGestureRecognizer *)recognizer {
  
  SetCardView *tapedCardView = (SetCardView *) recognizer.view;

  CGPoint tapLocation = [recognizer locationInView:self.boardView];
  NSLog(@"[%d,%d]",  (int)tapLocation.x,(int)tapLocation.y);

  
  [self.game chooseCardAtIndex:tapedCardView.index];
  [self updateUI];
  [tapedCardView tap];

}

- (void)updateUI {
  
  for (SetCardView *cardView in [self.boardView subviews]) {
    
    SetCard *card = (SetCard *) [self.game cardAtIndex:cardView.index];
    [cardView setBackgroundColorByChosen:card.chosen];
    if (card.matched) {
      [self removeCardView:cardView];
    }
  }
  
  for (SetCardView *cardView in [self.boardView subviews]) {
    [self checkAndMoveToBetterLocation:cardView];
  }
  
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
  [self.gameView addSubview:self.deckView];
  if (self.drawCount == [self.game.cards count]) {
    [self.deckView removeFromSuperview];
  }
  NSLog(@"draws:%d",self.drawCount);
}

- (void)removeCardView: (SetCardView *)cardView {
  [cardView removeFromSuperview];
}

- (void)checkAndMoveToBetterLocation: (SetCardView *)cardView {
  
  
  CGPoint nextCardLocation = [self getNextCardLocation];
  if (nextCardLocation.x == -1  || [self isPointBetterThanOtherPoint:cardView.frame.origin otherPoint:nextCardLocation] ) {
    return;
  }
  CGRect frame;
  frame.size = cardView.frame.size;
  frame.origin = [self getNextCardLocation];
  cardView.frame = frame;
  
  
}

- (BOOL)isPointBetterThanOtherPoint:(CGPoint)point1 otherPoint:(CGPoint)point2 {
  
  return ( (point1.y < point2.y) ||
     ( ( point1.x < point2.x) && (point1.y == point2.y) )    ) ;
}






@end
