//
//  TestViewController.m
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 11/05/14.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import "TestViewController.h"
#import "MZNavigationController.h"
#import "TestWebViewController.h"

@interface TestViewController()
- (UIViewController*)pushTestViewWithAnimated:(BOOL)animated title:(NSString*)title;
- (UIViewController*)pushTestViewWithAnimated:(BOOL)animated width:(float)width title:(NSString*)title;
@end

@implementation TestViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        items = [[NSMutableArray alloc] initWithObjects:
                 @"0:pushView animated",
                 @"1:pushView",
                 @"2:popView animated",
                 @"3:popView",
                 @"4:UINavigationBar",
                 @"5:UIToolbar",
                 @"6:UITabBar",
                 @"7:popToRootView animated",
                 @"8:popToRootView",
                 @"9:hidesBottom = YES",
                 @"10:hidesBottom = NO",
                 @"11:pushView(wide) animated",
                 @"12:pushView(wide)",
                 @"13:resize",
                 @"14:resize next page",
                 @"15:web view",
                 @"16:badge count up",
                 nil];
        
        self.clearsSelectionOnViewWillAppear = NO;
    }
    return self;
}

- (void)dealloc
{
    [items release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                              0.0,
                                                              self.view.bounds.size.width,
                                                              1.0)];
    footer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    footer.backgroundColor = [UIColor greenColor];
    self.tableView.tableFooterView = footer;
    self.tableView.rowHeight = 80.0;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString *item = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    NSString *title = [items objectAtIndex:indexPath.row];

    switch (indexPath.row) {
        case 0: {
            [self pushTestViewWithAnimated:YES title:title];
        } break;
        case 1: {
            [self pushTestViewWithAnimated:NO title:title];
        } break;
        case 2: {
            [self.navigationController popViewControllerAnimated:YES];
        } break;
        case 3: {
            [self.navigationController popViewControllerAnimated:NO];
        } break;
        case 4: {
//            [self.navigationItem setHidesBackButton:!self.navigationItem.hidesBackButton];
            [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
        } break;
        case 5: {
            [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];
            
        } break;
        case 6: {
            [self setHidesBottomBarWhenPushed:!self.hidesBottomBarWhenPushed];

            self.hidesBottomBarWhenPushed = YES;
        } break;
        case 7: {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } break;
        case 8: {
            [self.navigationController popToRootViewControllerAnimated:NO];
        } break;
        case 9: {
            self.hidesBottomBarWhenPushed = YES;
            [self pushTestViewWithAnimated:YES title:title];

        } break;
        case 10: {
            self.hidesBottomBarWhenPushed = NO;
            [self pushTestViewWithAnimated:YES title:title];
        } break;
        case 11: {
            [self pushTestViewWithAnimated:YES width:476.0 title:title];
        } break;
        case 12: {
            [self pushTestViewWithAnimated:NO width:476.0 title:title];
        } break;
        case 13: {
            float width = (self.view.bounds.size.width == 476.0) ? 320.0 : 476.0;
            MZNavigationController *navi = (MZNavigationController*)self.navigationController;
            [navi resizeViewController:self width:width];
        } break;
        case 14: {
            float width = (self.view.bounds.size.width == 476.0) ? 320.0 : 476.0;
            MZNavigationController *navi = (MZNavigationController*)self.navigationController;
            [navi setPageWidth:width];
        } break;
        case 15: {
//            float width = (self.view.bounds.size.width == 476.0) ? 320.0 : 476.0;
            TestWebViewController *nextView = [[[TestWebViewController alloc] init] autorelease];
            nextView.title = title;
            [self.navigationController pushViewController:nextView animated:YES];
        } break;
        case 16: {
            NSString *value = self.navigationController.tabBarItem.badgeValue;
            if (value) {
                value = [NSString stringWithFormat:@"%d", [value intValue]+1];
            } else {
                value = @"1";
            }
            self.navigationController.tabBarItem.badgeValue = value;
            
        } break;

        default:
            break;
    }
}

- (UIViewController*)pushTestViewWithAnimated:(BOOL)animated title:(NSString*)title {
    UITableViewStyle style = (self.tableView.style == UITableViewStyleGrouped) ? UITableViewStylePlain : UITableViewStyleGrouped;
    TestViewController *nextView = [[[TestViewController alloc] initWithStyle:style] autorelease];
    nextView.title = title;
    [self.navigationController pushViewController:nextView animated:animated];
    return nextView;
}

- (UIViewController*)pushTestViewWithAnimated:(BOOL)animated width:(float)width title:(NSString*)title {
    UITableViewStyle style = (self.tableView.style == UITableViewStyleGrouped) ? UITableViewStylePlain : UITableViewStyleGrouped;
    TestViewController *nextView = [[[TestViewController alloc] initWithStyle:style] autorelease];
    nextView.title = title;
    MZNavigationController *mzNavi = (MZNavigationController*)self.navigationController;
    [mzNavi pushViewController:nextView width:width animated:animated];
    return nextView;
}

@end
