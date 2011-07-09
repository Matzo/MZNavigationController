//
//  MZNavigationController.h
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 11/05/12.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

enum STATUS {
    STATUS_NORMAL = 0,
    STATUS_PUSH_ANIMATION,
    STATUS_POP_ANIMATION,
};

#import <UIKit/UIKit.h>
#import "MZNavigationScrollView.h"
#import "MZTabMenuView.h"
#import "MZNavigationBaseView.h"

@interface MZNavigationController : UINavigationController<UINavigationControllerDelegate, UIScrollViewDelegate> {
    NSMutableArray *baseViews;
    
    float pageWidth;
    float offsetX;
    CGPoint lastOffset;
    
    int popingCount;
    int pushingCount;
    
    BOOL isChangingByTab;
}

@property (nonatomic, retain) MZNavigationScrollView *scrollView;
@property (nonatomic, retain) MZTabMenuView *sideMenu;
@property (nonatomic, assign) CGPoint lastTouchPoint;
@property (nonatomic, assign) CGPoint acceleration;
@property (nonatomic, assign) BOOL isChangingByTab;
@property (nonatomic, assign) float pageWidth;

- (id)initWithRootViewController:(UIViewController*)rootViewController width:(float)width;

- (void)scrollToPagingOffset;
- (void)addRelationalViews;
- (void)layoutRelationalViews;
- (void)resizeViewController:(UIViewController *)viewController width:(float)width;
- (void)pushViewController:(UIViewController *)viewController
                     width:(float)width
                  animated:(BOOL)animated;

@end
