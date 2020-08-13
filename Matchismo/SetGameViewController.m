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
#import "HistoryViewController.h"
#import "Game.h"

@class Deck;
@class SetCardDeck;
@class SetCard;
@class HistoryViewController;

@interface SetGameViewController()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;


@property(strong,nonatomic) Game *game;

@end


@implementation SetGameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newGame];
}

- (void) newGame{
  
  _game = [[Game alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] playingGameType:@"SET!" cardsNumForMatch:3];
  [self loadCards];
  [self updateUI];
}

- (void) loadCards{
  
  for (UIButton *cardButton in self.cardButtons){
    
    int buttonIndex =(int) [self.cardButtons indexOfObject:cardButton];
    SetCard *card = (SetCard *) [self.game cardAtIndex:buttonIndex];
  //  [cardButton setAttributedTitle:[self cardToString:card] forState:UIControlStateNormal];
    [cardButton setTitleColor:[self cardToColor:card] forState:UIControlStateNormal];
    [cardButton setAttributedTitle: [self cardToAttributedTitle:card] forState:UIControlStateNormal ];
  }
  
  
}
- (IBAction)cardClick:(id)sender {
  
  int buttonIndex = (int)[self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:buttonIndex];
  
  [self updateUI];
}

-(void)updateUI{
    for (UIButton* cardButton in self.cardButtons) {
      cardButton.titleLabel. numberOfLines = 3; // Dynamic number of lines
      int buttonIndex =(int) [self.cardButtons indexOfObject:cardButton];
      Card* card = [self.game cardAtIndex:buttonIndex];
      cardButton.enabled = !card.matched && !card.chosen;
      [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d",self.game.score]];
      [self.matchResultLabel setText: [self.game.matchResults[0].resultStringsArray componentsJoinedByString:@"\n"]   ];
      
        
    }
}

- (NSAttributedString *)cardToAttributedTitle:(SetCard *)card{
  
  if ([card.fillType isEqualToString:@"Full"]){
    return [[NSAttributedString alloc] initWithString:[self cardToString:card] attributes: @{NSStrokeColorAttributeName: [self cardToColor:card],NSStrokeWidthAttributeName:@-3,NSForegroundColorAttributeName:[self cardToColor:card] }];
  }
  if ([card.fillType isEqualToString:@"Empty"]){
    return [[NSAttributedString alloc] initWithString:[self cardToString:card] attributes: @{NSStrokeColorAttributeName: [self cardToColor:card],NSStrokeWidthAttributeName:@3 }];

    //return [NSString stringWithFormat:@"%@%@",card.symbol,card.symbol];
  }
  if ([card.fillType isEqualToString:@"Half"]){
    return [[NSAttributedString alloc] initWithString:[self cardToString:card] attributes: @{NSStrokeColorAttributeName: [self cardToColor:card],NSStrokeWidthAttributeName:@21 }];
    //return [NSString stringWithFormat:@"%@%@%@",card.symbol,card.symbol, card.symbol];
  }

  return nil;
}

- (NSString *)cardToString:(SetCard *)card{
  
  if ([card.numberOfSymbols isEqualToString:@"1"]){
    return card.symbol;
  }
  if ([card.numberOfSymbols isEqualToString:@"2"]){
    return [NSString stringWithFormat:@"%@\n%@",card.symbol,card.symbol];
  }
  if ([card.numberOfSymbols isEqualToString:@"3"]){
    return [NSString stringWithFormat:@"%@\n%@\n%@",card.symbol,card.symbol, card.symbol];
  }

  return @"";
}


- (UIColor *)cardToColor:(SetCard *)card{
  if ([card.color isEqualToString:@"R"]){
    return [UIColor redColor];
  }
  if ([card.color isEqualToString:@"G"]){
    return [UIColor greenColor];
  }
  if ([card.color isEqualToString:@"B"]){
    return [UIColor blueColor];
  }
  return [UIColor blueColor];
}

- (NSAttributedString *)cardToFill:(SetCard *)card{
  
  return nil;
}
- (IBAction)resetClick:(id)sender {
  [self newGame];
}



-(Deck *)createDeck{

  return [[SetCardDeck alloc] init ];
  
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
  if ([segue.identifier isEqualToString:@"History of SET!"   ]){
    if ([segue.destinationViewController isKindOfClass:[HistoryViewController class] ]){
      HistoryViewController *historyVC = (HistoryViewController *) segue.destinationViewController;
      historyVC.history = [[self getGameHistory] componentsJoinedByString:@"\n\n"];
      historyVC.headline = @"Score History Of SET!:";

    }
  }
}

- (NSArray *)getGameHistory{
  
  NSMutableArray<NSString *> *gameHistory = [[NSMutableArray alloc]init];
  
  for (int i = 0;i < [self.game.matchResults count] -1; i++){
    MatchResult *matchResult = self.game.matchResults[i];
    NSString * history = [NSString stringWithFormat:@"ø %@ scored %d points beacuse %@",
        [matchResult matchedCardsToOneString] ,matchResult.score, [matchResult.resultStringsArray componentsJoinedByString:@", " ]  ];
    [gameHistory addObject:history];
  }
  
  return gameHistory;
  
}



@end
