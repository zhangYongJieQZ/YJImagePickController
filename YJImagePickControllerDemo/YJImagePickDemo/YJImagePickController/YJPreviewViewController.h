//
//  YJPreviewViewController.h
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import <UIKit/UIKit.h>
typedef void(^chooseBlock)(NSInteger index,BOOL isSelected);
typedef void(^doneBlock)(void);
@interface YJPreviewViewController : UIViewController
@property (nonatomic, copy)chooseBlock  chooseBlock;
@property (nonatomic, copy)doneBlock  doneBlock;

//isSelected 看是否为整个查看还是选中查看
- (instancetype)initWithImageArray:(NSArray *)imageArray atIndex:(NSInteger)index isSelected:(BOOL)isSelected;
@end
