//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Yossy Carmeli on 05/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import "Game.h"

@interface Game ()
@property (readwrite,nonatomic) int score;
@property (strong, nonatomic) NSMutableArray<Card*> *chosenCards;
@end

@implementation Game

-(instancetype) initWithCardCount:(NSUInteger)cardCount
                        usingDeck:(Deck *)deck
                  playingGameType:(NSString *)gameType
                 cardsNumForMatch:(int)cardsNumForMatch{
  
  if (self = [super init]) {
    _gameType = gameType;
    _cards = [[NSMutableArray alloc]init];
    _cardsNumForMatch = cardsNumForMatch;
    _score = 0;
    _chosenCards = [[NSMutableArray alloc]init];
    _matchResults = [[NSMutableArray alloc]init];
    [self.matchResults addObject:[[MatchResult alloc]initWithScore:0]     ];
    for (int i = 0; i < cardCount; i++) {
      Card *card = [deck drawCard];
      if (card) {
        [self.cards addObject:card];
      }
      else {
        self = nil;
        break;
      }
    }
  }
  return self;
  
  
}

#define MISMATCH_PENALTY -2
#define MATCH_BONUS 3
#define COST_TO_CHOOSE -1;


- (void) chooseCardAtIndex:(int)cardIndex {
  
  Card *chosenCard = [self cardAtIndex:cardIndex];
  
  if (chosenCard.matched) {
    return;
  }
  if (chosenCard.chosen) {
    [self unhooseCardAndRemoveFromChosenCards:chosenCard];
    return;
  }
  [self processAFreshChoose:chosenCard];
}

- (void)processAFreshChoose:(Card *)chosenCard {
  
  chosenCard.chosen = YES;
  [self.chosenCards addObject:chosenCard];
  self.score += COST_TO_CHOOSE;
  
  if (![self isTimeToCheckMatching]) {
    return;
  }
  
  MatchResult *matchResult = [self getMatchResultWith:chosenCard];
  
  if ([self isMatch:matchResult]) {
    self.score += matchResult.score * MATCH_BONUS;
    [self markCardsAsMatchedAndClearChosenCards:self.chosenCards withCard:chosenCard];
  }
  else {
    self.score += MISMATCH_PENALTY;
    [self unchooseCardsAndClearChosenCards:chosenCard];
    if ([self.gameType isEqualToString:@"Matching Cards"]){
      [self keepChosenCardChoosed:chosenCard];
    }
  }
  
}

- (void)keepChosenCardChoosed:(Card *)chosenCard{
  [self.chosenCards addObject:chosenCard];
  chosenCard.chosen = YES;
  
}

- (BOOL) isMatch:(MatchResult *)matchResult{
  return matchResult.score;
}

- (MatchResult *)getMatchResultWith:(Card *)chosenCard{
  [self.chosenCards removeObject:chosenCard];
  
  MatchResult* matchResult = [chosenCard match:self.chosenCards];
  [self.matchResults insertObject:matchResult atIndex:0];
  return matchResult;
}

- (BOOL)isTimeToCheckMatching{
  return [self.chosenCards count] == self.cardsNumForMatch ;
}

- (void)markCardsAsMatchedAndClearChosenCards:(NSMutableArray<Card*>*) cards
                                     withCard:(Card *)chosenCard{
  for (Card *card in cards){
    card.matched =YES;
  }
  chosenCard.matched = YES;
  [self.chosenCards removeAllObjects];
}

- (void)unchooseCardsAndClearChosenCards:(Card *)chosenCard{
  for (Card *card in self.chosenCards){
    card.chosen = NO;
  }
  [self.chosenCards removeAllObjects];
  chosenCard.chosen = NO;
}

- (void)unhooseCardAndRemoveFromChosenCards:(Card *)card{
  card.chosen = NO; // unchoose the card
  [self.chosenCards removeObject:card];
}

- (Card *)cardAtIndex:(int)cardIndex{
  return (cardIndex < [self.cards count])? self.cards[cardIndex] : nil;
}

- (nullable Card *)drawCard {
  
  Card *newCard = nil;
  
  if ([self.cards count] ) { // if there are cards left in the deck
    unsigned int index = arc4random() % [self.cards count]; // choose card
    newCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }
  return newCard;
  
}

@end
