// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView

- (void)setBackgroundColorByChosen:(BOOL)chosen;

@property (nonatomic) int index;

@end

NS_ASSUME_NONNULL_END
