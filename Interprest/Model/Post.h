//
//  AUPItem.h
//  Alleup
//
//  Created by Sergio Mallafré on 08/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Post : NSObject

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* postDescription;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSDate* createdAt;
@property (nonatomic, copy) NSDate* updatedAt;

@end
