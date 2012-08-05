//
//  MZNavigationBaseView.h
//  MZNavigationBaseView
//
//  Created by Keisuke Matsuo on 11/05/26.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MZNavigationBaseView : UIView {
    UINavigationBar *navigationBar;
    UIImageView *leftShadow;
    UIImageView *rightShadow;
    UIView *mainView;
    
    UIView *frontShadow;
}
@property (nonatomic, assign) float baseWidth;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *frontShadow;

@end
