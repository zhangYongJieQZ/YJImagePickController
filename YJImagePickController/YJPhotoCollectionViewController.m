//
//  YJPhotoCollectionViewController.m
//  WXPhotoDemo
//
//  Created by 张永杰 on 2017/2/22.
//  Copyright © 2017年 张永杰. All rights reserved.
//

#import "YJPhotoCollectionViewController.h"
#import "YJPhotoCollectionViewCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YJPhotoShareManager.h"
#import "UIView+YJFrameExtend.h"
#import "YJPreviewViewController.h"
#import "UIViewController+YJPhotoExtend.h"
static NSString *cellID = @"CollectionCell";

//layer颜色用来调试视图
#define redLayer(view) view.layer.borderWidth = 1.0;view.layer.borderColor = [UIColor redColor].CGColor;
#define blueLayer(view) view.layer.borderWidth = 1.0;view.layer.borderColor = [UIColor blueColor].CGColor;
#define blackLayer(view) view.layer.borderWidth = 1.0;view.layer.borderColor = [UIColor blackColor].CGColor;

#define iOS8 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
#define backQueue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

@interface YJPhotoCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSArray  *imageAry;
@property (nonatomic, strong)UICollectionView  *collectionView;
@property (nonatomic, copy)selectedBlock  myBlock;
@property (nonatomic, strong)ALAssetsGroup  *assetsGroup;
@property (nonatomic, strong)PHAssetCollection  *assetsCollection;
@property (nonatomic, strong)NSMutableArray  *originalImageAry;
@property (nonatomic, assign)BOOL  hasBeyond; //超出选图范围，collection边半透明
@property (nonatomic, strong)UIView  *footerBar;
@property (nonatomic, strong)UIButton  *editBtn;
@property (nonatomic, strong)UIButton  *previewBtn;
@property (nonatomic, strong)UIButton  *doneBtn;
@property (nonatomic, strong)UILabel   *numberLabel;

@end

@implementation YJPhotoCollectionViewController

- (instancetype)initWithTitle:(NSString *)title imageArray:(NSArray *)imageArray  data:(id)data selectedBlock:(selectedBlock)block{
    if (self = [super init]) {
        self.title = title;
        _myBlock = block;
        _imageAry = imageArray;
        if (iOS8) {
            _assetsCollection = data;
        }else{
            _assetsGroup = data;
        }
        [YJPhotoShareManager shareInstance].allSelectedArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < imageArray.count; i++) {
            [[YJPhotoShareManager shareInstance].allSelectedArray addObject:@(NO)];
        }
        
        _originalImageAry = [[NSMutableArray alloc] init];
        _hasBeyond = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    backQueue(^{
        [self downloadStart];
    });
    // Do any additional setup after loading the view.
}

- (void)rightButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews{
    [self rightButtonCustomerWith:nil andTitle:@"取消"];
    [self leftButtonCustomerWith:[UIImage imageNamed:@"yj_leftArrow"] andTitle:@"返回"];
    //    [self setTitleColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout * pickImageCollectionLayout =  [UICollectionViewFlowLayout new];
    pickImageCollectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    pickImageCollectionLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 2*5)/4 , ([UIScreen mainScreen].bounds.size.width - 2*5)/4);
    pickImageCollectionLayout.minimumInteritemSpacing = 2;// 设置垂直间距
    pickImageCollectionLayout.minimumLineSpacing = 2;// 设置最小行间距
    pickImageCollectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;    // 设置滚动方向（默认垂直滚动）
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44) collectionViewLayout:pickImageCollectionLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;//滑动
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YJPhotoCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    
    [self createFooterBar];
}

- (void)createFooterBar{
    //创建底部
    _footerBar = [[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.bottom, _collectionView.width, 44)];
    _footerBar.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_footerBar];
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, _footerBar.height)];
    _editBtn.alpha = 0.5;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [_footerBar addSubview:_editBtn];
    _editBtn.hidden = YES;
    _previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(_editBtn.right, 0, 40, _footerBar.height)];
    [_previewBtn addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
    _previewBtn.alpha = 0.5;
    [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    _previewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_footerBar addSubview:_previewBtn];
    
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.right - 50, 0, 50, _footerBar.height)];
    _doneBtn.alpha = 0.5;
    [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_footerBar addSubview:_doneBtn];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_doneBtn.left - 30, 12, 20, 20)];
    _numberLabel.text = @"0";
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.layer.cornerRadius = 20/2.0;
    _numberLabel.backgroundColor = [UIColor greenColor];
    _numberLabel.textColor = [UIColor whiteColor];
    [_footerBar addSubview:_numberLabel];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageAry.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"CELLID%ld",(long)indexPath.row];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YJPhotoCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    YJPhotoCollectionViewCell *cell = (YJPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.backImageV.image = self.imageAry[indexPath.row];
    cell.selected = [[YJPhotoShareManager shareInstance].allSelectedArray[indexPath.row] boolValue];
    cell.tag = indexPath.row;
    cell.tapBlock = ^(void){
        [self seeOriginImageInIndex:indexPath.row];
    };
    cell.btnBlock = ^(BOOL hasSelected){
        [self replacSelectedAryAtIndex:indexPath.row withBoolValue:hasSelected];
    };
    
    if (_hasBeyond) {
        if(cell.selected){
            cell.alpha = 1;
        }else{
            cell.alpha = 0.5;
        }
    }else{
        cell.alpha = 1;
    }
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (void)seeOriginImageInIndex:(NSInteger)index{
    YJPreviewViewController *previewVC = [[YJPreviewViewController alloc] initWithImageArray:self.originalImageAry atIndex:index isSelected:NO];
    previewVC.chooseBlock = ^(NSInteger index,BOOL isSelected){
        for (YJPhotoCollectionViewCell *cell in self.collectionView.visibleCells) {
            if (cell.tag == index) {
                [cell btnClick];
                
            }
        }
    };
    previewVC.doneBlock = ^(void){
        [self doneAction];
    };
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)replacSelectedAryAtIndex:(NSInteger)index withBoolValue:(BOOL)isSelected{
    [[YJPhotoShareManager shareInstance].allSelectedArray replaceObjectAtIndex:index withObject:@(isSelected)];
    int i = 0;
    for (NSNumber *boolValue in [YJPhotoShareManager shareInstance].allSelectedArray) {
        if ([boolValue boolValue]) {
            i++;
        }
    }
    _numberLabel.text = [NSString stringWithFormat:@"%d",i];
    [_numberLabel.layer addAnimation:[YJPhotoShareManager shareInstance].animation forKey:@"transform.scale"];
    if (i == 0) {
        _editBtn.userInteractionEnabled = NO;
        _editBtn.alpha = 0.5;
        _previewBtn.userInteractionEnabled = NO;
        _previewBtn.alpha = 0.5;
        _doneBtn.userInteractionEnabled = NO;
        _doneBtn.alpha = 0.5;
        
    }else{
        if(i == 1){
            _editBtn.userInteractionEnabled = YES;
            _editBtn.alpha = 1;
        }else{
            _editBtn.userInteractionEnabled = NO;
            _editBtn.alpha = 0.5;
        }
        _previewBtn.userInteractionEnabled = YES;
        _previewBtn.alpha = 1;
        _doneBtn.userInteractionEnabled = YES;
        _doneBtn.alpha = 1;
    }
    
    [YJPhotoShareManager shareInstance].selectedCount = i;
    if (i == [YJPhotoShareManager shareInstance].maxCount) {
        _hasBeyond = YES;
        NSArray *itemAry = self.collectionView.visibleCells;
        for (int i = 0; i < itemAry.count; i++) {
            YJPhotoCollectionViewCell *cell = itemAry[i];
            if (!cell.selected) {
                cell.alpha = 0.5;
            }else{
                cell.alpha = 1;
            }
        }
    }else{
        _hasBeyond = NO;
        NSArray *itemAry = self.collectionView.visibleCells;
        for (int i = 0; i < itemAry.count; i++) {
            YJPhotoCollectionViewCell *cell = itemAry[i];
            cell.alpha = 1;
        }
    }
}

- (void)downloadStart{
    __weak __typeof(&*self)weakSelf = self;
    if (iOS8) {
        PHFetchResult *subResult = [PHAsset fetchAssetsInAssetCollection:_assetsCollection options:nil];
        for (PHAsset *asset in subResult) {
            //获取缩略图
            [[PHImageManager defaultManager]requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                [weakSelf.originalImageAry addObject:imageData];
                [self saveImage];
            }];
        }
        
    }else{
        [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                ALAssetRepresentation* representation = [result defaultRepresentation];//不能直接读取image,否则后期浏览大图的时候会内存暴增
                Byte *buffer = (Byte*)malloc((unsigned long)representation.size);
                NSUInteger buffered = [representation getBytes:buffer fromOffset:0.0 length:((unsigned long)representation.size) error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                [weakSelf.originalImageAry addObject:data];
                [self saveImage];
            }
        }];
    }
}

- (void)saveImage{
    if (_originalImageAry.count == self.imageAry.count) {
        [YJPhotoShareManager shareInstance].imageArray = _originalImageAry;
    }
}

- (void)editAction{
    
}

- (void)previewAction{
    NSMutableArray *newImageAry = [[NSMutableArray alloc] init];
    [YJPhotoShareManager shareInstance].currentSelectedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [YJPhotoShareManager shareInstance].allSelectedArray.count; i ++) {
        if ([[YJPhotoShareManager shareInstance].allSelectedArray[i] boolValue]) {
            [newImageAry addObject:self.originalImageAry[i]];
            [[YJPhotoShareManager shareInstance].currentSelectedArray addObject:@(i)];
        }
    }
    
    YJPreviewViewController *previewVC = [[YJPreviewViewController alloc] initWithImageArray:newImageAry atIndex:0 isSelected:YES];
    previewVC.chooseBlock = ^(NSInteger index,BOOL isSelected){
        for (YJPhotoCollectionViewCell *cell in self.collectionView.visibleCells) {
            if (cell.tag == index) {
                [cell btnClick];
            }
        }
    };
    previewVC.doneBlock = ^(void){
        [self doneAction];
    };
    [self.navigationController pushViewController:previewVC animated:YES];
    
}

- (void)doneAction{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [YJPhotoShareManager shareInstance].allSelectedArray.count; i++) {
        if ([[YJPhotoShareManager shareInstance].allSelectedArray[i] boolValue]) {
            [imageArray addObject:[UIImage imageWithData:_originalImageAry[i]]];
        }
    }
    if (_myBlock) {
        _myBlock(imageArray);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
