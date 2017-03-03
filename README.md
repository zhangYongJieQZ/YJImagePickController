# YJImagePickController
类微信图片选择只需要添加如下代码即可：

    [YJPhotoShareManager shareInstance].textColor = [UIColor whiteColor];//设置字体颜色
    [YJPhotoShareManager shareInstance].barColor = [UIColor blackColor];//设置导航栏颜色
    
    YJImagePickViewController *imagePickVC = [[YJImagePickViewController alloc] initWithMaxSelected:5 selectedImageBlock:^(NSArray<UIImage *> *imageArray) {
        
    }];//最大选择数，返回的图片数组
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePickVC];
    [self presentViewController:nav animated:YES completion:nil];
