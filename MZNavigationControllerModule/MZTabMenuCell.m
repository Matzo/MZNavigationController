//
//  MZTabMenuCell.m
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/05/22.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import "MZTabMenuCell.h"


@implementation MZTabMenuCell
@synthesize tabBarItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        badge = [[MZBadgeView alloc] initWithFrame:CGRectZero];
        [self addSubview:badge];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:24];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:24];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:24];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:24];
    }
}


- (void)setTabBarItem:(UITabBarItem *)tabBarItem_ {
    if (tabBarItem != tabBarItem_) {
        tabBarItem = tabBarItem_;
    }
    self.textLabel.text = tabBarItem.title;
    self.imageView.image = tabBarItem.image;
    
    [tabBarItem addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [badge setBadgeValue:tabBarItem.badgeValue];
}

@end
