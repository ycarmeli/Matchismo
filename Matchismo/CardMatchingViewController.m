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
#import "HistoryViewController.h"

@class HistoryViewController;

@interface CardMatchingViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (strong,nonatomic) Game* game;
@property (strong,nonatomic) NSArray<NSAttributedString *> *gameHistory ;

@end

@implementation CardMatchingViewController
- (IBAction)modeChange:(id)sender {
    [self newGame];
}

-(Deck*) createDeck{
    return [[PlayingCardDeck alloc]init];
}

-(void) flipCardsToBack{
    
    for (UIButton* cardButton in self.cardButtons){
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                              forState:(UIControlStateNormal)];
        [cardButton setTitle:@"" forState:UIControlStateNormal];
        
    }
}

-(void)newGame{
    
    
    [self flipCardsToBack];
    _game = [[Game alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] playingGameType:@"Matching Cards" cardsNumForMatch:3];
    [self updateUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newGame];
    
    
    
}
- (IBAction)cardClick:(id)sender {
    int buttonIndex = (int)[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:buttonIndex];
    [self updateUI];
}


-(void)updateUI{
    for (UIButton* cardButton in self.cardButtons) {
      cardButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
      int buttonIndex =(int) [self.cardButtons indexOfObject:cardButton];
      Card* card = [self.game cardAtIndex:buttonIndex];
      [cardButton setBackgroundImage:[UIImage imageNamed:[self backgroundImageNameOfCard:card ]]
                            forState:(UIControlStateNormal)];
      [cardButton setTitle:[self titleOfCard:card]
                  forState:UIControlStateNormal];
      cardButton.enabled = !card.matched;
      [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d",self.game.score]];
      [self.matchResultLabel setText: [self.game.matchResults[0].resultStringsArray componentsJoinedByString:@"\n"]   ];
        
    }
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
  if ([segue.identifier isEqualToString:@"History of Card Matching"   ]){
    if ([segue.destinationViewController isKindOfClass:[HistoryViewController class] ]){
      HistoryViewController *historyVC = (HistoryViewController *) segue.destinationViewController;
      historyVC.history = [[self getGameHistory] componentsJoinedByString:@"\n\n"];
      historyVC.headline = @"Score History Of Card Matching:";
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
