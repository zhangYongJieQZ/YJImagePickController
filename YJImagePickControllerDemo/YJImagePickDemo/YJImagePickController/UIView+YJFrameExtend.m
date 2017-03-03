//
//  UIView+YJFrameExtend.m
//  Pods
//
//  Created by admin on 2017/3/2.
//
//

#import "UIView+YJFrameExtend.h"

@implementation UIView (YJFrameExtend)
- (CGFloat)left{
    return self.frame.origin.x;
}
- (CGFloat)top{
    return self.frame.origin.y;
}
- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (CGFloat)height{
    return self.frame.size.height;
}
@end
