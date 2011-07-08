//
//  MZBadgeView.m
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZBadgeView.h"


@implementation MZBadgeView
@synthesize badgeValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        self.hidden = YES;
        
        UIImage *image = [UIImage imageNamed:@"badge"];
        badgeImage = [[UIImageView alloc] initWithImage:
                      [image stretchableImageWithLeftCapWidth:(int)image.size.width/2
                                                 topCapHeight:(int)image.size.height/2]];
        [self addSubview:badgeImage];
        self.frame = badgeImage.frame;

        
        badgeLabel = [[UILabel alloc] initWithFrame:self.frame];
        badgeLabel.font = [UIFont boldSystemFontOfSize:14.0];
        badgeLabel.textAlignment = UITextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        badgeLabel.textColor = [UIColor whiteColor];
        [self addSubview:badgeLabel];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    
//    [[UIColor blueColor] set];
//    [badgeValue drawInRect:rect withFont:[UIFont systemFontOfSize:0.8]];
//    
//    [@"ok" drawInRect:rect withFont:[UIFont systemFontOfSize:0.3]];
//    
//    NSLog(@"kokoha?:%@", badgeValue);
//}

- (void)dealloc
{
    [badgeValue release];
    [badgeImage release];
    [badgeLabel release];
    [super dealloc];
}

- (void)setBadgeValue:(NSString *)badgeValue_ {
    if (![badgeValue isEqualToString:badgeValue_]) {
        [badgeValue release];
        badgeValue = [badgeValue_ retain];
    }
    
    if (badgeValue != nil && ![badgeValue isEqualToString:@""]) {
        badgeLabel.text = badgeValue;
        self.hidden = NO;
        
        CGSize textSize = [badgeValue sizeWithFont:badgeLabel.font];
        CGRect labelFrame = CGRectMake(0.0,
                                       0.0,
                                       MAX(textSize.width + 16.0, badgeImage.image.size.width),
                                       self.bounds.size.height);
        badgeLabel.frame = labelFrame;
        badgeImage.frame = labelFrame;
        self.frame = labelFrame;
    } else {
        badgeLabel.text = nil;
        self.hidden = YES;
    }
}

@end
