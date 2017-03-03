//
//  YJPhotoCollectionViewController.h
//  WXPhotoDemo
//
//  Created by 张永杰 on 2017/2/22.
//  Copyright © 2017年 张永杰. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^selectedBlock)(NSArray *selectedAry);

@interface YJPhotoCollectionViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title imageArray:(NSArray *)imageArray  data:(id)data selectedBlock:(selectedBlock)block;

@end
