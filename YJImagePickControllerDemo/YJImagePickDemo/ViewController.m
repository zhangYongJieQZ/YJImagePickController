//
//  ViewController.m
//  YJImagePickDemo
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 张永杰. All rights reserved.
//

#import "ViewController.h"
#import "YJImagePickViewController.h"
#import "YJPhotoShareManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)imagePickAction:(id)sender {
    [YJPhotoShareManager shareInstance].textColor = [UIColor whiteColor];
    [YJPhotoShareManager shareInstance].barColor = [UIColor blackColor];
    YJImagePickViewController *imagePickVC = [[YJImagePickViewController alloc] initWithMaxSelected:5 selectedImageBlock:^(NSArray<UIImage *> *imageArray) {
        
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePickVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
