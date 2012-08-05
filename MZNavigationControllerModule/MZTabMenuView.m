//
//  MZTabMenuView.m
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/05/22.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import "MZTabMenuView.h"

@implementation MZTabMenuView
@synthesize iconSize;
@synthesize tableView;
@synthesize headerView;
@synthesize footerView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;

        self.tableView = [[UITableView alloc] initWithFrame:frame
                                                       style:UITableViewStylePlain];

        self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        self.tableView.exclusiveTouch = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = 48.0;
        [self addSubview:tableView];

        self.iconSize = CGSizeMake(72.0, 72.0);
        
        shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
        shadow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        shadow.transform = CGAffineTransformScale(shadow.transform, -0.2, 1.0);
        shadow.frame = CGRectMake(self.bounds.size.width,
                                  0.0,
                                  shadow.frame.size.width,
                                  self.bounds.size.height);
        [self addSubview:shadow];

    }
    return self;
}


- (void)layoutSubviews {
    CGRect headerFrame = CGRectZero;
    CGRect footerFrame = CGRectZero;
    CGRect tableFrame = self.frame;
    if (headerView) {
        headerFrame.origin.x = 0.0;
        headerFrame.origin.y = 0.0;
        headerFrame.size.width = self.frame.size.width;
        headerFrame.size.height = headerView.frame.size.height;
        headerView.frame = headerFrame;
        headerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
                                    | UIViewAutoresizingFlexibleRightMargin;
    }
    if (footerView) {
        footerFrame.origin.x = 0.0;
        footerFrame.origin.y = self.frame.size.height - footerView.frame.size.height;
        footerFrame.size.width = self.frame.size.width;
        footerFrame.size.height = footerView.frame.size.height;
        footerView.frame = footerFrame;
        footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
                                    | UIViewAutoresizingFlexibleRightMargin;
    }
    tableFrame.origin.x = 0.0;
    tableFrame.origin.y = headerFrame.size.height;
    tableFrame.size.width = self.frame.size.width;
    tableFrame.size.height = self.frame.size.height - headerFrame.size.height - footerFrame.size.height;
    tableView.frame = tableFrame;
}

#pragma mark - Public Methods
- (void)setHeaderView:(UIView *)headerView_ {
    if (headerView != headerView_) {
        [headerView removeFromSuperview];
        headerView = headerView_;
    }
    [self addSubview:headerView];
    [self setNeedsLayout];
}
- (void)setFooterView:(UIView *)footerView_ {
    if (footerView != footerView_) {
        [footerView removeFromSuperview];
        footerView = footerView_;
    }
    [self addSubview:footerView];
    [self setNeedsLayout];
}


@end
