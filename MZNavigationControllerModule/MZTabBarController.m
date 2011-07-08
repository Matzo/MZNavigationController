//
//  MZTabBarController.m
//  MZTabBarController
//
//  Created by Keisuke Matsuo on 11/05/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZTabBarController.h"
#import "MZTabMenuCell.h"
#import "MZNavigationController.h"

@interface MZTabBarController()
- (void)deselectViewController:(UIViewController*)viewController;
@end


@implementation MZTabBarController
@synthesize sideMenu;
@synthesize backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [sideMenu release];
    [backgroundView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    for (UIViewController *viewController in self.viewControllers) {
        if (viewController != self.selectedViewController &&
            [viewController isMemberOfClass:[MZNavigationController class]]) {
            [((MZNavigationController*)viewController) popToRootViewControllerAnimated:NO];
        }
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    self.delegate = self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight
                            | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    CGRect menuFrame = CGRectMake(0.0,
                                  0.0,
                                  292.0,
                                  self.view.frame.size.height);
    self.sideMenu = [[[MZTabMenuView alloc] initWithFrame:menuFrame] autorelease];
    self.sideMenu.tableView.delegate = self;
    self.sideMenu.tableView.dataSource = self;
    self.sideMenu.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;

    [self.view addSubview:sideMenu];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    for (UIViewController *viewController in self.viewControllers) {
        MZNavigationController *mzNavi = (MZNavigationController*)viewController;
        [mzNavi scrollToPagingOffset];
        mzNavi.scrollView.contentSize = CGSizeMake(mzNavi.scrollView.contentSize.width, self.view.bounds.size.height);
    }
}

#pragma mark - UITabBarController override
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:NO];
    
    [self setLayout:MZTabBarControllerLayoutLeftNavi];
}
- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    UIViewController *previousViewController = self.selectedViewController;
    
    [super setSelectedViewController:selectedViewController];
    
    [self deselectViewController:previousViewController];

    [self setLayout:MZTabBarControllerLayoutLeftNavi];
    
    int index = [self.viewControllers indexOfObject:selectedViewController];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [sideMenu.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *selectedController = [self.viewControllers objectAtIndex:indexPath.row];
    
    if (self.selectedViewController != selectedController) {
        [self setSelectedViewController:selectedController];

        if ([selectedController isMemberOfClass:[MZNavigationController class]]) {
            MZNavigationController *mzNavi = (MZNavigationController*)selectedController;
            mzNavi.isChangingByTab = YES;
        }
        [self.view addSubview:self.sideMenu];
        [self.view sendSubviewToBack:self.sideMenu];
        [self.view sendSubviewToBack:self.backgroundView];
        self.sideMenu.frame = CGRectMake(0.0,
                                         0.0,
                                         self.sideMenu.bounds.size.width,
                                         self.sideMenu.bounds.size.height);
        selectedController.view.alpha = 0.0;
        selectedController.view.frame = CGRectMake(selectedController.view.bounds.size.width,
                                                   0.0,
                                                   selectedController.view.bounds.size.width,
                                                   selectedController.view.bounds.size.height);
        [UIView animateWithDuration:0.5 animations:^(void) {
            selectedController.view.alpha = 1.0;
            selectedController.view.frame = CGRectMake(0.0,
                                                       0.0,
                                                       selectedController.view.bounds.size.width,
                                                       selectedController.view.bounds.size.height);
        } completion:^(BOOL finished) {
            if ([selectedController isMemberOfClass:[MZNavigationController class]]) {
                MZNavigationController *mzNavi = (MZNavigationController*)selectedController;
                mzNavi.isChangingByTab = NO;
                [mzNavi setSideMenu:self.sideMenu];
                [mzNavi.scrollView addSubview:self.sideMenu];
                [mzNavi addRelationalViews];
            }
        }];

    } else {
        if ([selectedController isMemberOfClass:[MZNavigationController class]]) {
            [((MZNavigationController*)selectedController) popToRootViewControllerAnimated:YES];
        }
    }
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MZTabBarController_sideNaviCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[MZTabMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:indexPath.row];
    
    [(MZTabMenuCell*)cell setTabBarItem:viewController.tabBarItem];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewControllers count];
}

#pragma mark - Publick Methods
- (void)setLayout:(int)layoutType {
    if (layoutType == MZTabBarControllerLayoutLeftNavi) {
        
        // MZNavigation pattern
        [self.view addSubview:self.selectedViewController.view];
        
        CGRect toFrame = CGRectMake(0.0,
                                    0.0,
                                    self.selectedViewController.view.frame.size.width,
                                    self.selectedViewController.view.frame.size.height);
        self.selectedViewController.view.frame = toFrame;
        
        [self.tabBar setHidden:YES];
        
        if ([self.selectedViewController isMemberOfClass:[MZNavigationController class]]) {
            MZNavigationController *mzNavi = (MZNavigationController*)self.selectedViewController;
            [mzNavi setSideMenu:self.sideMenu];
            [mzNavi.scrollView addSubview:self.sideMenu];
            [mzNavi.scrollView sendSubviewToBack:self.sideMenu];
            [mzNavi addRelationalViews];
        }
        
        if (backgroundView) {
            [self.view sendSubviewToBack:backgroundView];
        }
    }
}

- (void)setBackgroundView:(UIView *)backgroundView_ {
    if (backgroundView != backgroundView_) {
        [backgroundView removeFromSuperview];
        [backgroundView release];
        backgroundView = [backgroundView_ retain];
    }
    [self.view addSubview:backgroundView];
}

#pragma mark - Private Methods
- (void)deselectViewController:(UIViewController*)viewController {

    [self.view addSubview:viewController.view];
    [UIView animateWithDuration:0.5 animations:^(void) {
        CGRect toFrame = CGRectMake(self.view.frame.size.width,
                                    0.0,
                                    viewController.view.frame.size.width,
                                    viewController.view.frame.size.height);
        viewController.view.frame = toFrame;
        viewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [viewController.view removeFromSuperview];
    }];
}
@end
