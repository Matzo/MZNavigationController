//
//  MZTabMenuView.h
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/05/22.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MZTabMenuView : UIView<UIScrollViewDelegate> {
    UIView *headerView;
    UIView *footerView;
    UITableView *tableView;
    UIView *shadow;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGSize iconSize;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@end
