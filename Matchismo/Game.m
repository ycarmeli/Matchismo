//
//  Game.m
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import "Game.h"
#import "Deck.h"

@interface Game ()
@property (nonatomic,readwrite) int score;
@property (strong, nonatomic) NSMutableArray<Card*>* chosenCards;

@end

@implementation Game

-(instancetype) initWithCardCount:(NSUInteger)cardCount
                        usingDeck:(Deck *)deck{
    
  if (self = [super init]){
    _cards = [[NSMutableArray alloc]init];
    _score = 0;
    _chosenCards = [[NSMutableArray alloc]init];
    _matchResult = [[MatchResult alloc]initWithScore:0];
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

- (void)chooseCardAtIndex:(int)cardIndex{
    
  Card *chosenCard = [self cardAtIndex:cardIndex];
  
  if (!chosenCard.matched){
      
    if (chosenCard.chosen){
      chosenCard.chosen = NO; // unchoose the card
      [self.chosenCards removeObject:chosenCard];
    }
    else{ // legit choose
      [self.chosenCards addObject:chosenCard];
      
      if ([self.chosenCards count] == 2 ){
          
        [self.chosenCards removeObject:chosenCard];
        
        MatchResult* matchResult = [chosenCard match:self.chosenCards];
        
        if (matchResult.score){
          self.score += matchResult.score * MATCH_BONUS;
          self.matchResult = matchResult;
          [self markCardsAsMatched:self.chosenCards];
          chosenCard.matched = YES;
          [self.chosenCards removeAllObjects];
        }
        else{
          self.matchResult.resultStringsArray = @[@"No Match!"];
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
  for (Card* card in cards){
    card.matched =YES;
  }
}

- (void)unchooseCards:(NSMutableArray<Card*>*) cards{
  for (Card *card in cards){
    card.chosen = NO;
  }
}

- (Card *) cardAtIndex:(int)cardIndex{
  return (cardIndex < [self.cards count])? self.cards[cardIndex] : nil;
}

@end
