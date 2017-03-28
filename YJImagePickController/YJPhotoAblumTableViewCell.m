//
//  YJPhotoAblumTableViewCell.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import "YJPhotoAblumTableViewCell.h"
#import "UIView+YJFrameExtend.h"

@implementation YJPhotoAblumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _icon = [[UIImageView alloc] init];
        _icon.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height /9.0, [UIScreen mainScreen].bounds.size.height /9.0);
        [self addSubview:_icon];
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.frame = CGRectMake(_icon.right + 5, 0, 90, [UIScreen mainScreen].bounds.size.height /9.0);
        [self addSubview:_leftLabel];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = [UIColor grayColor];
        _numberLabel.font = [UIFont systemFontOfSize:13];
        _numberLabel.frame = CGRectMake(_leftLabel.right + 5.0, 0, 30, [UIScreen mainScreen].bounds.size.height /9.0);
        [self addSubview:_numberLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
