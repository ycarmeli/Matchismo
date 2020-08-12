//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Yossy Carmeli on 05/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (readwrite,nonatomic) int score;
@property (strong, nonatomic) NSMutableArray<Card*> *chosenCards;

@end

@implementation CardMatchingGame

-(instancetype) initWithCardCount:(NSUInteger)cardCount
                        usingDeck:(Deck *)deck
                    cardMatchMode:(int)mode{
    
  if (self = [super init]){
    _cards = [[NSMutableArray alloc]init];
    _matchMode = mode;
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

- (void) chooseCardAtIndex:(int)cardIndex{
    
  Card *chosenCard = [self cardAtIndex:cardIndex];
  
  if (!chosenCard.matched){
      
    if (chosenCard.chosen){
      chosenCard.chosen = NO; // unchoose the card
      [self.chosenCards removeObject:chosenCard];
    }
    else{ // legit choose
      [self.chosenCards addObject:chosenCard];
      
      if ([self.chosenCards count] == self.matchMode ){
        
        [self.chosenCards removeObject:chosenCard];
        
        MatchResult* matchResult = [chosenCard match:self.chosenCards];
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
          [self.chosenCards addObject:chosenCard];
        }
      }

        self.score += COST_TO_CHOOSE;
        chosenCard.chosen = YES;
    }
  }
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
