//
//  MZNavigationBaseView.m
//  MZNavigationBaseView
//
//  Created by Keisuke Matsuo on 11/05/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZNavigationBaseView.h"


@implementation MZNavigationBaseView
@synthesize navigationBar;
@synthesize toolbar;
@synthesize baseWidth;
@synthesize mainView;
@synthesize frontShadow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.baseWidth = frame.size.width;
        
        CGRect navBarFrame = CGRectMake(0.0,
                                        0.0,
                                        self.frame.size.width,
                                        44.0);
        self.navigationBar = [[[UINavigationBar alloc] initWithFrame:navBarFrame] autorelease];
        [self addSubview:navigationBar];
        
        CGRect barFrame = CGRectMake(0.0,
                                     frame.size.height,
                                     frame.size.width,
                                     44.0);
        self.toolbar = [[[UIToolbar alloc] initWithFrame:barFrame] autorelease];
        self.toolbar.hidden = YES;
        
        [self addSubview:self.toolbar];
        
        leftShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
        leftShadow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:leftShadow];

        rightShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
        rightShadow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        rightShadow.transform = CGAffineTransformScale(rightShadow.transform, -1.0, 1.0);
        [self addSubview:rightShadow];

        
        self.frontShadow = [[UIView alloc] initWithFrame:self.bounds];
        frontShadow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        frontShadow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        frontShadow.alpha = 0.0;
        frontShadow.userInteractionEnabled = NO;
        [self addSubview:frontShadow];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect navBarFrame = CGRectMake(0.0,
                                    0.0,
                                    baseWidth,
                                    44.0);
    self.navigationBar.frame = navBarFrame;
    
    self.toolbar.hidden = (toolbar.items == nil || [toolbar.items count] == 0);
    
    float y = self.frame.size.height - (self.toolbar.hidden?0:1) * self.toolbar.frame.size.height;  
    self.toolbar.frame = CGRectMake(0.0,
                                    y,
                                    baseWidth,
                                    self.toolbar.frame.size.height);

    mainView.frame = CGRectMake(0.0,
                                self.navigationBar.frame.size.height,
                                baseWidth,
                                self.bounds.size.height
                                - self.navigationBar.frame.size.height
                                - (self.toolbar.hidden?0:1) * self.toolbar.frame.size.height);

    leftShadow.frame = CGRectMake(-leftShadow.bounds.size.width,
                              0.0,
                              leftShadow.bounds.size.width,
                              self.bounds.size.height);
    
    rightShadow.frame = CGRectMake(self.bounds.size.width,
                                   0.0,
                                   rightShadow.bounds.size.width,
                                   self.bounds.size.height);
    
    [self bringSubviewToFront:self.navigationBar];
    [self bringSubviewToFront:frontShadow];
}

- (void)dealloc
{
    [frontShadow release];
    [navigationBar release];
    [toolbar release];
    [leftShadow release];
    [rightShadow release];
    [mainView release];
    [super dealloc];
}

- (void)setBaseWidth:(float)baseWidth_ {
    baseWidth = baseWidth_;
    [self setNeedsLayout];
}

- (void)setMainView:(UIView *)mainView_ {
    if (self.mainView != mainView_) {
        [self.mainView removeFromSuperview];
        [self.mainView autorelease];
        mainView = [mainView_ retain];
    }
    
    [self addSubview:self.mainView];
}

@end
