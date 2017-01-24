//
//  AUPItem.h
//  Alleup
//
//  Created by Sergio Mallafré on 08/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Event : NSObject

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* eventDescription;
@property (nonatomic, copy) NSMutableArray* languages;

@end
