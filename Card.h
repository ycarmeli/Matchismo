//
//  Card.h
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef Card_h
#define Card_h


#endif /* Card_h */
#import <Foundation/Foundation.h>
#import "MatchResult.h"

@interface Card : NSObject

- (MatchResult*)match:(NSArray *)otherCards;

@property (strong,nonatomic) NSString *contents;
@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;



@end
