//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//


#import "PlayingCardDeck.h"

@interface PlayingCardDeck ()

@end

@implementation PlayingCardDeck

-(instancetype)init{
  self = [super init];
  if (self){
    for (NSString* rank in [PlayingCard validRanks]) {
      for (NSString* suit in [PlayingCard validSuits]) {
        PlayingCard* card = [[PlayingCard alloc ]init];
        card.rank = rank;
        card.suit = suit;
        [self addCard:card];
      }
    }
  }
  return self;
}

@end
