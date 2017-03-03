//
//  YJImagePickViewController.h
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import <UIKit/UIKit.h>
typedef void(^selectedBlock)(NSArray *imageArray);

@interface YJImagePickViewController : UIViewController

- (instancetype)initWithMaxSelected:(NSInteger)maxSelected selectedImageBlock:(selectedBlock)block;

@end
