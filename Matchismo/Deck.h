//
//  Deck.h
//  Matchismo
//
//  Created by Yossy Carmeli on 04/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#ifndef Deck_h
#define Deck_h


#endif /* Deck_h */
#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void)addCard:(Card*)card atTop:(BOOL)atTop; // addCard:atTop
-(void)addCard:(Card*)card; //addCard
-(Card*) drawCard;

@end
