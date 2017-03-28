//
//  PhotoCollectionViewCell.m
//  WXPhotoDemo
//
//  Created by 张永杰 on 2017/2/23.
//  Copyright © 2017年 张永杰. All rights reserved.
//

#import "YJPreviewViewController.h"
#import "UIView+YJFrameExtend.h"
#import "YJReusableScrollView.h"
#import "YJPhotoShareManager.h"
@interface YJPreviewViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong)NSArray  *imageArray;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *headView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *footerView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *selectedBtn;

@property (nonatomic, assign)NSInteger  index;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *containView;

@property (nonatomic, strong)YJReusableScrollView  *mainScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *editBtn;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, assign)BOOL  isSelected;

@end

@implementation YJPreviewViewController

- (instancetype)initWithImageArray:(NSArray *)imageArray atIndex:(NSInteger)index isSelected:(BOOL)isSelected{
    if (self = [super init]) {
        _imageArray = imageArray;
        _index = index;
        _isSelected = isSelected;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    // Do any additional setup after loading the view from its nib.
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
}

- (void)initSubviews{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    _mainScrollView = [[YJReusableScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) imageAry:self.imageArray currentIndex:_index];
    __weak __typeof(&*self)weakSelf = self;
    _mainScrollView.tapBlock = ^(BOOL hidden){
        [weakSelf isHidden:hidden];
    };
    _mainScrollView.pageBlock = ^(NSInteger  currentPage){
        weakSelf.index = currentPage;
        BOOL selectedStatus;
        if (weakSelf.isSelected) {
            NSNumber *currentNumber = [YJPhotoShareManager shareInstance].currentSelectedArray[weakSelf.index];
            NSNumber *number = [YJPhotoShareManager shareInstance].allSelectedArray[[currentNumber integerValue]];
            selectedStatus = [number boolValue];
        }else{
            NSNumber *number = [YJPhotoShareManager shareInstance].allSelectedArray[weakSelf.index];
            selectedStatus = [number boolValue];
        }
        
        if (selectedStatus) {
            [weakSelf.selectedBtn setImage:[UIImage imageNamed:@"yj_selected"] forState:UIControlStateNormal];
        }else{
            [weakSelf.selectedBtn setImage:[UIImage imageNamed:@"yj_noSelected"] forState:UIControlStateNormal];
        }
    };
    _mainScrollView.pageBlock(_index);
    [self.containView addSubview:_mainScrollView];
    _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)[YJPhotoShareManager shareInstance].selectedCount];
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.layer.cornerRadius = 10.0;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)isHidden:(BOOL)hidden{
    _headView.hidden = hidden;
    _footerView.hidden = hidden;
}

- (IBAction)editAction:(id)sender {
    
}

- (IBAction)doneAction:(id)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

- (IBAction)selectedAction:(id)sender {
    BOOL selectedStatus;
    NSInteger currentIndex = 0;
    if (self.isSelected) {
        NSNumber *currentNumber = [YJPhotoShareManager shareInstance].currentSelectedArray[_index];
        currentIndex = [currentNumber integerValue];
        NSNumber *number = [YJPhotoShareManager shareInstance].allSelectedArray[currentIndex];
        selectedStatus = [number boolValue];
        
    }else{
        NSNumber *number = [YJPhotoShareManager shareInstance].allSelectedArray[_index];
        currentIndex = _index;
        selectedStatus = [number boolValue];
        
    }
    //判断是否可点击
    if (([YJPhotoShareManager shareInstance].maxCount == [YJPhotoShareManager shareInstance].selectedCount) && selectedStatus == NO) {
        NSString * title = [NSString stringWithFormat:@"您最多只能选择%ld张图片",(long)[YJPhotoShareManager shareInstance].maxCount];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    selectedStatus = !selectedStatus;
    if (selectedStatus) {
        _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)[YJPhotoShareManager shareInstance].selectedCount + 1];
    }else{
        _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)[YJPhotoShareManager shareInstance].selectedCount - 1];
    }
    [_numberLabel.layer addAnimation:[YJPhotoShareManager shareInstance].animation forKey:@"transform.scale"];
    [[YJPhotoShareManager shareInstance].allSelectedArray replaceObjectAtIndex:currentIndex withObject:@(selectedStatus)];
    if (selectedStatus) {
        [_selectedBtn setImage:[UIImage imageNamed:@"yj_selected"] forState:UIControlStateNormal];
        [_selectedBtn.layer removeAnimationForKey:@"transform.scale"];
        [_selectedBtn.layer addAnimation:[YJPhotoShareManager shareInstance].animation forKey:@"transform.scale"];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"yj_noSelected"] forState:UIControlStateNormal];
    }
    if (self.chooseBlock) {
        self.chooseBlock(currentIndex,selectedStatus);
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
