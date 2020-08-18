//
//  SetCard.h
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef SetCard_h
#define SetCard_h


#endif /* SetCard_h */

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card

- (NSString *) contents;

@property (nonatomic) NSString *symbol;
@property (nonatomic) NSString *numberOfSymbols;
@property (nonatomic) int color;
@property (nonatomic) int fillType;


@end
