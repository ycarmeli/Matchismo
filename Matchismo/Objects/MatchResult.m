//
//  MatchResult.m
//  Matchismo
//
//  Created by Yossy Carmeli on 06/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//



#import "MatchResult.h"

#import "Card.h"

@interface MatchResult ()

@end

@implementation MatchResult

- (instancetype)initWithScore:(int)score{
  if (self = [super init]){
    _score = score;
    _resultStringsArray = [[NSMutableArray alloc] init];
    _matchedCards = [[NSMutableArray alloc] init];

  }
  return self;
}

- (instancetype)initWithScore:(int)score
             withStringsArray:(NSMutableArray*)resultStringsArray{
  
  if (self = [super init]){
    _score = score;
    _resultStringsArray = resultStringsArray;
    _matchedCards = [[NSMutableArray alloc] init];

  }
  return self;
}
- (instancetype)initWithScore:(int)score withStringsArray:(NSArray *)resultStringsArray withMatchedCards:(NSArray *)matchedCards{
  
  if (self = [super init]){
    _score = score;
    _resultStringsArray = resultStringsArray;
    _matchedCards = matchedCards;

  }
  return self;
  
}

- (NSString *) matchedCardsToOneString{
  NSString *result = @"";
  for (Card *card in self.matchedCards){
    result = [result  stringByAppendingFormat:@"%@, ",card.contents];
  }
  return result;
  
}


@end
