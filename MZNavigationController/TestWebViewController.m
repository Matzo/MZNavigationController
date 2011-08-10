//
//  TestWebViewController.m
//  MZNavigationController
//
//  Created by Keisuke Matsuo on 11/06/05.
//  Copyright 2011 Keisuke Matsuo. All rights reserved.
//

#import "TestWebViewController.h"

@interface TestWebViewController()
- (void)updateButtonsStatus;
@end

@implementation TestWebViewController
@synthesize webView;
@synthesize back;
@synthesize forward;
@synthesize stop;
@synthesize reload;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [webView release];
    [back release];
    [forward release];
    [stop release];
    [reload release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];

    [self.navigationController setToolbarHidden:NO];
    self.back = [[[UIBarButtonItem alloc] initWithTitle:@"<"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(historyBack)] autorelease];
    back.enabled = NO;
    self.forward = [[[UIBarButtonItem alloc] initWithTitle:@">"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(historyForward)] autorelease];
    forward.enabled = NO;
    self.stop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopLoading)];
    stop.enabled = NO;
    self.reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadPage)];
    reload.enabled = NO;

    [self setToolbarItems:[NSArray arrayWithObjects:back,forward,stop,reload, nil]];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.co.jp"]];
    [self.webView loadRequest:req];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Action Methods
- (void)historyBack {
    [self.webView goBack];
}
- (void)historyForward {
    [self.webView goForward];
}
- (void)stopLoading {
    [self.webView stopLoading];
}
- (void)reloadPage {
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self updateButtonsStatus];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self updateButtonsStatus];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateButtonsStatus];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateButtonsStatus];
}

#pragma mark - Private Methods
- (void)updateButtonsStatus {
    self.back.enabled = [self.webView canGoBack];
    self.forward.enabled = [self.webView canGoForward];
    self.stop.enabled = [self.webView isLoading];
    self.reload.enabled = ![self.webView isLoading];
}


@end
