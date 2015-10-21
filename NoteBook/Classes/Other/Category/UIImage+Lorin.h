//
//  UIImage+Lorin.h
//  NoteBook
//
//  Created by Lorin on 15/10/21.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Lorin)

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

@end
