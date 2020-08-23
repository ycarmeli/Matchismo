// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import "DeckView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DeckView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

#define CORNER_RADIUS 12.0
#define CORNER_STD_HEIGHT 180.0

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_STD_HEIGHT;
}

- (CGFloat)cornerRadius {
  return CORNER_RADIUS *[self cornerScaleFactor];
}

- (void)drawRect:(CGRect)rect{

  UIImage *deckImage = [UIImage imageNamed:@"cardBack"];
  [deckImage drawInRect:self.bounds];
  self.layer.cornerRadius = [self cornerRadius];
  self.clipsToBounds = YES;
}

@end

NS_ASSUME_NONNULL_END
