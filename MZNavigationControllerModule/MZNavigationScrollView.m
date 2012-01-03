//
//  MZNavigationScrollView.m
//  MZNavigationScrollView
//
//  Created by Keisuke Matsuo on 11/05/16.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import "MZNavigationScrollView.h"
#import "MZTabMenuView.h"


@implementation MZNavigationScrollView
@synthesize destinationPoint;
@synthesize lastTouchPoint;
@synthesize lastContentOffset;
@synthesize lastAcceleration;
@synthesize acceleration;
@synthesize pageIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(scrollToDestination) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        destinationPoint = CGPointZero;
        
        lastTouchPoint = CGPointZero;
        lastContentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y);

        lastAcceleration = CGPointZero;
        acceleration = CGPointZero;
        
        self.scrollsToTop = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        isCustomDecelerating = NO;
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
    [pageIndex release];
    [super dealloc];
}

- (void)scrollToDestination {
//    NSLog(@"ax:%f ay:%f", acceleration.x, acceleration.y);
    if (isCustomDecelerating) {
        float ax = self.acceleration.x*0.85;
        float ay = self.acceleration.y*0.85;
        
        if (0.0 < fabs(ax) && fabs(ax) < 1.0) {
            ax = ax / fabs(ax);
        }
        if (0.0 < fabs(ay) && fabs(ay) < 1.0) {
            ay = ay / fabs(ay);
        }
        acceleration = CGPointMake(ax, ay);
        
        if (fabs(acceleration.x) <= 8.0 && fabs(acceleration.y) <= 8.0) {
            [self scrollToPagingOffset];
        } else {
            CGPoint offset = self.contentOffset;
            if (offset.x < 0.0 || (self.contentSize.width - self.bounds.size.width) < offset.x) {
                acceleration.x *= 0.7;
            }
            if (offset.y < 0.0 || (self.contentSize.height - self.bounds.size.height) < offset.y) {
                acceleration.y *= 0.7;
            }
            
            offset.x = self.contentOffset.x + acceleration.x;
            offset.y = self.contentOffset.y + acceleration.y;
            self.contentOffset = offset;
        }
        

    } else {
        if (0 <= destinationPoint.x && 0 <= destinationPoint.y) {
            if (destinationPoint.x == self.contentOffset.x
                && destinationPoint.y == self.contentOffset.y) {
                
                // stop auto scroll
                destinationPoint = CGPointMake(-1, -1);

            } else {
                
                float axMax = (destinationPoint.x - self.contentOffset.x)*0.15;
                float ayMax = (destinationPoint.y - self.contentOffset.y)*0.15;
                if (fabs(acceleration.x) < fabs(axMax)) {
                    acceleration.x += (axMax - acceleration.x)*0.10;
                    axMax = acceleration.x;
                }
                if (fabs(acceleration.y) < fabs(ayMax)) {
                    acceleration.y += (ayMax - acceleration.y)*0.10;
                    ayMax = acceleration.y;
                }
                
                if (fabs(destinationPoint.x - self.contentOffset.x) < 1.0
                    && fabs(destinationPoint.y - self.contentOffset.y) < 1.0) {
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
    }
    
//    self.lastContentOffset = self.contentOffset;
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
    isCustomDecelerating = NO;
}

#pragma mark - TouchEvent
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.lastTouchPoint = touchPoint;
    self.acceleration = CGPointZero;
    self.lastAcceleration = CGPointZero;


//    //==========
//    if (pageIndex) {
//        NSArray *indexes = [self pageIndex];
//        float targetStart = [[indexes objectAtIndex:0] floatValue];
//        float targetEnd;
//        float width;
//        for (NSNumber *x in indexes) {
//            targetEnd = [x floatValue];
//            width = targetEnd - targetStart;
//            if (targetStart <= self.lastTouchPoint.x
//                && self.lastTouchPoint.x < targetEnd) {
//                if (targetStart < self.contentOffset.x) {
//                    [self setDestinationPoint:CGPointMake(targetStart, 0.0)];
//                } else if (self.contentOffset.x < targetEnd) {
//                    [self setDestinationPoint:CGPointMake(targetEnd, 0.0)];
//                }
//            }
//            targetStart = targetEnd;
//        }
//    }
//    //==========
    
    return YES;
}
#pragma mark - Private Methods
//- (void)setLastContentOffset:(CGPoint)offset {
//    CGPoint lastOffset = self.lastContentOffset;
//    lastOffset.x = offset.x;
//    lastOffset.y = offset.y;
//    lastContentOffset = lastOffset;
//}

#pragma mark - Public Methods
- (void)stopDecelerating {
    [self setContentOffset:CGPointMake(self.contentOffset.x,
                                       self.contentOffset.y)
                  animated:NO];
    destinationPoint = CGPointMake(-1, -1);

    isCustomDecelerating = NO;
}
- (void)startDecelerating {
    isCustomDecelerating = YES;
}

- (void)scrollToPagingOffset {
    if (self.contentOffset.x < 0.0) {
        [self setDestinationPoint:CGPointMake(0.0, 0.0)];
        return;
    }
    
    NSArray *indexes = [self pageIndex];
    float targetStart = [[indexes objectAtIndex:0] floatValue];
    float targetEnd = targetStart;
    BOOL findDestination = NO;
    for (NSNumber *x in indexes) {
        targetEnd = [x floatValue];
        if (targetStart <= self.contentOffset.x
            && self.contentOffset.x < targetEnd) {
            if (self.acceleration.x < 0.0) {
                findDestination = YES;
                [self setDestinationPoint:CGPointMake(targetStart, 0.0)];
                break;
            } else {
                findDestination = YES;
                [self setDestinationPoint:CGPointMake(targetEnd, 0.0)];
                break;
            }
        }
        targetStart = targetEnd;
    }
    
    if (!findDestination) {
        [self setDestinationPoint:CGPointMake(targetEnd, 0.0)];
    }
}


@end
