// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import <UIKit/UIKit.h>
#import "Grid.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameBoardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) Grid *boardGrid;

@end

NS_ASSUME_NONNULL_END
