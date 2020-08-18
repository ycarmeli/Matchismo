// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import "GameBoardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GameBoardView

- (instancetype)initWithFrame:(CGRect)frame{
  
    if (self = [super initWithFrame:frame]) {
      _boardGrid = [[Grid alloc]init];
      _boardGrid.cellAspectRatio = (2/3.0);
      _boardGrid.size = self.frame.size;
      _boardGrid.minimumNumberOfCells = 21;
      self.backgroundColor = [UIColor whiteColor];
      
    }
    return self;
}


@end

NS_ASSUME_NONNULL_END
