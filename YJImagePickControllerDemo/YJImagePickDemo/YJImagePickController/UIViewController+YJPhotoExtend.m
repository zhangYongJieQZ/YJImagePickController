//
//  UIViewController+YJPhotoExtend.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import "UIViewController+YJPhotoExtend.h"
#import "YJPhotoShareManager.h"

@implementation UIViewController (YJPhotoExtend)
- (void)setTitleColor{
    if (self.navigationController) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:19],
           NSForegroundColorAttributeName:[YJPhotoShareManager shareInstance].textColor ? [YJPhotoShareManager shareInstance].textColor : [UIColor blackColor]}];//改变title的颜色
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];//改变返回按钮的颜色
    }
}

- (void)setNavgationBarColor{
    self.navigationController.navigationBar.barTintColor = [YJPhotoShareManager shareInstance].barColor ? [YJPhotoShareManager shareInstance].barColor : [UIColor whiteColor];//改变导航栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//设置电池栏颜色
}

- (void)leftButtonCustomerWith:(UIImage *)image andTitle:(NSString *)title{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize buttonSize = CGSizeMake(64, 44);
    if (image) {
        //        buttonSize = image.size;
        [rightButton setImage:image forState:UIControlStateNormal];
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    rightButton.frame = CGRectMake( 0, 0, buttonSize.width, buttonSize.height);
    if ((title.length > 0)) {
        [rightButton setTitle:title forState:UIControlStateNormal];
    }
    [rightButton setTitleColor:[YJPhotoShareManager shareInstance].textColor ? [YJPhotoShareManager shareInstance].textColor : [UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,rightBarButtonItem];
    
}

- (void)rightButtonCustomerWith:(UIImage *)image andTitle:(NSString *)title{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize buttonSize = CGSizeMake(44, 44);
    if (image) {
        buttonSize = image.size;
        [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    rightButton.frame = CGRectMake( 0, 0, buttonSize.width, buttonSize.height);
    if ((title.length > 0)) {
        [rightButton setTitle:title forState:UIControlStateNormal];
    }
    [rightButton setTitleColor:[YJPhotoShareManager shareInstance].textColor ? [YJPhotoShareManager shareInstance].textColor : [UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer,rightBarButtonItem];
    
}

- (void)rightButtonClick{
    
}

- (void)leftButtonClick{
    
}

@end
