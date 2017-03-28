//
//  NSObject+Description.m
//  YJImagePickDemo
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 张永杰. All rights reserved.
//

#import "NSObject+Description.h"

@implementation NSObject (Description)
- (NSString *)description{
    return NSStringFromClass([self class]);
}
@end
