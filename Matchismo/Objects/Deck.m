//
//  Deck.m
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//


#import "Deck.h"

@interface Deck()
@property (strong,nonatomic) NSMutableArray<Card *> *cards;
@end

@implementation Deck

- (instancetype) init{
    
  if (self = [super init]){
    _cards = [[NSMutableArray<Card*> alloc ] init];
  }
  return self;
}

- (NSMutableArray<Card*>*)cards {
  return _cards;
}

- (void)addCard:(Card*)card atTop:(BOOL)atTop{

  if (atTop){
    [self.cards insertObject:card atIndex:0];
  }
  else{
    [self.cards addObject:card];
  }
    
}
- (void)addCard:(Card*)card{
    [self addCard:card atTop:NO];
}
- (Card *) drawCard{

  Card *newCard = nil;
  
  if ([self.cards count] ){ // if there are cards left in the deck
    unsigned int index = arc4random() % [self.cards count]; // choose card
    newCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }
  return newCard;
}

@end
