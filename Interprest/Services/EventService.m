//
//  AUPUserService.m
//  Alleup
//
//  Created by Sergio Mallafré on 07/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import "EventService.h"
#import <RestKit/RestKit.h>
#import "Constants.h"
#import "ServicesUtils.h"
#import "Globals.h"

@implementation EventService



- (Info*) findInfo{
    Info *result = nil;
    if ([ServicesUtils checkNetwork]){
        RKObjectMapping* mapping = [ServicesUtils getInfoMapping];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        
        NSURL *URL = [NSURL URLWithString: [NSString stringWithFormat:@"%@/api/v1/info", publicServerUrl]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request addValue:@"application/json" forHTTPHeaderField:  @"Accept"];
        RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
        
        
        [objectRequestOperation start];
        [objectRequestOperation waitUntilFinished];
        
        if (!objectRequestOperation.error) {
            NSArray *userResults = [objectRequestOperation.mappingResult array];
            if ([userResults count]>0){
                result = [[objectRequestOperation.mappingResult array] objectAtIndex: 0];
            }
        }
    }
    return result;
}

- (Event*) findCurrent{
    Event *result = nil;
    if ([ServicesUtils checkNetwork]){
        
        RKObjectMapping* mapping = [ServicesUtils getEventMapping];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        
        NSURL *URL = [NSURL URLWithString: [NSString stringWithFormat:@"%@/api/v1/events/current", publicServerUrl]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request addValue:@"application/json" forHTTPHeaderField:  @"Accept"];
        RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
        
        
        [objectRequestOperation start];
        [objectRequestOperation waitUntilFinished];
        
        if (!objectRequestOperation.error) {
            NSArray *userResults = [objectRequestOperation.mappingResult array];
            if ([userResults count]>0){
                result = [[objectRequestOperation.mappingResult array] objectAtIndex: 0];
            }
        }
    }
    return result;
}

- (void) startAudio: (NSString*) language{
    
    if ([ServicesUtils checkNetwork]){
        
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/api/v1/play/%@", publicServerUrl, language]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        RKObjectMapping * emptyMapping = [RKObjectMapping mappingForClass:[NSObject class]];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:emptyMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
        
        [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            ;
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            RKLogError(@"Operation failed with error: %@", error);
        }];
        
        [objectRequestOperation start];
    }
     
}

- (void) stopAudio {
   
    if ([ServicesUtils checkNetwork]){
     NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/api/v1/stop", publicServerUrl]];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     
     RKObjectMapping * emptyMapping = [RKObjectMapping mappingForClass:[NSObject class]];
     RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:emptyMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
     
     RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
     
     [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     ;
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
     RKLogError(@"Operation failed with error: %@", error);
     }];
     
     [objectRequestOperation start];
     
    }

}


@end
