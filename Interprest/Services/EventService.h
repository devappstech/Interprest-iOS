//
//  AUPUserService.h
//  Alleup
//
//  Created by Sergio Mallafré on 07/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Info.h"


@interface EventService : NSObject

- (Info*) findInfo;

- (Event*) findCurrent;

- (void) startAudio: (NSString*) language;

- (void) stopAudio;

@end
