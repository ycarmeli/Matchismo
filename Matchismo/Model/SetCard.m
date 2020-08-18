//
//  SetCard.m
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SetCard.h"

@interface SetCard ()

@end

@implementation SetCard



- (MatchResult *)match:(NSArray*)otherCards{
    
  int score = 0;

  NSString *symbolsStatus = [self getItemStatus:otherCards item:@"symbol"];
  NSString *numbersStatus = [self getItemStatus:otherCards item:@"number"];
  NSString *colorsStatus = [self getItemStatus:otherCards item:@"color"];
  NSString *fillsStatus = [self getItemStatus:otherCards item:@"fill"];
  
  if (symbolsStatus && numbersStatus && colorsStatus && fillsStatus){
    score = 10;
    return [[MatchResult alloc]initWithScore:score
                            withStringsArray:@[symbolsStatus,numbersStatus,colorsStatus,fillsStatus]
                            withMatchedCards:[otherCards arrayByAddingObject:self] ];
  }
return [[MatchResult alloc]initWithScore:score withStringsArray:@[@"No Match!"] withMatchedCards:[otherCards arrayByAddingObject:self]];
}


- (nullable NSString *)getItemStatus:(NSArray *)otherCards item:(NSString *) item{
  
  if ([self isAllCardsWithSameItem:otherCards itemToCompare:item] ){
    return [NSString stringWithFormat:@"The cards have the same %@!",item];
  }
  if ([self isAllCardsWithDifferentItem:otherCards itemToCompare:item]){
    return [NSString stringWithFormat:@"The cards have different %@s!",item];
  }
  return nil;
}

- (BOOL)isAllCardsWithSameItem:(NSArray *)otherCards itemToCompare:(NSString *)item{
  
  if ([otherCards count] != 2){
    return NO;
  }
  
  SetCard *otherCard1 = otherCards[0];
  SetCard *otherCard2 = otherCards[1];
  
  NSString *otherCardsItem1 = [otherCard1 cardToItem:item];
  NSString *otherCardsItem2 = [otherCard2 cardToItem:item];
  NSString *myItem = [self cardToItem:item];

  if (([myItem isEqualToString:otherCardsItem1]) && ([myItem isEqualToString:otherCardsItem2]) ){
    return YES;
  }
  return NO;
  
}


- (BOOL)isAllCardsWithDifferentItem:(NSArray *)otherCards itemToCompare:(NSString *)item{
  if ([otherCards count] != 2){
    return NO;
  }
  
  SetCard *otherCard1 = otherCards[0];
  SetCard *otherCard2 = otherCards[1];
  
  NSString *otherCardsItem1 = [otherCard1 cardToItem:item];
  NSString *otherCardsItem2 = [otherCard2 cardToItem:item];
  NSString *myItem = [self cardToItem:item];
  
  if ((![myItem isEqualToString:otherCardsItem1]) && (![myItem isEqualToString:otherCardsItem2])
      && (![otherCardsItem1 isEqualToString:otherCardsItem2])){
    return YES;
  }
  return NO;
}


- (NSString *)cardToItem:(NSString *)item{
  
  if ([item isEqualToString:@"symbol"]){
    return self.symbol;
  }
  if ([item isEqualToString:@"number"]){
    return self.numberOfSymbols;
  }
  if ([item isEqualToString:@"color"]){
    return [NSString stringWithFormat:@"%d",self.color];
  }
  if ([item isEqualToString:@"fill"]){
    return [NSString stringWithFormat:@"%d",self.fillType];
  }
  return nil;
  
}


- (NSString *)contents{
  //return @"BLA";
  return [@"" stringByAppendingFormat:@"%@%@%d,%d",self.numberOfSymbols,self.symbol,self.color,self.fillType];
}




@end
