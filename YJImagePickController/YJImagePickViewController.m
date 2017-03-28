//
//  YJImagePickViewController.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//


#import "YJImagePickViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YJPhotoAblumTableViewCell.h"
#import "YJPhotoCollectionViewController.h"
#import "YJPhotoShareManager.h"
#import "UIViewController+YJPhotoExtend.h"
@interface YJImagePickViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,selectdImageDelegate>
{
    ALAssetsLibrary *assetsLibrary;
    PHFetchResult *fetchReult;
}

@property (nonatomic, strong)UITableView  *mainTable;
@property (nonatomic, strong)NSMutableArray  *photoListAry;
@property (nonatomic, strong)NSMutableArray  *photoImageAry;
@property (nonatomic, strong)YJPhotoShareManager  *photoShare;
@property (nonatomic, strong)selectedBlock  myBlock;

@end

@implementation YJImagePickViewController

- (void)dealloc{
    self.photoImageAry = nil;
    self.photoListAry = nil;
}

- (instancetype)initWithMaxSelected:(NSInteger)maxSelected selectedImageBlock:(selectedBlock)block{
    if (self = [super init]) {
        _photoShare = [YJPhotoShareManager shareInstance];
        _photoShare.maxCount = maxSelected;
        _myBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.mainTable && [self.mainTable indexPathForSelectedRow]) {
        [self.mainTable deselectRowAtIndexPath:[self.mainTable indexPathForSelectedRow] animated:YES];
    }
}

- (void)initSubviews{
    self.title = @"照片";
    [self setTitleColor];
    [self setNavgationBarColor];
    [self rightButtonCustomerWith:nil andTitle:@"取消"];
    _mainTable = [[UITableView alloc] init];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.frame = self.view.frame;
    [self.view addSubview:_mainTable];
}

- (void)rightButtonClick{
    [YJPhotoShareManager shareInstance].selectedCount = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData{
    self.photoListAry = [[NSMutableArray alloc] init];
    if (iOS8) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized) {
            fetchReult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            for (PHAssetCollection *assetCollection in fetchReult) {
                [self.photoListAry addObject:assetCollection];
            }
            mainQueue(^{
                [self.mainTable reloadData];
            });
        }else{
            //必须添加，否则隐私相册那边没有显示APP的名字
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    self->fetchReult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                    for (PHAssetCollection *assetCollection in self->fetchReult) {
                        [self.photoListAry addObject:assetCollection];
                    }
                    mainQueue(^{
                        [self.mainTable reloadData];
                    });
                }
            }];
        }
    }else{
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusAuthorized) {
            //访问图片
            assetsLibrary = [[ALAssetsLibrary alloc] init];
            //获取分组
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];//设置模式
                if (group) {
                    [self.photoListAry addObject:group];
                }else{
                    [self.mainTable reloadData];
                }
            } failureBlock:^(NSError *error) {
                [self showAlert];
            }];
        }else{
            [self showAlert];
        }
    }
}

- (void)showAlert{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"应用想访问您的相册" message:@"请设置应用的相册访问权限" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"去设置", nil];
    [alert show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height /9.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.photoListAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"PHOTOCELL";
    YJPhotoAblumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YJPhotoAblumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (iOS8) {
        PHAssetCollection *assetCollection = self.photoListAry[indexPath.row];
        PHFetchResult *subResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        cell.leftLabel.text = assetCollection.localizedTitle;
        cell.numberLabel.text = [NSString stringWithFormat:@"(%ld)",(long)[subResult count]];//获取相片数
        PHAsset *asset = subResult[0];
        [[PHImageManager defaultManager]requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            cell.icon.image = [UIImage imageWithData:imageData];
        }];
    }else{
        ALAssetsGroup *group = self.photoListAry[indexPath.row];
        cell.leftLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];//获取分组名
        cell.numberLabel.text = [NSString stringWithFormat:@"(%ld)",(long)[group numberOfAssets]];//获取相片数
        cell.icon.image = [UIImage imageWithCGImage:[group posterImage]];//获取封面
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加请求网络加载图
    _photoImageAry = [[NSMutableArray alloc] init];
    NSString *title = @"";
    __weak __typeof(&*self)weakSelf = self;
    if (iOS8) {
        PHAssetCollection *assetCollection = self.photoListAry[indexPath.row];
        title = assetCollection.localizedTitle;
        
        PHFetchResult *subResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        for (PHAsset *asset in subResult) {
            //获取缩略图
            [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [weakSelf.photoImageAry addObject:result];
                if (weakSelf.photoImageAry.count == subResult.count) {
                    weakSelf.photoShare.thumbnailArray = weakSelf.photoImageAry;
                    [weakSelf pushToPhotoListViewControllerWithTitle:title atIndex:indexPath];
                }
            }];
        }
        
    }else{
        ALAssetsGroup *group = self.photoListAry[indexPath.row];
        title = [group valueForProperty:ALAssetsGroupPropertyName];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [weakSelf.photoImageAry addObject:[UIImage imageWithCGImage:[result thumbnail]]];//获取缩略图
                if (weakSelf.photoImageAry.count == [group numberOfAssets]) {
                    weakSelf.photoShare.thumbnailArray = weakSelf.photoImageAry;
                    [weakSelf pushToPhotoListViewControllerWithTitle:title atIndex:indexPath];
                }
            }
        }];
    }
}

- (void)pushToPhotoListViewControllerWithTitle:(NSString *)title atIndex:(NSIndexPath *)path{
    YJPhotoCollectionViewController *collectionVC = [[YJPhotoCollectionViewController alloc] initWithTitle:title imageArray:self.photoImageAry data:self.photoListAry[path.row] delegate:self];
    [self.navigationController pushViewController:collectionVC animated:YES];
}

- (void)selectedImageArray:(NSArray<UIImage *> *)imageArray{
    if (_myBlock) {
        _myBlock(imageArray);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 类型一览
/*PHAssetCollectionTypeAlbum      = 1,从iTunes 同步来的相册，以及用户在photos自己建立的相册
 PHAssetCollectionTypeSmartAlbum = 2,经由相机得来的相册
 PHAssetCollectionTypeMoment     = 3,Photos为我们自动生成的时间分组的相册
 */
/*
 PHAssetCollectionSubtypeAlbumRegular         = 2,用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
 PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
 PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
 PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,做了 AlbumSyncedEvent 应该做的事
 PHAssetCollectionSubtypeAlbumImported        = 6,从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
 
 // PHAssetCollectionTypeAlbum shared subtypes
 PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,用户的 iCloud 照片流
 PHAssetCollectionSubtypeAlbumCloudShared     = 101,用户使用 iCloud 共享的相册
 
 // PHAssetCollectionTypeSmartAlbum subtypes
 PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
 PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,相机拍摄的全景照片
 PHAssetCollectionSubtypeSmartAlbumVideos     = 202,相机拍摄的视频
 PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,收藏文件夹
 PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,延时视频文件夹，同时也会出现在视频文件夹中
 PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,包含隐藏照片或视频的文件夹
 PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,相机近期拍摄的照片或视频
 PHAssetCollectionSubtypeSmartAlbumBursts     = 207,连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
 
 PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。不过我的 iPad mini 不支持，没法验证。
 
 PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,//这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
 
 PHAssetCollectionSubtypeSmartAlbumSelfPortraits PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 210,
 PHAssetCollectionSubtypeSmartAlbumScreenshots PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 211,
 
 // Used for fetching, if you don't care about the exact subtype
 PHAssetCollectionSubtypeAny = NSIntegerMax
 */

@end
