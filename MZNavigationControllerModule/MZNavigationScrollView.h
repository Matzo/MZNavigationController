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
    
}
@property (nonatomic, assign) CGPoint destinationPoint;
@property (nonatomic, assign) CGPoint lastTouchPoint;

@end
