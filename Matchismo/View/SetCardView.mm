// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Yossy Carmeli.

#import "SetCardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardView

- (void)setColor:(int)color{
  _color = color;
  [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol{
  _symbol = symbol;
  [self setNeedsDisplay];
}

- (void)setNumberOfSymbols:(int)numberOfSymbols{
  _numberOfSymbols = numberOfSymbols;
  [self setNeedsDisplay];
}

- (void)setFillType:(int)fillType{
  _fillType = fillType;
  [self setNeedsDisplay];
}

#define CORNER_RADIUS 12.0
#define CORNER_STD_HEIGHT 180.0

static const CGFloat SQUARE_SIZE = 10.0;
static const CGFloat TRIANGLE_SIZE = 10.0;


- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_STD_HEIGHT;
}

- (CGFloat)cornerRadius {
  return CORNER_RADIUS *[self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

- (void)drawSymbols{
  
  for (int i=0;i<self.numberOfSymbols;i++) {
    [self drawSymbol:i];
  }

}

- (void)drawSymbol:(int)symbolNumber {
  
  if ([self.symbol isEqualToString:@"triangle"]){
    [self createDiamond:TRIANGLE_SIZE symbolNumber:symbolNumber   ];
  }
  else {
    [self createCircleOrSquare:SQUARE_SIZE symbolNumber:symbolNumber type:self.symbol];
  }
  
}



- (CGPoint)calculateSymbolTopLocation:(CGFloat)symbolSize symbolNumber:(NSUInteger)symbolNumber {
  
  CGFloat marginBetweenSymbolAndTopBound = (self.bounds.size.height - ( self.numberOfSymbols * symbolSize) )    / 3.0;
  CGFloat marginBetweenSymbols = (self.numberOfSymbols != 1 ) ? marginBetweenSymbolAndTopBound / (self.numberOfSymbols - 1 ) : 0;
  
  CGFloat symbolY = marginBetweenSymbolAndTopBound + (symbolNumber * ( symbolSize + marginBetweenSymbols) )   ;
  
  CGFloat symbolX = ([self.symbol isEqualToString:@"triangle"])? self.bounds.size.width / 2.0 : self.bounds.size.width / 3.0;
  
  
  return CGPointMake(symbolX, symbolY);
  
}

- (UIColor *)colorAtIndex:(int)index{
  switch (index){
    case 1: return [UIColor greenColor];
    case 2: return [UIColor purpleColor];
    case 3: return [UIColor redColor];
  }
  return [UIColor blackColor];
}

#define FILL_SOLID 3
#define FILL_STRIPES 2

- (void)fillSymbol:(UIBezierPath *)symbol {
  
  UIColor *myColor = [self colorAtIndex:self.color];


  if (self.fillType == FILL_STRIPES){
    [self fillSymbolWithStripes:symbol];
  }
  
  if (self.fillType == FILL_SOLID){
    [myColor setFill];
    [symbol fill];
  }
  
  [myColor setStroke];
  [symbol stroke];

}


- (void)fillSymbolWithStripes: (UIBezierPath *)symbol{
  
  for (int y = symbol.bounds.origin.y; y < symbol.bounds.origin.y + symbol.bounds.size.height; y+= 3.5){
    [symbol moveToPoint:CGPointMake(symbol.bounds.origin.x,y)];
    //NSLog([[CGPointMake(0, y)] description] );
    [symbol addLineToPoint:CGPointMake(symbol.bounds.origin.x +symbol.bounds.size.width , y)];
    
    
  }
  
}

- (void)createDiamond:(CGFloat)symbolSize symbolNumber:(NSUInteger)symbolNumber {
  
  
  CGPoint topLocation = [self calculateSymbolTopLocation:TRIANGLE_SIZE symbolNumber:symbolNumber];
  
  UIBezierPath *path = [[UIBezierPath alloc]init];
  [path moveToPoint:CGPointMake( topLocation.x , topLocation.y )];
  [path addLineToPoint:CGPointMake(topLocation.x + (TRIANGLE_SIZE / 2.0), topLocation.y + (TRIANGLE_SIZE / 2.0)  ) ];
  
  [path addLineToPoint:CGPointMake(topLocation.x ,  topLocation.y +   TRIANGLE_SIZE  ) ];
  [path addLineToPoint:CGPointMake(topLocation.x - (TRIANGLE_SIZE / 2.0), topLocation.y + (TRIANGLE_SIZE / 2.0)  )];

  [path closePath];
  
  [self fillSymbol:path];
}

- (void)createCircleOrSquare:(CGFloat)symbolSize symbolNumber:(NSUInteger)symbolNumber type:(NSString *)type {

  CGPoint topLocation = [self calculateSymbolTopLocation:TRIANGLE_SIZE symbolNumber:symbolNumber];
  
  CGRect square = CGRectMake(topLocation.x, topLocation.y, SQUARE_SIZE, SQUARE_SIZE);
  UIBezierPath *path = ([type isEqualToString:@"circle"])? [UIBezierPath bezierPathWithOvalInRect:square]: [UIBezierPath bezierPathWithRect:square];
  [self fillSymbol:path];
}


- (void)drawRect:(CGRect)rect{
//  CGRect cardRect = CGRectMake(0, 0, 40, 60);
  UIBezierPath *cardShape = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  [cardShape addClip];
  [[UIColor blackColor ] setStroke ];
  [cardShape stroke];
  [self drawSymbols];
}

- (void)setup  {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
  
}

- (void)setBackgroundColorByChosen:(BOOL)chosen{
  self.backgroundColor = (chosen)? [UIColor lightGrayColor] : [UIColor whiteColor];
}

- (void)tap {
  
//  self.backgroundColor = [UIColor lightGrayColor];
  
  
}

- (NSString *)description {
  return [NSString stringWithFormat: @"color: %d, fill:%d ,number: %d ,symbol: %@",
  self.color,self.fillType,self.numberOfSymbols,self.symbol];
}

- (instancetype)initWithFrame:(CGRect)frame {
  
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
  
}

@end



NS_ASSUME_NONNULL_END
