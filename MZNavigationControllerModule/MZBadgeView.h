//
//  MZBadgeView.h
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/06/14.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MZBadgeView : UIView {
    NSString *badgeValue;
    UIImageView *badgeImage;
    UILabel *badgeLabel;
}
@property (nonatomic, copy) NSString *badgeValue;

@end
