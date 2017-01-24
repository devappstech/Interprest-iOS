//
//  AUPServicesUtils.h
//  Alleup
//
//  Created by Sergio Mallafré on 12/09/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ServicesUtils : NSObject

+ (id)fetchSSIDInfo;

+ (BOOL) checkNetwork;

+ (void)millisecondsSince1970ToDateValueTransformer;

+ (RKObjectMapping*) getInfoMapping;

+ (RKObjectMapping*) getEventMapping;

+ (RKObjectMapping*) getPostMapping;

+ (RKObjectMapping*) getPostCriteriaMapping;

@end
