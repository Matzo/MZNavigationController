//
//  MZTabBarController.h
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/05/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTabMenuView.h"

enum {
    MZTabBarControllerLayoutDefaul = 0,
    MZTabBarControllerLayoutLeftNavi
};


@interface MZTabBarController : UITabBarController<UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    MZTabMenuView *sideMenu;
    UIView *backgroundView;
}
@property (nonatomic, retain) MZTabMenuView *sideMenu;
@property (nonatomic, retain) UIView *backgroundView;
- (void)setLayout:(int)layoutType;

@end
