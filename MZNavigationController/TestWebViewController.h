//
//  TestWebViewController.h
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 11/06/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestWebViewController : UIViewController<UIWebViewDelegate> {
    UIWebView *webView;
    UIBarButtonItem *back;
    UIBarButtonItem *forward;
    UIBarButtonItem *stop;
    UIBarButtonItem *reload;
}
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *back;
@property (nonatomic, retain) UIBarButtonItem *forward;
@property (nonatomic, retain) UIBarButtonItem *stop;
@property (nonatomic, retain) UIBarButtonItem *reload;
@end
