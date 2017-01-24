//
//  AUPUserService.m
//  Alleup
//
//  Created by Sergio Mallafré on 07/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import "PostService.h"
#import <RestKit/RestKit.h>
#import "Constants.h"
#import "ServicesUtils.h"

@implementation PostService


- (NSArray*) findAllByCriteria: (PostCriteria*) criteria{
    
    NSArray *result;
    if ([ServicesUtils checkNetwork]){
        
        RKObjectMapping* criteriaMapping = [ServicesUtils getPostCriteriaMapping];
        
        RKObjectMapping* postMapping = [ServicesUtils getPostMapping];
        
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[criteriaMapping inverseMapping] objectClass:[PostCriteria class] rootKeyPath: nil method:RKRequestMethodAny];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping method:RKRequestMethodAny pathPattern:nil keyPath: @"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/posts", publicServerUrl]]];
        
        [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
        
        [objectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
        [objectManager addRequestDescriptor:requestDescriptor];
        [objectManager addResponseDescriptor:responseDescriptor];
        
        RKObjectRequestOperation *operation = [objectManager appropriateObjectRequestOperationWithObject:criteria method:RKRequestMethodPOST path:@"" parameters:nil];
        
        [operation start];
        [operation waitUntilFinished];
        
        if (!operation.error) {
            result = [operation.mappingResult array];
        }

        
        
    }
    
    return result;
    
}

@end
