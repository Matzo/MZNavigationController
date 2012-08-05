//
//  MZNavigationScrollView.h
//  MZNavigationScrollView
//
//  Created by Keisuke Matsuo on 11/05/16.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZNavigationScrollView : UIScrollView {
    NSTimer *timer;
    CGPoint destinationPoint;
    
    CGPoint lastAcceleration;
    CGPoint acceleration;
    NSArray *pageIndex;
    
    BOOL isCustomDecelerating;
}
@property (nonatomic, assign) CGPoint destinationPoint;
@property (nonatomic, assign) CGPoint lastTouchPoint;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) CGPoint lastAcceleration;
@property (nonatomic, assign) CGPoint acceleration;
@property (nonatomic, strong) NSArray *pageIndex;

- (void)stopDecelerating;
- (void)startDecelerating;
- (void)scrollToPagingOffset;

@end
