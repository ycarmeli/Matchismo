//
//  SetDeck.m
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SetCardDeck.h"

@interface SetCardDeck ()
@property (strong,nonatomic) NSMutableArray *cardsValues;
@end

@implementation SetCardDeck

- (instancetype)initWithSymbols:(NSArray *)symbolsArray{
  
  if (self = [super init]){
    _symbolsArray = symbolsArray;
    _colorsArray = @[@"R",@"G",@"B"];
    _shapeFillArray = @[@"Full",@"Half",@"Empty"];
    _cardsValues = [SetCardDeck createCardsValues];
  }
  return self;
    
}

- (instancetype)initWithSymbols:(NSArray *)symbolsArray usingColors:(NSArray *)colorsArray{

  if (self = [super init]){
    _symbolsArray = symbolsArray;
    _colorsArray = colorsArray;
    _shapeFillArray = @[@"Full",@"Half",@"Empty"];
    _cardsValues = [SetCardDeck createCardsValues];

  }
  return self;
    
    
}


- (instancetype)init{
    
    
  if (self = [super init]){
    _symbolsArray = @[@"▲", @"●", @"■"];
    _colorsArray = @[@"R",@"G",@"B"];
    _shapeFillArray = @[@"Full",@"Half",@"Empty"];
    _cardsValues = [SetCardDeck createCardsValues];

  }
  return self;
  
}

+ (NSMutableArray *)createCardsValues{
  
  NSMutableArray *cardsValues = [[NSMutableArray alloc]init];
  
  for (int s = 1;s < 4;s++){
    for (int n = 1;n < 4;n++){
      for (int c = 1;c < 4;c++){
        for (int f = 1;f < 4 ;f++){
          [cardsValues addObject:@( (s * 1000) + (n * 100) + (c * 10) + f )];
        }
      }
    }
  }
  return cardsValues;
}


- (nullable Card *) drawCard{

  Card *newCard = nil;
  
  if ([self.cardsValues count] ){ // if there are cards left in the deck
    unsigned int index = arc4random() % [self.cardsValues count]; // choose card
    int newCardValue = [self.cardsValues[index] intValue];
    newCard = [self cardValueToCard:newCardValue];
    [self.cardsValues removeObjectAtIndex:index];
  }
  return newCard;
}

- (Card *)cardValueToCard:(int)value{
  
  SetCard *card = [[SetCard alloc]init];
  card.symbol =  self.symbolsArray[ (value/1000) -1 ];
  card.numberOfSymbols = [NSString stringWithFormat:@"%d",(value/100 % 10)];
  card.color = self.colorsArray[ ((value / 10) %10)  -1];
  card.fillType = self.shapeFillArray[ value%10 -1];
  return card;
  
}














@end
