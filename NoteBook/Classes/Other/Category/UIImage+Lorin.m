//
//  UIImage+Lorin.m
//  NoteBook
//
//  Created by Lorin on 15/10/21.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "UIImage+Lorin.h"

@implementation UIImage (Lorin)

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName
{
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}


@end
