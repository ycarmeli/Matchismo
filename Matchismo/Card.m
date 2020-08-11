//
//  Card.m
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import "Card.h"

@interface Card ()

@end

@implementation Card

-(MatchResult*)match:(NSArray*)otherCards{
    
    int score =0;
    for (Card* otherCard in otherCards){
        
        if ([self.contents isEqualToString:otherCard.contents]){
            score = 1;
        }
    }
    
    return [[MatchResult alloc]initWithScore:score];
}


@end
