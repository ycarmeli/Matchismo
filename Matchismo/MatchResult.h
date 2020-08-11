//
//  MatchResult.h
//  Matchismo
//
//  Created by Yossy Carmeli on 06/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef MatchResult_h
#define MatchResult_h


#endif /* MatchResult_h */
#import <Foundation/Foundation.h>

@interface MatchResult : NSObject

- (NSString *) matchedCardsToOneString;

@property (nonatomic) int score;
@property (strong,nonatomic) NSArray* resultStringsArray;
@property (strong,nonatomic) NSArray *matchedCards;
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithScore:(int)score;
-(instancetype)initWithScore:(int)score withStringsArray:(NSArray *)resultStringsArray;
-(instancetype)initWithScore:(int)score withStringsArray:(NSArray *)resultStringsArray withMatchedCards:(NSArray *)matchedCards;

@end
