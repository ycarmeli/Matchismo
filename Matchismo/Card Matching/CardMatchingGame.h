//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Yossy Carmeli on 05/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef CardMatchingGame_h
#define CardMatchingGame_h


#endif /* CardMatchingGame_h */

#import <Foundation/Foundation.h>
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)cardCount
                        usingDeck:(Deck *)deck
                    cardsNumForMatch:(int)cardsNumForMatch NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)chooseCardAtIndex:(int)cardIndex;
- (Card *)cardAtIndex:(int)cardIndex;

@property (readonly, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray<MatchResult*> *matchResults;
@property (strong, nonatomic) NSMutableArray<Card*> *cards;
@property (nonatomic) int cardsNumForMatch;

@end


