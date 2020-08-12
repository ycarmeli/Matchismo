//
//  Game.h
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef Game_h
#define Game_h


#endif /* Game_h */

#import "Card.h"
#import "Deck.h"

@interface Game : NSObject

- (instancetype) initWithCardCount:(NSUInteger)cardCount
                         usingDeck:(Deck *)deck;

- (instancetype)init NS_UNAVAILABLE;

- (void) chooseCardAtIndex:(int)cardIndex;
- (Card*) cardAtIndex:(int)cardIndex;@property (nonatomic,readonly) int score;


@property (strong,nonatomic) MatchResult *matchResult;
@property (strong,nonatomic) NSMutableArray<Card *> *cards;







@end
