//
//  NavigationExampleViewController.m
//  XLPagerTabStrip
//
//  Created by Martin Barreto on 12/20/14.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//
#import "XLPagerTabStripViewController.h"
#import "MainParentViewController.h"
#import "EventService.h"
#import "Globals.h"
#import "ServicesUtils.h"
#import "Track.h"
#import "MBProgressHUD.h"
#import "Constants.h"


@interface MainParentViewController () <UIAlertViewDelegate, UIPopoverControllerDelegate>{

    
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) Event* currentEvent;

@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation MainParentViewController

@synthesize appSettingsViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController){
        UIImage* logoImage = [UIImage imageNamed:@"logo_top.png"];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    }
    
    [self findCurrentEvent];
    
    // New and initialize FFAVPlayerController instance to prepare for playback
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}

- (void) findCurrentEvent {
    EventService *eventService = [[Globals sharedInstance] eventService];
    Info *info = [eventService findInfo];
    self.currentEvent = [eventService findCurrent];
    [[Globals sharedInstance] setCurrentEvent: self.currentEvent];
    if (info == nil){
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.wifi", nil)
                                   message:nil
                                  delegate:self
                         cancelButtonTitle:NSLocalizedString(@"action.ok", nil)
                         otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
       
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"joer como mola : %ld", (long)buttonIndex);
    if (alertView.tag == 1){
        exit(0);
    }
   
}

- (IASKAppSettingsViewController*)appSettingsViewController {
    if (!appSettingsViewController) {
        appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
        appSettingsViewController.delegate = self;
        BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
        appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil];
    }
    return appSettingsViewController;
}

- (IBAction)onClickSettingsButton:(id)sender {
    
    self.appSettingsViewController.showDoneButton = NO;
    self.appSettingsViewController.navigationItem.rightBarButtonItem = nil;
    [self.navigationController pushViewController:self.appSettingsViewController animated:YES];
}

- (IBAction)reloadTapped:(id)sender {
    [self findCurrentEvent];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    
}
- (IBAction)onClickPlayButton:(id)sender {
    
    if (self.currentLanguage == nil){
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.select_language", nil)
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"action.ok", nil)
                         otherButtonTitles:nil];
        [alertView show];
        
    }
    else{
        if (self.isPlaying){
            [self stopPlaying];
        }
        else{
            [self initAVPlayController];
        }
        
    }
}

- (void) stopPlaying{
    self.isPlaying = NO;
    UIImage *btnImage = [UIImage imageNamed:@"play.png"];
    [self.playButton setImage:btnImage forState:UIControlStateNormal];
    
    [[[Globals sharedInstance] eventService] stopAudio];
    
    [self.player shutdown];

}



- (void) changeLanguage: (NSString*) language {
    self.currentLanguage = language;
    
    if ([self isPlaying]){
        [self stopPlaying];
        [self initAVPlayController];
        
    }
}

- (void) initAVPlayController {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = NSLocalizedString(@"action.initializing", nil);
    
    
    
    NSString *url = nil;
    for (Track *track in self.currentEvent.languages){
        if ([track.code isEqualToString:self.currentLanguage]){
            url = track.stream;
            break;
        }
    }
    NSLog(@"%@", publicServerUrl);
    if ([mockStreamUrl length] != 0){
        url = mockStreamUrl;
    }
    NSLog(@"%@", url);
    [[[Globals sharedInstance] eventService] startAudio: self.currentLanguage];
   
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector: @selector(startAudio:)
                                   userInfo:url
                                    repeats:NO];
   
    

   
    
}
- (void) startAudio: (NSTimer*)theTimer{
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[theTimer userInfo]] withOptions:options];
    
    
    [self installMovieNotificationObservers];
    
    [self.player prepareToPlay];
    
}


- (void) alert: (NSString*) message{
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:message
                               message:nil
                              delegate:self
                     cancelButtonTitle:@"Close"
                     otherButtonTitles:nil];
    [alertView show];
}



#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // your code here to reconfigure the app for changed settings
}

// optional delegate method for handling mail sending result
- (void)settingsViewController:(id<IASKViewController>)settingsViewController mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if ( error != nil ) {
        // handle error here
    }
    
    if ( result == MFMailComposeResultSent ) {
        // your code here to handle this result
    }
    else if ( result == MFMailComposeResultCancelled ) {
        // ...
    }
    else if ( result == MFMailComposeResultSaved ) {
        // ...
    }
    else if ( result == MFMailComposeResultFailed ) {
        // ...
    }
}

-(NSString *)stringFromBool:(BOOL)value
{
    return value ? @"YES" : @"NO";
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    [self.hud hide:YES];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            [self stopPlaying];
            [self alert: NSLocalizedString(@"error", nil)];
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
    [self.player play];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    [self.hud hide:YES];
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            self.isPlaying = YES;
            UIImage *btnImage = [UIImage imageNamed:@"pause.png"];
            [self.playButton setImage:btnImage forState:UIControlStateNormal];
            self.isPlaying = YES;
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            [self stopPlaying];
            [self alert: NSLocalizedString(@"error", nil)];
            break;
        }
    }
}


/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

@end