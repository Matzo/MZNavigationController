//
//  MZTabMenuView.h
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/05/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MZTabMenuView : UIView<UIScrollViewDelegate> {
    UIView *headerView;
    UIView *footerView;
    UITableView *tableView;
    UIView *shadow;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) CGSize iconSize;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;

@end
