//
//  YJPhotoCollectionViewCell.h
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import <UIKit/UIKit.h>
typedef void(^tapBlock)(void);
typedef void(^btnBlock)(BOOL isSelected);
@interface YJPhotoCollectionViewCell : UICollectionViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *backImageV;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *selectedBtn;
@property (nonatomic, copy)tapBlock  tapBlock;
@property (nonatomic, copy)btnBlock  btnBlock;

- (void)btnClick;
@end
