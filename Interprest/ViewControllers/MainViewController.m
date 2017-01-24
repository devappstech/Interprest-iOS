//
//  ButtonContainerViewController.m
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PostsViewController.h"
#import "ConferenceViewController.h"
#import "MainViewController.h"

@implementation MainViewController
{
    BOOL _isReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.isProgressiveIndicator = NO;
    // Do any additional setup after loading the view.
    self.buttonBarView.selectedBar.backgroundColor = [UIColor whiteColor];
    self.buttonBarView.backgroundColor = [UIColor colorWithRed:54/255.0 green:169/255.0 blue:225/255.0 alpha:1.0];
}

#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    // create child view controllers that will be managed by XLPagerTabStripViewController
    
    ConferenceViewController * child_1 = [self.storyboard instantiateViewControllerWithIdentifier:@"conferenceViewController"];
    PostsViewController * child_2 = [self.storyboard instantiateViewControllerWithIdentifier:@"postsViewController"];
    
    /*
    ConferenceViewController * child_1 = [[ConferenceViewController alloc] init];
    PostsViewController * child_2 = [[PostsViewController alloc] initWithStyle:UITableViewStylePlain];
    */
    
    return @[child_1, child_2];
    
}

-(void)reloadPagerTabStripView
{
    _isReload = YES;
    self.isProgressiveIndicator = (rand() % 2 == 0);
    self.isElasticIndicatorLimit = (rand() % 2 == 0);
    [super reloadPagerTabStripView];
}

@end
