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
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIView *frontShadow;

@end
