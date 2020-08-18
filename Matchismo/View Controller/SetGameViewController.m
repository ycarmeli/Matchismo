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
@property(strong,nonatomic) Game *game;

@end


@implementation SetGameViewController

static const CGFloat CARD_WIDTH = 40;
static const CGFloat CARD_HEIGHT = 60;
#define CARD_SIZE CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
#define DECK_SIZE 81
#define STARTING_CARDS_NUM 12

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newGame];
}

- (void) newGame{
  _game = [[Game alloc]initWithCardCount:DECK_SIZE usingDeck:[self createDeck] playingGameType:@"SET!" cardsNumForMatch:3];
//  _boardView = [[GameBoardView alloc]initWithFrame: [self calculateBoardRect] ];
  
  _deckView = [[DeckView alloc]initWithFrame:[self calculateBoardRect] ];
  
  NSLog(@"%f,%f,  %fX%f",
        _deckView.frame.origin.x,_deckView.frame.origin.x,_deckView.frame.size.height,_deckView.frame.size.width);

//  for (int i = 0 ;i < STARTING_CARDS_NUM; i++) {
//    [self dealCard];
//  }
}

- (CGRect)calculateBoardRect {
  CGRect frame;
  frame.origin = CGPointMake(0, 0);
  frame.size = CGSizeMake(10, 10);
  return frame;
  return CGRectMake(0, 0, 10, 10);
  //20,20,374,546
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


  [self.boardView addSubview:cardView];
  
//  NSLog([NSString stringWithFormat:@" %@ $$$$$ %d",[cardView.color description],cardView.fillType]);

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
  SetCard *card = (SetCard *)[self.game drawCard];
  
  cardView.color = card.color;
  cardView.symbol = card.symbol;
  cardView.numberOfSymbols = [card.numberOfSymbols intValue];
  cardView.fillType = card.fillType;
  
  NSLog([cardView description]);
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

- (IBAction)deckTap:(id)sender {
  if ([self getNextCardLocation].x != -1) {
    [self dealCard];
  }
}



@end
