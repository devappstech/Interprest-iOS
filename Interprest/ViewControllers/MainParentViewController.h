//
//  NavigationExampleViewController.h
//  XLPagerTabStrip
//
//  Created by Martin Barreto on 12/20/14.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface MainParentViewController : UIViewController <IASKSettingsDelegate>{
    IASKAppSettingsViewController *appSettingsViewController;
}

@property(atomic, retain) id<IJKMediaPlayback> player;
@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;
@property (nonatomic, assign) NSString* currentLanguage;
- (void) changeLanguage: (NSString*) language;


@end
