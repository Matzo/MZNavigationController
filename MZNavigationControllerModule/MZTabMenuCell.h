//
//  MZTabMenuCell.h
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/05/22.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZBadgeView.h"

@interface MZTabMenuCell : UITableViewCell {
    UITabBarItem *tabBarItem;
    
    MZBadgeView *badge;
}
@property (nonatomic, retain) UITabBarItem *tabBarItem;

@end
