//
//  YJImageScrollView.h
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import <UIKit/UIKit.h>

@interface YJImageScrollView : UIScrollView
@property (nonatomic, strong)UIImageView  *imageV;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (void)resetImage:(UIImage *)image;
@end
