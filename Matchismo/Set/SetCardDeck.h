//
//  SetDeck.h
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef SetDeck_h
#define SetDeck_h


#endif /* SetDeck_h */

#import "Deck.h"
#import "SetCard.h"


@interface SetCardDeck : Deck



- (instancetype)initWithSymbols:(NSArray *)symbolsArray;
- (instancetype)initWithSymbols:(NSArray *)symbolsArray usingColors:(NSArray *)colorsArray;
- (instancetype)init;

@property (strong, nonatomic) NSArray *symbolsArray;
@property (strong, nonatomic) NSArray *colorsArray;
@property (strong, nonatomic) NSArray *shapeFillArray;

@end
