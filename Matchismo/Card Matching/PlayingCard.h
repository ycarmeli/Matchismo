//
//  PlayingCard.h
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef PlayingCard_h
#define PlayingCard_h


#endif /* PlayingCard_h */

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card



+ (NSArray<NSString *> *)validRanks;
+ (NSArray<NSString *> *)validSuits;


@property(nonatomic)NSString *rank;
@property(strong,nonatomic)NSString *suit;


@end
