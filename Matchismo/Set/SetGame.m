//
//  SetGame.m
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SetGame.h"
#import "MatchResult.h"
#import "Deck.h"


@interface SetGame()
@property (nonatomic,readwrite) int score;
@property (strong, nonatomic) NSMutableArray<Card*>* chosenCards;
@end

@implementation SetGame

- (instancetype)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck{

  if (self = [super init]){
    _cards = [[NSMutableArray alloc]init];
    _score = 0;
    _chosenCards = [[NSMutableArray alloc]init];
    _matchResults = [[NSMutableArray alloc]init];
    [self.matchResults addObject:[[MatchResult alloc]initWithScore:0]     ];
    for (int i=0 ; i < cardCount; i++){
      Card *card = [deck drawCard];
      if (card){
        [self.cards addObject:card];
      }
      else{
        self = nil;
        break;
      }
    }
  }
  return self;
    
}

#define MISMATCH_PENALTY -2
#define MATCH_BONUS 2
#define COST_TO_CHOOSE -1;
#define NUM_OF_CARDS_FOR_SET 3

- (void)chooseCardAtIndex:(int)cardIndex{
    
  Card *chosenCard = [self cardAtIndex:cardIndex];
  
  if (chosenCard.matched){
    return;
  }
  if (chosenCard.chosen){
    chosenCard.chosen = NO; // unchoose the card
    [self.chosenCards removeObject:chosenCard];
    return;
  }
   // legit choose
  [self.chosenCards addObject:chosenCard];
  
  if ([self.chosenCards count] == NUM_OF_CARDS_FOR_SET ){
      
    [self.chosenCards removeObject:chosenCard];
    
    MatchResult *matchResult = [chosenCard match:self.chosenCards];
    [self.matchResults insertObject:matchResult atIndex:0];
  
    if (matchResult.score){
      self.score += matchResult.score * MATCH_BONUS;
      [self markCardsAsMatched:self.chosenCards];
      chosenCard.matched = YES;
      [self.chosenCards removeAllObjects];
    }
    else{
      self.score += MISMATCH_PENALTY;
      [self unchooseCards:self.chosenCards];
      [self.chosenCards removeAllObjects];
    }
  }
  else{
    chosenCard.chosen = YES;
  }
  self.score += COST_TO_CHOOSE;
    
}


- (void)markCardsAsMatched:(NSMutableArray<Card*>*) cards{
  for (Card *card in cards){
    card.matched =YES;
  }
}

- (void)unchooseCards:(NSMutableArray<Card*>*) cards{
  for (Card *card in cards){
    card.chosen = NO;
  }
}

- (Card *)cardAtIndex:(int)cardIndex{
  return (cardIndex < [self.cards count])? self.cards[cardIndex] : nil;
}


@end
