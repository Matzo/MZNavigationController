//
//  MZNavigationControllerAppDelegate.m
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 11/05/12.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import "MZNavigationControllerAppDelegate.h"

#import "MZNavigationController.h"
#import "TestViewController.h"
#import "MZTabBarController.h"
#import "MZBadgeView.h"

@implementation MZNavigationControllerAppDelegate


@synthesize window=_window;

//@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    MZTabBarController *tabCon = [[MZTabBarController alloc] init];
    self.window.rootViewController = tabCon;
    
    UIView *menuHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                  0.0,
                                                                  tabCon.sideMenu.frame.size.width,
                                                                  50.0)];
    menuHeader.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    UIView *menuFooter = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                  0.0,
                                                                  tabCon.sideMenu.frame.size.width,
                                                                  50.0)];
    menuFooter.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    tabCon.sideMenu.headerView = menuHeader;
    tabCon.sideMenu.footerView = menuFooter;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:tabCon.view.bounds];
    backgroundView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    tabCon.backgroundView = backgroundView;
    
//    tabCon.homeViewController = [[[TestHomeViewController alloc] init] autorelease];

    float iPhoneWidth = 320.0;
//    float iPadWidth = 476.0;
    float fullWidth = [[UIScreen mainScreen] applicationFrame].size.width - tabCon.sideMenu.iconSize.width;

    NSMutableArray *viewControllerList = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        UITableViewStyle style = (i%2 == 0) ? UITableViewStylePlain : UITableViewStyleGrouped;
        TestViewController *topView = [[[TestViewController alloc] initWithStyle:style] autorelease];
        MZNavigationController *mzNavi;
        
        if (5 < i) {
            mzNavi = [[[MZNavigationController alloc] initWithRootViewController:topView
                                                                           width:fullWidth]
                      autorelease];
        } else if (2 < i) {
            mzNavi = [[[MZNavigationController alloc] initWithRootViewController:topView]
                      autorelease];
        } else {
            mzNavi = [[[MZNavigationController alloc] initWithRootViewController:topView
                                                                           width:iPhoneWidth]
                      autorelease];
        }
        
        NSString *title = [NSString stringWithFormat:@"menu %d", i+1];
        UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        mzNavi.tabBarItem = [[[UITabBarItem alloc] initWithTitle:title
                                                           image:icon
                                                             tag:i] autorelease];
        topView.title = title;
        
        [viewControllerList addObject:mzNavi];
    }
    
    tabCon.view.frame = [[UIScreen mainScreen] applicationFrame];

    [tabCon setViewControllers:[NSArray arrayWithArray:viewControllerList] animated:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
//    [_viewController release];
    [super dealloc];
}

@end
