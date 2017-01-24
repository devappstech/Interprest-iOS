//
//  AUPItem.m
//  Alleup
//
//  Created by Sergio Mallafré on 08/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import "Info.h"

@implementation Info

- (bool) isPrivate{
    return self != nil && self.api!= nil && [self.api isEqualToString:@"private"];
}

@end
