// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import <UIKit/UIKit.h>
#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : CardView

- (instancetype)initWithFrame:(CGRect)frame;

//- (void)setBackgroundColorByChosen:(BOOL)chosen;

@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) int numberOfSymbols;
@property (nonatomic) int color;
@property (nonatomic) int fillType;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
