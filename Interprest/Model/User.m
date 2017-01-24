//
//  AUPItem.m
//  Alleup
//
//  Created by Sergio Mallafré on 08/08/14.
//  Copyright (c) 2014 Alleup. All rights reserved.
//

#import "User.h"

@implementation User

- (bool) isAdmin{
    return self != nil && self.isAdmin;
}

- (bool) isTranslator{
    return self != nil && self.isTranslator;
}



@end
