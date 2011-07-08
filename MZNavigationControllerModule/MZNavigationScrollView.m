//
//  MZNavigationScrollView.m
//  MZNavigationScrollView
//
//  Created by Keisuke Matsuo on 11/05/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZNavigationScrollView.h"
#import "MZTabMenuView.h"


@implementation MZNavigationScrollView
@synthesize destinationPoint;
@synthesize lastTouchPoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(scrollToDestination) userInfo:nil repeats:YES];
        destinationPoint = CGPointZero;
        
        lastTouchPoint = CGPointZero;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
//    [sideMenu release];
    [super dealloc];
}

- (void)scrollToDestination {
    if (destinationPoint.x == self.contentOffset.x
        && destinationPoint.y == self.contentOffset.y) {
    } else {
        
        float axMax = (destinationPoint.x - self.contentOffset.x)*0.13;
        float ayMax = (destinationPoint.y - self.contentOffset.y)*0.13;
        if (fabs(axMax) < 1.0 && fabs(ayMax) < 1.0) {
            CGPoint offset = self.contentOffset;
            offset.x = destinationPoint.x;
            offset.y = destinationPoint.y;
            self.contentOffset = offset;
        } else {
            float ax = axMax;
            float ay = ayMax;
            
            if (0.0 < fabs(ax) && fabs(ax) < 1.0) {
                ax = ax / fabs(ax);
            }
            if (0.0 < fabs(ay) && fabs(ay) < 1.0) {
                ay = ay / fabs(ay);
            }

            CGPoint offset = self.contentOffset;
            offset.x = self.contentOffset.x + ax;
            offset.y = self.contentOffset.y + ay;
            self.contentOffset = offset;
            
        }
    }
}

- (void)setDestinationPoint:(CGPoint)destinationPoint_ {
    float dx = destinationPoint_.x;
    float dy = 0.0;
    
    if (self.contentSize.width < destinationPoint_.x + self.bounds.size.width) {
        dx = self.contentSize.width - self.bounds.size.width;
    }

    if (dx < 0.0) {
        dx = 0.0;
    }
    
    destinationPoint = CGPointMake(dx, dy);
}

#pragma mark - TouchEvent
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.lastTouchPoint = touchPoint;

    return YES;
}
@end
