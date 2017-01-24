//
//  ChildExampleViewController.m
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

#import "ConferenceViewController.h"
#import "Event.h"
#import "Globals.h"
#import "Track.h"
#import "MainParentViewController.h"

@interface ConferenceViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) Event *currentEvent;
@property (nonatomic) UIColor *primaryColor;
@property (nonatomic) MainParentViewController* parentController;

@end


@implementation ConferenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.parentController = (MainParentViewController*)self.parentViewController.parentViewController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
   
}

-(void)refresh:(NSNotification *) notification{
    [self viewWillAppear: true];
}

- (void) viewWillAppear:(BOOL)animated{
    
    self.currentEvent = [[Globals sharedInstance] currentEvent];
    self.primaryColor = [[Globals sharedInstance] primaryColor];
    
    [self loadButtons];
    
}

- (void) loadButtons{
    [[self.contentView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int x = -50;
    int y = 100;
    self.buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.currentEvent.languages count]; i++){
        Track *track = [self.currentEvent.languages objectAtIndex:i];
    
        [self.buttons addObject:[self createButton: track.code x: x y: y position: i]];
        
        x = x == 50? -50 : 50;
        y = i % 2 == 0 ? y : y + 100;
    }

    
}

- (UIButton*) createButton : (NSString *) text x:(int )x y:(int) y position:(int) position{
    
    UIButton * button = [[UIButton alloc] init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitle: [text uppercaseString] forState:UIControlStateNormal];
    
    
    button.layer.borderColor = self.primaryColor.CGColor;
    [button setTitleColor:self.primaryColor forState:UIControlStateNormal];
    
   
    
    button.layer.borderWidth = 2.0;
    button.titleLabel.font = [UIFont systemFontOfSize:26];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(onClickLanguageButton:)
       forControlEvents:UIControlEventTouchUpInside];
    button.tag = position;
   
    if ([self.parentController.currentLanguage isEqualToString: text]){
        button.backgroundColor = self.primaryColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [self.contentView addSubview:button];
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:button
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:80]];
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:button
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                     constant:80]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant: y]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:x]];
    return button;
}

- (void) onClickLanguageButton :(UIButton*)sender{
    
    for (UIButton *button in self.buttons){
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    sender.backgroundColor = self.primaryColor;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    Track *track = [self.currentEvent.languages objectAtIndex:sender.tag];
    [self.parentController changeLanguage: track.code];
    

}




#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"general.home", nil);
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor whiteColor];
}

@end
