// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;



@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) int numberOfSymbols;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) int fillType;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
