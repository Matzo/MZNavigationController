MZNavigationController - Twitter like navigation controller for iPad
-----------------------------------------
This project aims to provide an open-source implementation of the Twitter like navigation.
Twitter iPad app's navigation UI is so cool! 

I try to make a cool navigation UI that inspired Twitter's.

Install
-------------
Add MZNavigationControllerModule to your Project.


How to use
-------------
You can use MZNavigationController and MZTabBarController instead of UINavigationController and UITabBarController.
And usage is similar to UINavigationController and UITabBarController.

    MZTabBarController *tabController = [[MZTabBarController alloc] init];
    
    UIViewController *first = [[[UIViewController alloc] init] autorelease];
    MZNavigationController *firstNavi = [[[MZNavigationController alloc] initWithRootViewController:first] autorelease];
    
    UIViewController *second = [[[UIViewController alloc] init] autorelease];
    MZNavigationController *secondNavi = [[[MZNavigationController alloc] initWithRootViewController:second] autorelease];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:first, second, nil];
    [tabController setViewControllers:viewControllers animated:NO];


License
-------------
License is New BSD.
Please check the COPYRIGHT file.