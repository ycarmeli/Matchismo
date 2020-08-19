//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)setBackgroundColorByChosen:(BOOL)chosen;


@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;


@end
