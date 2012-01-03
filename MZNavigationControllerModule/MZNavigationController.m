//
//  MZNavigationController.m
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 11/05/12.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import "MZNavigationController.h"

@interface MZNavigationController()
- (NSArray*)pageOffsetIndexes;
- (CGPoint)nextViewPoint;
- (NSInteger)indexForViewController:(UIViewController*)viewController;
- (MZNavigationBaseView*)baseViewForViewController:(UIViewController*)viewController;
- (UIViewController*)currentFocusViewController;
- (void)addRelationalViews;
- (void)scrollToPagingOffset;
- (void)layoutRelationalViews;
- (void)scrollToViewRect:(CGRect)rect;
- (void)setBaseViewForViewController:(UIViewController*)viewController;
@end

@implementation MZNavigationController
@synthesize scrollView;
@synthesize sideMenu;
@synthesize lastTouchPoint;
@synthesize acceleration;
@synthesize isChangingByTab;
@synthesize pageWidth;


- (id)initWithRootViewController:(UIViewController*)rootViewController width:(float)width {
    pageWidth = width;
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController*)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [baseViews release];
    [scrollView release];
    [sideMenu release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    if (!baseViews) {
        baseViews = [[NSMutableArray alloc] init];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!pageWidth) {
        pageWidth = 476.0;
    }

    self.scrollView = [[[MZNavigationScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    
    isChangingByTab = NO;
    
    offsetX = self.view.bounds.size.width - pageWidth;
    self.lastTouchPoint = CGPointZero;
    
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.decelerationRate = 0.0;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.delegate = self;
    [self.view addSubview:self.scrollView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.navigationBarHidden = YES;

    for (UIViewController *viewController in self.viewControllers) {
        [self setBaseViewForViewController:viewController];
    }

    [self.view addSubview:self.scrollView];
    [self addRelationalViews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
////    self.view.frame = CGRectMake(0.0,
////                                 0.0,
////                                 self.tabBarController.view.bounds.size.width,
////                                 self.tabBarController.view.bounds.size.height);
//    [self layoutRelationalViews];
//    NSLog(@"will screen width:%f", [UIScreen mainScreen].bounds.size.width);
//
//}
//- (void)didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
////    [self layoutRelationalViews];
//}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
    
    [self addRelationalViews];
    [self scrollToViewRect:baseView.frame];
}

#pragma mark - UINavigationController override
- (void)pushViewController:(UIViewController *)viewController
                     width:(float)width
                  animated:(BOOL)animated{
    
    offsetX = self.view.frame.size.width - width;
    
    [self popToViewController:[self currentFocusViewController] animated:animated];
    
    CGPoint nextPoint = [self nextViewPoint];
    
    viewController.view.frame = CGRectMake(0.0,
                                           0.0,
                                           width,
                                           self.view.frame.size.height);
    
    //---------------
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:NO];
    [self setBaseViewForViewController:viewController];
    self.scrollView.pageIndex = self.pageOffsetIndexes;
    //---------------
    
    MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
    baseView.alpha = 0.0;
    
    CGRect baseViewFrame = viewController.view.superview.frame;
    baseView.frame = CGRectMake(nextPoint.x + viewController.view.frame.size.width,
                                nextPoint.y,
                                baseViewFrame.size.width,
                                baseViewFrame.size.height);
    
    pushingCount++;
    float duration = (animated) ? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^(void) {
        baseView.frame = CGRectMake(nextPoint.x,
                                    nextPoint.y,
                                    baseViewFrame.size.width,
                                    baseViewFrame.size.height);
        baseView.alpha = 1.0;
    } completion:^(BOOL finished) {
        pushingCount--;
        [self layoutRelationalViews];
        UIViewController *lastView = (UIViewController*)[self.viewControllers lastObject];
        [self scrollToViewRect:[self baseViewForViewController:lastView].frame];
    }];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self pushViewController:viewController width:pageWidth animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {

    UIViewController *currentView = [self currentFocusViewController];
    
    UIViewController *parentView = nil;
    for (UIViewController *viewController in self.viewControllers) {
        if (viewController == currentView) {
            break;
        }
        parentView = viewController;
    }
    
    NSArray *popList = [self popToViewController:parentView animated:animated];

    return 0 < [popList count] ? [popList lastObject] : nil;
}


- (NSArray*)popToRootViewControllerAnimated:(BOOL)animated {
    if (0 < [self.viewControllers count]) {
        UIViewController *rootView = [self.viewControllers objectAtIndex:0];
        return [self popToViewController:rootView animated:animated];
    } else {
        return nil;
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray *popViewList = [NSMutableArray array];
    UIViewController *popView = nil;
    viewController.hidesBottomBarWhenPushed = YES;
    if ([self.viewControllers containsObject:viewController]) {
        BOOL first = YES;
        while (self.topViewController != viewController) {
            if (first) {
                [viewController viewWillAppear:animated];
                first = NO;
            }

            //----------------
            popView = [super popViewControllerAnimated:NO];
            [[self baseViewForViewController:self.topViewController] setNeedsLayout];
            self.scrollView.pageIndex = self.pageOffsetIndexes;
            //----------------

            if (!popView) break;
            MZNavigationBaseView *removingBaseView = [self baseViewForViewController:popView];
            [baseViews removeObject:removingBaseView];
            
            [popViewList addObject:popView];
            
            [removingBaseView addSubview:popView.view];
            popingCount++;
            float duration = (animated) ? 0.5 : 0.0;
            [UIView animateWithDuration:duration animations:^(void) {
                CGRect frame = removingBaseView.frame;
                removingBaseView.frame = CGRectMake(frame.origin.x + frame.size.width,
                                            frame.origin.y,
                                            frame.size.width,
                                            frame.size.height);
                removingBaseView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [popView.view removeFromSuperview];
                [removingBaseView removeFromSuperview];
                
                popingCount--;
                [self layoutRelationalViews];
                [viewController viewDidAppear:animated];

                UIViewController *lastView = (UIViewController*)[self.viewControllers lastObject];
                [self scrollToViewRect:[self baseViewForViewController:lastView].frame];
            }];
        }
    }
    return [NSArray arrayWithArray:popViewList];
}

- (BOOL)navigationBarHidden {
    UIViewController *viewController = [self currentFocusViewController];
    MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];

    return baseView.navigationBar.hidden;
}

- (void)setNavigationBarHidden:(BOOL)hidden {
    [super setNavigationBarHidden:YES];
}
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:NO];
}

- (BOOL)isToolbarHidden {
    return YES;
}
- (void)setToolbarHidden:(BOOL)hidden {
    [super setToolbarHidden:YES];
}
- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setToolbarHidden:YES animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_ {
    self.scrollView.pageIndex = self.pageOffsetIndexes;
    
    [self.scrollView stopDecelerating];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
    [self layoutRelationalViews];
    

    float ax = (self.scrollView.contentOffset.x - self.scrollView.lastContentOffset.x);
    float ay = (self.scrollView.contentOffset.y - self.scrollView.lastContentOffset.y);
    self.scrollView.lastAcceleration = CGPointMake(ax, ay);
    self.scrollView.lastContentOffset = self.scrollView.contentOffset;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView_ willDecelerate:(BOOL)decelerate {
    [self scrollToPagingOffset];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView_ {
    self.scrollView.acceleration = self.scrollView.lastAcceleration;

    if (scrollView_.contentOffset.x < -100.0) {
        [self popToRootViewControllerAnimated:YES];
    }

    [self scrollToPagingOffset];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollToPagingOffset {
    [self.scrollView stopDecelerating];
    [self.scrollView startDecelerating];
}

#pragma mark - Private Methods for navigation controller
- (NSArray*)pageOffsetIndexes {
    NSMutableSet *indexes = [NSMutableSet set];
    float x = 0.0;
    float menuIconWidth = 0.0;
    float scrollViewWidth = self.scrollView.bounds.size.width;
    [indexes addObject:[NSNumber numberWithFloat:x]];

    if (self.sideMenu) {
        menuIconWidth = self.sideMenu.iconSize.width;
        x += self.sideMenu.bounds.size.width;
    }
    
    for (UIViewController *viewController in self.viewControllers) {
        [indexes addObject:[NSNumber numberWithFloat:x - menuIconWidth]];

        MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
        float pageOffset = scrollViewWidth - baseView.bounds.size.width;
        float rightSide = x - pageOffset;

        if (0 < rightSide) [indexes addObject:[NSNumber numberWithFloat:rightSide]];
        x += baseView.frame.size.width;
    }
    NSArray *sortDescriptor = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"floatValue" ascending:YES], nil];
    NSArray *sortedIndex = [NSArray arrayWithArray:[indexes sortedArrayUsingDescriptors:sortDescriptor]];
    return sortedIndex;
}

- (NSInteger)indexForViewController:(UIViewController*)viewController {
    NSInteger index = 0;
    for (UIViewController *stackedViewContoller in self.viewControllers) {
        if (stackedViewContoller == viewController) {
            break;
        }
        index++;
    }
    
    return index;
}

- (MZNavigationBaseView*)baseViewForViewController:(UIViewController*)viewController {
    NSInteger index = [self indexForViewController:viewController];
    MZNavigationBaseView *baseView = nil;
    if (index < [baseViews count]) {
        baseView = [baseViews objectAtIndex:index];
    }
    return baseView;
}

- (CGPoint)nextViewPoint {
    MZNavigationBaseView *baseView = nil;
    
    float x = offsetX;
    for (UIViewController *viewController in self.viewControllers) {
        baseView = [self baseViewForViewController:viewController];
        x += baseView.baseWidth;
    }
    float y = (baseView) ? baseView.frame.origin.y : 0.0;
    return CGPointMake(x, y);
}
- (UIViewController*)currentFocusViewController {
    UIViewController *focusViewController = nil;
    CGPoint p = self.scrollView.lastTouchPoint;
    for (UIViewController *viewConroller in self.viewControllers) {
        MZNavigationBaseView *baseView = [self baseViewForViewController:viewConroller];
        CGRect f = baseView.frame;
        if (f.origin.x <= p.x && p.x < f.origin.x + f.size.width
            && f.origin.y <= p.y && p.y < f.origin.y + f.size.height) {
            focusViewController = [[viewConroller retain] autorelease];
        }
    }
    
    self.scrollView.lastTouchPoint = CGPointMake(-1.0, -1.0);
    return focusViewController;
}
- (void)setBaseViewForViewController:(UIViewController*)viewController {

    MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
    if (!baseView) {
        
        CGPoint viewPoint = [self nextViewPoint];
        CGRect baseViewFrame = CGRectMake(viewPoint.x - viewController.view.bounds.size.width,
                                          viewPoint.y,
                                          pageWidth,
                                          self.scrollView.bounds.size.height);        
        
        baseView = [[[MZNavigationBaseView alloc] initWithFrame:baseViewFrame] autorelease];
        [baseViews addObject:baseView];

        // navigation bar
        [baseView.navigationBar pushNavigationItem:viewController.navigationItem animated:NO];

        // tool bar
        [baseView.toolbar setItems:viewController.toolbarItems];
        [baseView setNeedsLayout];
    }

    baseView.mainView = viewController.view;
    [self.scrollView addSubview:baseView];

    float barHeight = baseView.navigationBar.bounds.size.height;
    viewController.view.frame = CGRectMake(0.0,
                                           barHeight,
                                           viewController.view.frame.size.width,
                                           viewController.view.frame.size.height - barHeight);

}

- (void)addRelationalViews {
    for (UIViewController *viewController in self.viewControllers) {
        MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
        [baseView addSubview:viewController.view];
        [self.scrollView bringSubviewToFront:baseView];
        [baseView setNeedsLayout];
    }
    [self layoutRelationalViews];
}

- (void)layoutRelationalViews {
    float contentsWidthSum = 0.0;
    float menuIconSize = 0.0;

    if (self.sideMenu) {
        menuIconSize = self.sideMenu.iconSize.width;
        if (self.sideMenu.superview == self.scrollView) {
            self.sideMenu.frame = CGRectMake(self.scrollView.contentOffset.x,
                                             0.0,
                                             self.sideMenu.frame.size.width,
                                             self.sideMenu.frame.size.height);
        }

        contentsWidthSum += self.sideMenu.frame.size.width;
        
    }
    
    int i = 0;
    int lastBaseViewIndex = [baseViews count] - 1;
    for (UIViewController *viewController in self.viewControllers) {
        MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
        baseView.frame = CGRectMake(contentsWidthSum,
                                    0.0,
                                    baseView.baseWidth,
                                    self.scrollView.frame.size.height);

        if (baseView.frame.origin.x + baseView.baseWidth <= self.scrollView.contentOffset.x + menuIconSize
                && i != lastBaseViewIndex) {
            baseView.hidden = YES;
        } else {
            baseView.hidden = NO;
        }
        
        float shadowAlpha = 0.0;
        if (baseView.frame.origin.x < self.scrollView.contentOffset.x + menuIconSize) {
            baseView.frame = CGRectMake(self.scrollView.contentOffset.x + menuIconSize,
                                             0.0,
                                             baseView.frame.size.width,
                                             baseView.frame.size.height);
            
            if (i != lastBaseViewIndex) {
                shadowAlpha = ((baseView.frame.origin.x - contentsWidthSum)/baseView.baseWidth)*0.3;
            }
        }
        baseView.frontShadow.alpha = shadowAlpha;
        
        contentsWidthSum += baseView.baseWidth;
        i++;
    }
    for (int j = [self.viewControllers count]; 0 < j; j--) {
        UIViewController *viewController = [self.viewControllers objectAtIndex:j-1];
        MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
        [self.scrollView sendSubviewToBack:baseView];
    }
    if (self.sideMenu) [self.scrollView sendSubviewToBack:self.sideMenu];


    float contentWidth;
    float minWidth = self.scrollView.bounds.size.width + 1;
    if (popingCount == 0 && pushingCount == 0) {
        contentWidth = MAX(contentsWidthSum, minWidth);
    } else {
        contentWidth = MAX(contentsWidthSum + pageWidth, minWidth);
    }
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.frame.size.height);
}

- (void)scrollToViewRect:(CGRect)rect {
    CGPoint toPoint = CGPointMake(rect.origin.x - offsetX, rect.origin.y);
    [self.scrollView setDestinationPoint:toPoint];
}

#pragma mark - Public Methods
- (void)resizeViewController:(UIViewController *)viewController width:(float)width {
    
    if ([self.viewControllers containsObject:viewController]) {
        MZNavigationBaseView *baseView = [self baseViewForViewController:viewController];
        [baseView setBaseWidth:width];
        [self layoutRelationalViews];
    }
}
- (void)setPageWidth:(float)pageWidth_ {
    if (self.pageWidth != pageWidth_) {
        pageWidth = pageWidth_;
        [self layoutRelationalViews];
    }
}
@end
