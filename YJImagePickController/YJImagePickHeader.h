//
//  YJImagePickHeader.h
//  YJImagePickDemo
//
//  Created by zhangyongjie on 2017/3/28.
//  Copyright © 2017年 张永杰. All rights reserved.
//

#ifndef YJImagePickHeader_h
#define YJImagePickHeader_h

#define iOS8 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define mainQueue(block) dispatch_async(dispatch_get_main_queue(),block)
#define backQueue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#endif /* YJImagePickHeader_h */
