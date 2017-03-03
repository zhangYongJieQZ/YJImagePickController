//
//  YJReusableScrollView.h
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import <UIKit/UIKit.h>
typedef void(^tapBlock)(BOOL isShow);
typedef void(^pageBlock)(NSInteger  currentPage);

@interface YJReusableScrollView : UIScrollView
@property (nonatomic, assign)NSInteger  index;//作为图片数组的标记
@property (nonatomic, copy)tapBlock  tapBlock;
@property (nonatomic, copy)pageBlock  pageBlock;

- (instancetype)initWithFrame:(CGRect)frame imageAry:(NSArray *)imageAry currentIndex:(NSInteger)index;

@end
