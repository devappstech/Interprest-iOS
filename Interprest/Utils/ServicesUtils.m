//
//  AUPServicesUtils.m
//  Alleup
//
//  Created by Sergio Mallafré on 12/09/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

@import SystemConfiguration.CaptiveNetwork;
#import "ServicesUtils.h"
#import "Info.h"
#import "Event.h"
#import "Track.h"
#import "Post.h"
#import "PostCriteria.h"

#import "Reachability.h"



@implementation ServicesUtils

+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}


+ (BOOL) checkNetwork{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        return NO;
    }
    else{
        return YES;
    }
}


+ (void) millisecondsSince1970ToDateValueTransformer
{
    RKValueTransformer* transformer = [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class sourceClass, __unsafe_unretained Class destinationClass) {
        return [sourceClass isSubclassOfClass:[NSNumber class]] && [destinationClass isSubclassOfClass:[NSDate class]];
    } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputValueClass, NSError *__autoreleasing *error) {
        RKValueTransformerTestInputValueIsKindOfClass(inputValue, (@[ [NSNumber class] ]), error);
        RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, (@[ [NSDate class] ]), error);
        NSTimeInterval seconds = [inputValue doubleValue] / 1000;
        *outputValue = [NSDate dateWithTimeIntervalSince1970:seconds];
        return YES;
    }];
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:transformer atIndex:0];

}

+ (RKObjectMapping*) getInfoMapping{
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Info class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"api": @"api"
                                                  }];
    return mapping;
}

+ (RKObjectMapping*) getEventMapping{
    
    [ServicesUtils millisecondsSince1970ToDateValueTransformer];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Event class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"description": @"eventDescription"
                                                          }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"languages"
                                                                                toKeyPath:@"languages"
                                                                              withMapping:[ServicesUtils getTrackMapping]]];
    return mapping;
}

+ (RKObjectMapping*) getTrackMapping{
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Track class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"code": @"code",
                                                  @"name": @"name",
                                                  @"url": @"url",
                                                  @"stream": @"stream"
                                                  }];
    return mapping;
}

+ (RKObjectMapping*) getPostMapping{
    
    [ServicesUtils millisecondsSince1970ToDateValueTransformer];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Post class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id": @"id",
                                                  @"title": @"title",
                                                  @"description": @"postDescription",
                                                  @"image": @"image",
                                                  @"status": @"status",
                                                  @"createdAt": @"createdAt",
                                                  @"updatedAt": @"updatedAt"
                                                  }];
    return mapping;
}

+ (RKObjectMapping*) getPostCriteriaMapping{
   
    [ServicesUtils millisecondsSince1970ToDateValueTransformer];
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PostCriteria class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"statuses": @"statuses",
                                                  @"language": @"language",
                                                  @"page": @"page",
                                                  @"size": @"size"
                                                  }];
    return mapping;
}


@end
