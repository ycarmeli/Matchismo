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

@property (nonatomic,readonly) int score;
@property (strong,nonatomic) NSMutableArray<MatchResult*>* matchResults;
@property (strong,nonatomic) NSMutableArray<Card*>* cards;
@property (nonatomic) int matchMode;

-(instancetype) initWithCardCount:(NSUInteger)cardCount
                        usingDeck:(Deck*)deck
                    cardMatchMode:(int)mode NS_DESIGNATED_INITIALIZER;

-(instancetype)init NS_UNAVAILABLE;

-(void) chooseCardAtIndex:(int)cardIndex;
-(Card*) cardAtIndex:(int)cardIndex;




@end


