//
//  MZTouchHandlerView.m
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 12/01/03.
//  Copyright (c) 2012年 Keisuke Matsuo. All rights reserved.
//

#import "MZTouchHandlerView.h"

@implementation MZTouchHandlerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBegan");
    self.userInteractionEnabled = NO;
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSLog(@"touchesMoved");
    self.userInteractionEnabled = NO;
    [self removeFromSuperview];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"touchesEnded");
    self.userInteractionEnabled = YES;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"touchesCancelled");
    self.userInteractionEnabled = YES;
}

@end
