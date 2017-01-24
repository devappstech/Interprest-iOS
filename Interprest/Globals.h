//
//  AUPGlobals.h
//  Alleup
//
//  Created by Sergio Mallafré on 07/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventService.h"
#import "PostService.h"

@interface Globals : NSObject{

    EventService *eventService;
    PostService *postService;
    Event *currentEvent;
    UIColor *primaryColor;
    
}

@property (nonatomic, retain) EventService *eventService;
@property (nonatomic, retain) PostService *postService;
@property (nonatomic, retain) Event *currentEvent;
@property (nonatomic, retain) UIColor *primaryColor;




+ (id)sharedInstance;

@end
