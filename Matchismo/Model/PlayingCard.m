//
//  PlayingCard.m
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//


#import "PlayingCard.h"


@interface PlayingCard ()

@end

@implementation PlayingCard
@synthesize suit = _suit;
@synthesize rank = _rank;

-(NSString *)contents{
  return [self.rank stringByAppendingString:self.suit];
}

+ (NSArray<NSString *> *)validRanks{
  return @[@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K" ];
}

+ (NSArray<NSString *> *)validSuits{
  return @[@"♠︎",@"♦︎",@"♣︎",@"♥︎" ];
}

+ (NSUInteger)rankToIndex:(NSString *)rank{
  return [  [PlayingCard validRanks] indexOfObject:rank] ;
}
+ (NSUInteger)suitToIndex:(NSString *)suit{
  return [  [PlayingCard validSuits] indexOfObject:suit ] ;
}

- (void)setSuit:(NSString *)suit{
    
  if ([ [PlayingCard validSuits] containsObject:suit  ]){
    _suit = suit;
  }
}
- (NSString*)suit{
    return _suit ? _suit : @"?";
}
- (void)setRank:(NSString *)rank{
    
  if ([  [PlayingCard validRanks] containsObject:rank  ]){
    _rank = rank;
  }
}
- (NSString *)rank{
    return _rank ? _rank : @"?";
}

+ (NSMutableArray *)createHistogram:(int)size{
    
  NSMutableArray<NSNumber*>* histogram = [[NSMutableArray alloc] initWithCapacity:size ];

  for (int i=0;i<size;i++){
    [histogram insertObject:@0 atIndex:i];
  }
  return histogram;
}

//returns a string describing the match, nil otherwise
- (nullable NSString *)isThereNumberOfRanksMatched:(NSArray<Card *> *)cards numberToMatch:(int)cardsNumToMatch{
    
  if (cardsNumToMatch > 4){
    return nil;
  }
    
  NSMutableArray *rankCounterHistogram = [PlayingCard createHistogram:13];
  rankCounterHistogram[[PlayingCard rankToIndex:self.rank]] = @1;
          
  for (PlayingCard *otherCard in cards){// updating the histogram
    NSUInteger rankIndex = [PlayingCard rankToIndex:otherCard.rank];
    rankCounterHistogram[rankIndex] = @([rankCounterHistogram[rankIndex] intValue] + 1);
  }
  
  for (NSNumber *numOfRanks in rankCounterHistogram) { //seraching for if there is a match
    if ([numOfRanks intValue] == cardsNumToMatch){
      return [self getMatchedRanksResultString:cards withHistogram:rankCounterHistogram withNumberOfMatches:cardsNumToMatch];
    }
  }

    return nil;
}

//returns a string describing the match, nil otherwise
- (nullable NSString *)isThereNumberOfSuitsMatched:(NSArray<Card *> *)cards numberToMatch:(int)cardsNumToMatch {
    
  if (cardsNumToMatch > 13){
      return  nil;
  }
  
  NSMutableArray<NSNumber *> *suitCounterHistogram =  [PlayingCard createHistogram:4];
  
  suitCounterHistogram[[PlayingCard suitToIndex:self.suit]] = @1;

  for (PlayingCard *otherCard in cards){// updating the histogram
    NSUInteger suitIndex = [PlayingCard suitToIndex:otherCard.suit];
    suitCounterHistogram[suitIndex] = @([suitCounterHistogram[suitIndex] intValue] + 1);
  }
  
  for (NSNumber *numOfSuits in suitCounterHistogram) {//seraching for if there is a match
    if ([numOfSuits intValue] == cardsNumToMatch){
      return [self getMatchedSuitsResultString:cards withHistogram:suitCounterHistogram withNumberOfMatches:cardsNumToMatch];
    }
  }
  
  return nil;
}


- (NSString *)getMatchedSuitsResultString:(NSArray *)cards withHistogram:(NSArray *)counterHistogram withNumberOfMatches:(int)cardsNum{
    
  NSString *resultString = @"";
  NSString *matchedSuit = nil;
  for (int i = 0 ; i < 4; i++){
    if ([ [counterHistogram objectAtIndex:i] intValue] == cardsNum){
      matchedSuit = [[PlayingCard validSuits] objectAtIndex:i ];
    }
  }
      
  for (PlayingCard *card in cards){
    if ([card.suit isEqualToString:matchedSuit]){
      resultString = [resultString stringByAppendingFormat:@"%@, ",card.contents];
    }
  }
  
  if ([ self.suit isEqualToString:matchedSuit]){
    resultString = [resultString stringByAppendingFormat:@"%@, ",self.contents];
  }
  resultString = [resultString stringByAppendingString:@"have the same suit!"];
  return resultString;
  
}

- (NSString *)getMatchedRanksResultString:(NSArray *)cards withHistogram:(NSArray *)counterHistogram withNumberOfMatches:(int)cardsNum{
  NSString *resultString = @"";
  NSString *matchedRank = @"";
  for (int i = 0; i < 13; i++){
    if ([ [counterHistogram objectAtIndex:i] intValue] == cardsNum){
      matchedRank = [[PlayingCard validRanks] objectAtIndex:i ];
    }
  }
  
  for (PlayingCard *card in cards){
    if ([ card.rank isEqualToString:matchedRank]){
      resultString = [resultString stringByAppendingFormat:@"%@, ",card.contents];
    }
  }
  
  if ([ self.rank isEqualToString:matchedRank]){
    resultString = [resultString stringByAppendingFormat:@"%@, ",self.contents];
  }
  resultString = [resultString stringByAppendingString:@"have the same rank!"];
  return resultString;
    
}


- (MatchResult *)match:(NSArray *)otherCards{
    
  int score =0;
  NSMutableArray<NSString *> *matchResultArray = [[NSMutableArray alloc]init];
  for (int i = (int) [otherCards count]; i >= 1; i--) {
    NSString *matchedRanks = [self isThereNumberOfRanksMatched:otherCards numberToMatch:i+1];
    NSString *matchedSuits =[self isThereNumberOfSuitsMatched:otherCards numberToMatch:i+1];
    if (matchedRanks){
      [matchResultArray addObject:matchedRanks];
      score += (i * 4);
    }
    if (matchedSuits){
      [matchResultArray addObject:matchedSuits];
      score += i + 1;
    }
  }
  if (score){
  return [[MatchResult alloc]initWithScore:score withStringsArray:matchResultArray withMatchedCards: [otherCards arrayByAddingObject:self] ];
  }
  return [[MatchResult alloc]initWithScore:score withStringsArray:@[@"No Match!"] withMatchedCards: [otherCards arrayByAddingObject:self]];

}


@end


