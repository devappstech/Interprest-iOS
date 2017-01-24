//
//  AUPImage.m
//  Alleup
//
//  Created by Sergio Mallafré on 08/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import "Track.h"

@implementation Track

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.code = [decoder decodeObjectForKey:@"code"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.url = [decoder decodeObjectForKey:@"url"];
    self.stream = [decoder decodeObjectForKey:@"stream"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.stream forKey:@"stream"];
    
}

@end
