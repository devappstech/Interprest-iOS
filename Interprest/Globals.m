//
//  AUPGlobals.m
//  Alleup
//
//  Created by Sergio Mallafré on 07/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import "Globals.h"

@implementation Globals

@synthesize eventService;
@synthesize postService;
@synthesize currentEvent;
@synthesize primaryColor;


+ (id)sharedInstance {
    static Globals *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        eventService = [[EventService alloc] init];
        postService = [[PostService alloc] init];
        primaryColor = [UIColor colorWithRed:54/255.0 green:169/255.0 blue:225/255.0 alpha:1.0];
    
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
