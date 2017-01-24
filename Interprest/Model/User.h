//
//  AUPItem.h
//  Alleup
//
//  Created by Sergio Mallafré on 08/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Language.h"

@interface User : NSObject

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* role;
@property (nonatomic, assign) bool isAdmin;
@property (nonatomic, assign) bool isTranslator;

@property (nonatomic, strong) Language* translationLanguage;

- (bool) isAdmin;
- (bool) isTranslator;

@end
