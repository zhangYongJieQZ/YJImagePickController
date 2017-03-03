//
//  YJImageScrollView.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import "YJImageScrollView.h"
#import "UIView+YJFrameExtend.h"
@interface YJImageScrollView ()<UIScrollViewDelegate>

@end
@implementation YJImageScrollView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    if (self = [super initWithFrame:frame]) {
        CGSize newSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, image.size.height *([UIScreen mainScreen].bounds.size.width - 10) /image.size.width);
        _imageV = [[UIImageView alloc] init];
        _imageV.frame = CGRectMake(5, ([UIScreen mainScreen].bounds.size.height - newSize.height)/2.0, newSize.width, newSize.height);
        _imageV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
        _imageV.image = image;
        _imageV.userInteractionEnabled = YES;
        [self addSubview:_imageV];
        self.delegate = self;
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 0.5;
    }
    return self;
}

- (void)resetImage:(UIImage *)image{
    CGSize newSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, image.size.height *([UIScreen mainScreen].bounds.size.width - 10) /image.size.width);
    _imageV.frame = CGRectMake(5, ([UIScreen mainScreen].bounds.size.height - newSize.height)/2.0, newSize.width, newSize.height);
    _imageV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
    _imageV.image = image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //判断2种情况，放大的时候需要改变位置，否则会偏移中心点
    CGFloat cWidth = scrollView.contentSize.width;
    CGFloat cHeight = scrollView.contentSize.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    _imageV.center = CGPointMake((cWidth > screenWidth) ? cWidth / 2.0 : screenWidth / 2.0, (cHeight > screenHeight) ? cHeight /2.0 : screenHeight / 2.0);
}


@end
