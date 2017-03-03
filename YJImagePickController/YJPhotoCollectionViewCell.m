//
//  YJPhotoCollectionViewCell.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import "YJPhotoCollectionViewCell.h"
#import "YJPhotoShareManager.h"
@implementation YJPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_selectedBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)btnClick{
    if (self.selected == NO) {
        if ([YJPhotoShareManager shareInstance].maxCount == [YJPhotoShareManager shareInstance].selectedCount) {
            NSString * title = [NSString stringWithFormat:@"您最多只能选择%ld张图片",(long)[YJPhotoShareManager shareInstance].maxCount];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if ([YJPhotoShareManager shareInstance].animation == nil) {
            [YJPhotoShareManager shareInstance].animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            //    CAKeyframeAnimation(keyPath: "transform.scale");
            [YJPhotoShareManager shareInstance].animation.duration = 0.15;
            [YJPhotoShareManager shareInstance].animation.autoreverses = false;
            [YJPhotoShareManager shareInstance].animation.values = @[@1.0,@1.2,@1.0];
            [YJPhotoShareManager shareInstance].animation.fillMode = kCAFillModeBackwards;
        }
        
        self.selected = YES;
        __weak __typeof(&*self)weakSelf = self;
        if (_btnBlock) {
            _btnBlock(weakSelf.selected);
        }
        [_selectedBtn setImage:[UIImage imageNamed:@"yj_selected"] forState:UIControlStateNormal];
        [_selectedBtn.layer removeAnimationForKey:@"transform.scale"];
        [_selectedBtn.layer addAnimation:[YJPhotoShareManager shareInstance].animation forKey:@"transform.scale"];
    }
    else if (self.selected == YES) {
        __weak __typeof(&*self)weakSelf = self;
        self.selected = NO;
        if (_btnBlock) {
            _btnBlock(weakSelf.selected);
        }
        [_selectedBtn setImage:[UIImage imageNamed:@"yj_noSelected"] forState:UIControlStateNormal];
    }
}

@end
