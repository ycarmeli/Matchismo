// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import "DeckView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DeckView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      self.backgroundColor = nil;
      
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
  
  [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
}

@end

NS_ASSUME_NONNULL_END
