//
//  YJPhotoShareManager.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import "YJPhotoShareManager.h"
static YJPhotoShareManager *manager = nil;
@implementation YJPhotoShareManager

+ (YJPhotoShareManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[YJPhotoShareManager alloc] init];
            manager.textColor = [UIColor blackColor];
            manager.barColor = [UIColor whiteColor];
        }
    });
    return  manager;
}

@end
