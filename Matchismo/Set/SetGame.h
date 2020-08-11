//
//  SetGame.h
//  Matchismo
//
//  Created by Yossy Carmeli on 09/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef SetGame_h
#define SetGame_h


#endif /* SetGame_h */

@class Card;
@class Deck;
@class MatchResult;

@interface SetGame : NSObject


- (instancetype) initWithCardCount:(NSUInteger)cardCount
    usingDeck:(Deck*)deck NS_DESIGNATED_INITIALIZER;

- (void) chooseCardAtIndex:(int)cardIndex;
- (Card*) cardAtIndex:(int)cardIndex;

@property (nonatomic,readonly) int score;
@property (strong,nonatomic) NSMutableArray<MatchResult*>* matchResults;
@property (strong,nonatomic) NSMutableArray<Card*>* cards;
@end
