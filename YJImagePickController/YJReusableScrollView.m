//
//  YJReusableScrollView.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import "YJReusableScrollView.h"
#import "YJImageScrollView.h"

@interface YJReusableScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong)NSArray  *imageAry;
@property (nonatomic, strong)YJImageScrollView  *leftV;
@property (nonatomic, strong)YJImageScrollView  *midV;
@property (nonatomic, strong)YJImageScrollView  *rightV;
@property (nonatomic, assign)NSInteger  currentPage;//当前页码
@property (nonatomic, assign)BOOL  hidden;

@end

@implementation YJReusableScrollView

- (instancetype)initWithFrame:(CGRect)frame imageAry:(NSArray *)imageAry currentIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        _imageAry = imageAry;
        _index = index;
        _currentPage = 0;
        _hidden = NO;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = NO;
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor blackColor];
    //分情况创建
    if (_imageAry.count == 1) {
        self.contentSize = CGSizeMake(SCREENWIDTH , SCREENHEIGHT);
        _leftV = [[YJImageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) image:[UIImage imageWithData:_imageAry[_index]]];
        [self addSubview:_leftV];
    }else if (_imageAry.count == 2){
        self.contentSize = CGSizeMake(SCREENWIDTH * 2, SCREENHEIGHT);
        //做判断是不是设置滚动距离
        _leftV = [[YJImageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) image:[UIImage imageWithData:_imageAry[0]]];
        [self addSubview:_leftV];
        _midV = [[YJImageScrollView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT) image:[UIImage imageWithData:_imageAry[1]]];
        [self addSubview:_midV];
        if (_index > 0) {
            _currentPage = 1;
            [self setContentOffset:CGPointMake(SCREENWIDTH * _currentPage, 0)];
        }
    }else{
        self.contentSize = CGSizeMake(SCREENWIDTH * 3, SCREENHEIGHT);
        NSInteger midIndex = 0;
        if (_index == _imageAry.count - 1) {//最后一张
            midIndex = _index - 1;
            _currentPage = 2;
        }else if (_index == 0){
            midIndex = _index + 1;
            _currentPage = 0;
        }else{
            midIndex = _index;
            _currentPage = 1;
        }
        _leftV = [[YJImageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) image:[UIImage imageWithData:[self returnPathString:_imageAry[midIndex - 1]]]];
        [self addSubview:_leftV];
        _midV = [[YJImageScrollView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT) image:[UIImage imageWithData:[self returnPathString:_imageAry[midIndex]]]];
        [self addSubview:_midV];
        _rightV = [[YJImageScrollView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 2, 0, SCREENWIDTH, SCREENHEIGHT) image:[UIImage imageWithData:[self returnPathString:_imageAry[midIndex +1]]]];
        [self addSubview:_rightV];
        [self setContentOffset:CGPointMake(SCREENWIDTH * _currentPage, 0)];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction{
    __weak __typeof(&*self)weakSelf = self;
    _hidden = !_hidden;
    if (_tapBlock) {
        _tapBlock(weakSelf.hidden);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //page是为了防止没翻页造成的问题
    NSInteger page = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    if (_currentPage != page) {
        _currentPage = page;
        if (!_index) {
            _index = _currentPage;//从0->1的时候不需要做操作
        }
        if ((_currentPage == 1 || _currentPage == 0) && _index > 1) {
            _index-=1;
            _index = _index < 0 ? 0 : _index;
            if (_index >= 1) {
                [self reusableSelf];
            }
        }else if (_currentPage == 2 && _index < _imageAry.count){
            _index+=1;
            _index = _index > _imageAry.count ? _imageAry.count : _index;
            if (_index < (_imageAry.count - 1)) {
                [self reusableSelf];
            }
        }else if (_currentPage == 0 && _index == 1){
            _index -= 1;
            [self resetImagesFrame];
        }else{
            [self resetImagesFrame];
        }
        __weak __typeof(&*self)weakSelf = self;
        if (_pageBlock) {
            _pageBlock(weakSelf.index);
        }
    }
}

- (void)resetImagesFrame{
    [_midV resetFrame];
    [_leftV resetFrame];
    [_rightV resetFrame];
}

- (void)reusableSelf{
    [_midV resetImage:[UIImage imageWithData:[self returnPathString:_imageAry[_index]]]];
    [_leftV resetImage:[UIImage imageWithData:[self returnPathString:_imageAry[_index - 1]]]];
    [_rightV resetImage:[UIImage imageWithData:[self returnPathString:_imageAry[_index + 1]]]];
    [self setContentOffset:CGPointMake(SCREENWIDTH, 0)];
    _currentPage = 1;
}

- (NSData *)returnPathString:(id)pathData{
    if ([pathData isKindOfClass:[NSData class]]) {
        return pathData;
    }else if ([pathData isKindOfClass:[NSURL class]]){
        NSData *data = [NSData dataWithContentsOfURL:pathData];
        return data;
    }else{
        return nil;
    }
}


@end
