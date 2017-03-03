//
//  YJPhotoShareManager.h
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YJPhotoShareManager : NSObject
@property (nonatomic, strong)CAKeyframeAnimation * animation;
@property (nonatomic, strong)UIColor  *textColor;
@property (nonatomic, strong)UIColor  *barColor;
@property (nonatomic, strong)NSArray  *thumbnailArray;
@property (nonatomic, strong)NSArray  *imageArray;
@property (nonatomic, assign)NSInteger  maxCount;
@property (nonatomic, assign)NSInteger  selectedCount;
@property (nonatomic, strong)NSMutableArray  *allSelectedArray;//所有照片的选中状态
@property (nonatomic, strong)NSMutableArray  *currentSelectedArray;//如果当前有选中的照片，保存其状态


+ (YJPhotoShareManager *)shareInstance;
@end
