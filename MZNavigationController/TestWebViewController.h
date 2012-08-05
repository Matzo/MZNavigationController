//
//  TestWebViewController.h
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 11/06/05.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestWebViewController : UIViewController<UIWebViewDelegate> {
    UIWebView *webView;
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
    UIBarButtonItem *stop;
    UIBarButtonItem *reload;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *back;
@property (nonatomic, strong) UIBarButtonItem *forward;
@property (nonatomic, strong) UIBarButtonItem *stop;
@property (nonatomic, strong) UIBarButtonItem *reload;
@end
