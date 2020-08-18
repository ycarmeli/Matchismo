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
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property(strong,nonatomic) Game *game;

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
  
  [self.gameView addSubview:_boardView];
  [self.gameView addSubview:_deckView];
  
  UITapGestureRecognizer *deckTapRecognizer =
  [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(deckTap:) ];
  [self.deckView addGestureRecognizer:deckTapRecognizer];

  [self dealNCards:STARTING_CARDS_NUM];
  
  
}

- (CGRect)calculateBoardRect {
//  CGRect frame;
//  frame.origin = CGPointMake(0, 0);
//  frame.size = CGSizeMake(10, 10);
//  return frame;
  return CGRectMake(20, 20, 374, 546);
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

- (void)dealNCards:(int)N {
  for (int i = 0; i < N;i++){
    if ([self getNextCardLocation].x != -1) {
      [self dealCard];
    }
  }
}

- (void)dealCard {
  
  CGRect frame;
  frame.size = CARD_SIZE;
  CGPoint cardLocation = [self getNextCardLocation];
  if (cardLocation.x == -1) {
    [self emptyDeckBehavior];
  }
  frame.origin = cardLocation;

  SetCardView *cardView = [self createSetCardView:frame];


  
   UITapGestureRecognizer *cardTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(cardTap:) ];
  [cardView addGestureRecognizer:cardTapRecognizer];
  

  [self.boardView addSubview:cardView];

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
  if (point.x + CARD_WIDTH >= self.boardView.bounds.size.width || point.y + CARD_HEIGHT >= self.boardView.bounds.size.height) {
    return NO;
  }
  for (UIView *cardView in [self.boardView subviews]) {
    if (cardView.frame.origin.x == point.x && cardView.frame.origin.y == point.y  ) {
      return NO;
    }
  }
  return YES;
  
}


- (SetCardView *) createSetCardView:(CGRect)frame {
  
  SetCardView *cardView = [[SetCardView alloc]initWithFrame:frame];
  int cardIndex = [[self.boardView subviews] count];
  SetCard *card = (SetCard *)[self.game cardAtIndex:cardIndex];
  
  cardView.color = card.color;
  cardView.symbol = card.symbol;
  cardView.numberOfSymbols = [card.numberOfSymbols intValue];
  cardView.fillType = card.fillType;
  cardView.index = cardIndex;
  
  return cardView;
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
  
  [self dealNCards:CARDS_NUM_ON_DEALING];
  
}

- (void)cardTap:(UITapGestureRecognizer *)recognizer {
  
  SetCardView *tapedCardView = (SetCardView *) recognizer.view;
  NSLog([tapedCardView description]);
  CGPoint tapLocation = [recognizer locationInView:self.boardView];
  NSLog(@"[%d,%d]",  (int)tapLocation.x,(int)tapLocation.y);
  
  SetCardView *temp = [self.game cardAtIndex:tapedCardView.index];
  NSLog([temp description]);
  
  
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
  
}

- (void)removeCardView: (SetCardView *)cardView {
  [cardView removeFromSuperview];
}

- (void)checkAndMoveToBetterLocation: (SetCardView *)cardView {
  
  
  CGPoint nextCardLocation = [self getNextCardLocation];
  if ([self isPointBetterThanOtherPoint:cardView.frame.origin otherPoint:nextCardLocation] ) {
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
