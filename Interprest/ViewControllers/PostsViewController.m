//
//  TableChildExampleViewController.m
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

#import "XLJSONSerialization.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PostCell.h"
#import "PostsViewController.h"
#import "PostCriteria.h"
#import "Globals.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "Constants.h"


NSString *const kCellIdentifier = @"PostCell";

@interface PostsViewController ()

@property (nonatomic)  PostCriteria *criteria;
@property (nonatomic)  NSMutableArray *posts;
@property (weak, nonatomic) UILabel *placeholder;

@end

@implementation PostsViewController
{
    PostCell * _offScreenCell;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //posts = [[XLJSONSerialization sharedInstance] postsData];
    }
    return self;
}

- (NSArray *)loadPosts: (int) page
{
    self.criteria = [[PostCriteria alloc] init];
    self.criteria.page = [NSNumber numberWithInt:page];
    self.criteria.size = [NSNumber numberWithInt:pageSize];
    self.criteria.language = [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
    self.criteria.statuses = @[ @(2)];
    PostService *postService = [[Globals sharedInstance] postService];
    
    return [postService findAllByCriteria: self.criteria];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.posts = [[NSMutableArray alloc] init];
    
    [self.posts addObjectsFromArray: [self loadPosts: 1]];
    [NSTimer scheduledTimerWithTimeInterval:60.0f
                                     target:self selector:@selector(refreshPosts) userInfo:nil repeats:YES];
    
    
    
    [self.tableView registerClass:[PostCell class] forCellReuseIdentifier:kCellIdentifier];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.font = [placeholder.font fontWithSize:20];
    placeholder.numberOfLines = 0; // Use as many lines as needed.
    placeholder.text = NSLocalizedString(@"general.no_posts", nil);
    placeholder.textAlignment = NSTextAlignmentCenter;
    placeholder.textColor = [UIColor grayColor];
    self.placeholder.hidden = YES;
     // Initially hidden.
    [self.tableView addSubview:placeholder];
    
    self.placeholder = placeholder;
    [self showIsEmpty];
}



- (void)showIsEmpty
{
    if ([self.posts count] == 0){
        self.placeholder.hidden = NO;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    else{
        self.placeholder.hidden = YES;
        self.tableView.separatorColor = [UIColor lightGrayColor];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.placeholder.frame = self.tableView.bounds;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostCell *cell = (PostCell *) [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Post *post = [_posts objectAtIndex:indexPath.row];
    cell.userName.text = post.title;
    cell.postDate.text = [self timeAgo:post.updatedAt];
    cell.postText.text = post.postDescription;
    [cell.postText setPreferredMaxLayoutWidth:self.view.bounds.size.width];
    NSLog(@"%@" ,[NSString stringWithFormat:@"%@%@", publicServerUrl, post.image]);
    if (post.image != nil && ![post.image isEqualToString:@""]){
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", publicServerUrl, post.image]] placeholderImage:[UIImage imageNamed:@"logo_top.png"]];
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.layer.borderWidth = 0;
    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
        
    [cell.userImage setUserInteractionEnabled:YES];
     UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage:)];
        [singleTap setNumberOfTapsRequired:1];
        [cell.userImage addGestureRecognizer:singleTap];
        
    cell.userImage.tag = indexPath.row;
    }
    return cell;
}

-(void)onClickImage:(UIGestureRecognizer *)recognizer
{
    Post *post = [_posts objectAtIndex:recognizer.view.tag];
    FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString: post.image] name: nil];
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:@[firstPhoto]];
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    
    UIImage* logoImage = [UIImage imageNamed:@"logo_top.png"];
    imageViewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    [self.navigationController pushViewController:imageViewController animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [_posts objectAtIndex:indexPath.row];
    if (!_offScreenCell)
    {
        _offScreenCell = (PostCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        // Dummy Data
        _offScreenCell.userName.text = @"offscreen name";
        _offScreenCell.postDate.text = @"7m";
        [_offScreenCell.userImage setImage:[UIImage imageNamed:@"default-avatar"]];
    }
    _offScreenCell.postText.text = post.postDescription;
    [_offScreenCell.postText setPreferredMaxLayoutWidth:self.view.bounds.size.width];
    [_offScreenCell.contentView setNeedsLayout];
    [_offScreenCell.contentView layoutIfNeeded];
    CGSize size = [_offScreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"general.messages", nil);
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor whiteColor];
}


#pragma mark - Helpers

#define SECONDS_IN_A_MINUTE 60
#define SECONDS_IN_A_HOUR  3600
#define SECONDS_IN_A_DAY 86400
#define SECONDS_IN_A_MONTH_OF_30_DAYS 2592000
#define SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS 31104000

- (NSString *)timeAgo:(NSDate *)date {
    NSTimeInterval distanceBetweenDates = [date timeIntervalSinceDate:[NSDate date]] * (-1);
    int distance = (int)floorf(distanceBetweenDates);
    if (distance <= 0) {
        return @"now";
    }
    else if (distance < SECONDS_IN_A_MINUTE) {
        return   [NSString stringWithFormat:@"%d%@", distance, NSLocalizedString(@"time.seconds" , nil)];
    }
    else if (distance < SECONDS_IN_A_HOUR) {
        distance = distance / SECONDS_IN_A_MINUTE;
        return   [NSString stringWithFormat:@"%d%@", distance, NSLocalizedString(@"time.minutes" , nil)];
    }
    else if (distance < SECONDS_IN_A_DAY) {
        distance = distance / SECONDS_IN_A_HOUR;
        return   [NSString stringWithFormat:@"%d%@", distance, NSLocalizedString(@"time.hours" , nil)];
    }
    else if (distance < SECONDS_IN_A_MONTH_OF_30_DAYS) {
        distance = distance / SECONDS_IN_A_DAY;
        return   [NSString stringWithFormat:@"%d%@", distance, NSLocalizedString(@"time.days" , nil)];
    }
    else if (distance < SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS) {
        distance = distance / SECONDS_IN_A_MONTH_OF_30_DAYS;
        return   [NSString stringWithFormat:@"%d%@", distance, NSLocalizedString(@"time.months" , nil)];
    } else {
        distance = distance / SECONDS_IN_A_YEAR_OF_MONTH_OF_30_DAYS;
        return   [NSString stringWithFormat:@"%d%@", distance, NSLocalizedString(@"time.years" , nil)];
    }
}

-(NSDate *)dateFromString:(NSString *)dateString
{
    // date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    // hot fix from date
    NSRange range = [dateString rangeOfString:@"."];
    if (range.location != NSNotFound){
        dateString = [dateString substringToIndex:range.location];
    }
    return [formatter dateFromString:dateString];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"action.refreshing", nil)];
    
    [self refreshPosts];
   
    [refresh endRefreshing];
}

-(void) refreshPosts {
    self.posts = [[NSMutableArray alloc] init];
    [self.posts addObjectsFromArray: [self loadPosts: 1]];
    [self.tableView reloadData];
    [self showIsEmpty];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    
    
    // Load next items
    int totalItems = ([self.criteria.page intValue]) * pageSize;
    for (NSIndexPath *indexPath in indexPaths){
         //NSLog(@"%@",[NSString stringWithFormat:@"indexPath: %d totalItems:%d",(int)indexPath.item, totalItems]);
        if (indexPath.item +1 == totalItems){
            
            self.criteria.page = [NSNumber numberWithInt:[self.criteria.page intValue] + 1];
            NSArray *newPosts = [self loadPosts: [self.criteria.page intValue]];
            [self.posts addObjectsFromArray : newPosts];
            [self.tableView reloadData];
        }
        
    }
    
}

@end
