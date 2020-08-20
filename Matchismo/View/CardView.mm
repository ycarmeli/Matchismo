// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CardView

- (void)setBackgroundColorByChosen:(BOOL)chosen{
  self.backgroundColor = (chosen)? [UIColor lightGrayColor] : [UIColor whiteColor];
}

@end

NS_ASSUME_NONNULL_END
