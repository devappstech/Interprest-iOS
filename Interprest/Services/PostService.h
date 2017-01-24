//
//  AUPUserService.h
//  Alleup
//
//  Created by Sergio Mallafré on 07/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostCriteria.h"
#import "Post.h"

@interface PostService : NSObject

- (NSArray*) findAllByCriteria: (PostCriteria*) criteria;

@end
