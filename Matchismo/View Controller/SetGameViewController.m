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
#import "GameFrameView.h"

@class Deck;
@class SetCardDeck;
@class SetCard;
@class HistoryViewController;

@interface SetGameViewController()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet GameFrameView *gameFrame;
@property (weak, nonatomic) IBOutlet SetCardView *tempCard;


@property(strong,nonatomic) Game *game;

@end


@implementation SetGameViewController

static const CGFloat CARD_WIDTH = 60;
static const CGFloat CARD_HEIGHT = 90;
#define CARD_SIZE CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
#define DECK_SIZE 81
#define STARTING_CARDS_NUM 12

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newGame];
}

- (void) newGame{
//  _gameFrame = [GameFrameView alloc]init;
  _game = [[Game alloc]initWithCardCount:DECK_SIZE usingDeck:[self createDeck] playingGameType:@"SET!" cardsNumForMatch:3];
//  [self loadCards];
//  [self updateUI];
//  [self createCard];
//  for (int i = 0 ;i < STARTING_CARDS_NUM; i++){
//    [self dealCard];
//  }
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
  [self.gameFrame addSubview:cardView];
  
//  NSLog([NSString stringWithFormat:@" %@ $$$$$ %d",[cardView.color description],cardView.fillType]);

}

- (void)emptyDeckBehavior{
  return; //TODO
}


#define MARGIN_BETWEEN_CARDS 5

- (CGPoint)getNextCardLocation {
  
  CGFloat startXSearchingValue = (CARD_HEIGHT / 2.0) + MARGIN_BETWEEN_CARDS;
  CGFloat startYSearchingValue = (CARD_WIDTH / 2.0) + MARGIN_BETWEEN_CARDS;
  for (int y = startXSearchingValue ; y < self.gameFrame.bounds.size.width; y += (CARD_HEIGHT + MARGIN_BETWEEN_CARDS) ) {
    for (int x = startYSearchingValue; x < self.gameFrame.bounds.size.height; x += (CARD_WIDTH + MARGIN_BETWEEN_CARDS) ) {
      UIView *checkView = [self.gameFrame hitTest:CGPointMake(x, y) withEvent:NULL];
      if ([checkView superview] == self.gameFrame ) {
        NSLog([NSString stringWithFormat:@"[%d,%d]",x,y  ]);
        return CGPointMake(x - (CARD_WIDTH / 2.0) , y - (CARD_HEIGHT / 2.0));
      }
    }
  }
  
  return CGPointMake(-1, -1);
  
}


- (SetCardView *) createSetCardView:(CGRect)frame {
  
  SetCardView *cardView = [[SetCardView alloc]initWithFrame:frame];
  SetCard *card = (SetCard *)[self.game drawCard];
  
  cardView.color = [self colorAtIndex:card.color];
  cardView.symbol = card.symbol;
  cardView.numberOfSymbols = [card.numberOfSymbols intValue];
  cardView.fillType = card.fillType;
  
  
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

- (void)createCard {
  self.tempCard.numberOfSymbols = 2;
  self.tempCard.symbol = @"triangle";
  self.tempCard.color = [UIColor orangeColor];
  self.tempCard.fillType = 2;
  
}

//- (void) loadCards{
//
//  for (UIButton *cardButton in self.cardButtons){
//
//    int buttonIndex =(int) [self.cardButtons indexOfObject:cardButton];
//    SetCard *card = (SetCard *) [self.game cardAtIndex:buttonIndex];
//  //  [cardButton setAttributedTitle:[self cardToString:card] forState:UIControlStateNormal];
//    [cardButton setTitleColor:[self cardToColor:card] forState:UIControlStateNormal];
//    [cardButton setAttributedTitle: [self cardToAttributedTitle:card] forState:UIControlStateNormal ];
//  }
//
//
//}
//- (IBAction)cardClick:(id)sender {
//
//  int buttonIndex = (int)[self.cardButtons indexOfObject:sender];
//  [self.game chooseCardAtIndex:buttonIndex];
//
//  [self updateUI];
//}
//
//- (void)updateUI {
//  for (UIButton* cardButton in self.cardButtons) {
//    cardButton.titleLabel. numberOfLines = 3; // Dynamic number of lines
//    int buttonIndex =(int) [self.cardButtons indexOfObject:cardButton];
//    Card* card = [self.game cardAtIndex:buttonIndex];
//    cardButton.enabled = !card.matched && !card.chosen;
//    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d",self.game.score]];
//    [self.matchResultLabel setText: [self.game.matchResults[0].resultStringsArray componentsJoinedByString:@"\n"]   ];
//
//
//  }
//}

#define FILL_FULL 3
#define FILL_EMPTY 1
#define FILL_HALF 2

//- (NSAttributedString *)cardToAttributedTitle:(SetCard *)card {
//
//  if (card.fillType == FILL_FULL){
//    return [[NSAttributedString alloc] initWithString:[self cardToString:card] attributes: @{NSStrokeColorAttributeName: [self cardToColor:card],NSStrokeWidthAttributeName:@-3,NSForegroundColorAttributeName:[self cardToColor:card] }];
//  }
//  if (card.fillType == FILL_EMPTY){
//    return [[NSAttributedString alloc] initWithString:[self cardToString:card] attributes: @{NSStrokeColorAttributeName: [self cardToColor:card],NSStrokeWidthAttributeName:@3 }];
//
//    //return [NSString stringWithFormat:@"%@%@",card.symbol,card.symbol];
//  }
//  if (card.fillType == FILL_HALF){
//    return [[NSAttributedString alloc] initWithString:[self cardToString:card] attributes: @{NSStrokeColorAttributeName: [self cardToColor:card],NSStrokeWidthAttributeName:@21 }];
//    //return [NSString stringWithFormat:@"%@%@%@",card.symbol,card.symbol, card.symbol];
//  }
//
//  return nil;
//}
//
//- (NSString *)cardToString:(SetCard *)card{
//
//  if ([card.numberOfSymbols isEqualToString:@"1"]){
//    return card.symbol;
//  }
//  if ([card.numberOfSymbols isEqualToString:@"2"]){
//    return [NSString stringWithFormat:@"%@\n%@",card.symbol,card.symbol];
//  }
//  if ([card.numberOfSymbols isEqualToString:@"3"]){
//    return [NSString stringWithFormat:@"%@\n%@\n%@",card.symbol,card.symbol, card.symbol];
//  }

//  return @"";
//}

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


- (NSArray *)getGameHistory {
  
  NSMutableArray<NSString *> *gameHistory = [[NSMutableArray alloc]init];
  
  for (int i = 0;i < [self.game.matchResults count] -1; i++){
    MatchResult *matchResult = self.game.matchResults[i];
    NSString * history = [NSString stringWithFormat:@"ø %@ scored %d points beacuse %@",
        [matchResult matchedCardsToOneString] ,matchResult.score, [matchResult.resultStringsArray componentsJoinedByString:@", " ]  ];
    [gameHistory addObject:history];
  }
  
  return gameHistory;
  
}


- (IBAction)deckTap:(id)sender {
  [self dealCard];
}



@end
