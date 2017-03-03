# YJImagePickController
类微信图片选择只需要添加如下代码即可：
[YJPhotoShareManager shareInstance].textColor = [UIColor whiteColor];
    [YJPhotoShareManager shareInstance].barColor = [UIColor blackColor];
    YJImagePickViewController *imagePickVC = [[YJImagePickViewController alloc] initWithMaxSelected:5 selectedImageBlock:^(NSArray *imageArray) {
        
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePickVC];
    [self presentViewController:nav animated:YES completion:nil];
