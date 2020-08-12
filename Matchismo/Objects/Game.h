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
#import <Foundation/Foundation.h>

#import "Card.h"
#import "Deck.h"

@interface Game : NSObject

- (instancetype) initWithCardCount:(NSUInteger)cardCount
                         usingDeck:(Deck *)deck
                   playingGameType:(NSString *)gameType
                  cardsNumForMatch:(int)cardsNumForMatch NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void) chooseCardAtIndex:(int)cardIndex;
- (Card *) cardAtIndex:(int)cardIndex;


@property (strong, nonatomic) NSMutableArray<MatchResult*> *matchResults;
@property (strong, nonatomic) NSMutableArray<Card *> *cards;
@property (readonly, nonatomic) int score;
@property (strong)NSString *gameType;
@property (nonatomic) int cardsNumForMatch;







@end
