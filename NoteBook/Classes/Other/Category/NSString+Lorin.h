//
//  NSString+Lorin.h
//  NoteBook
//
//  Created by Lorin on 15/10/20.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Lorin)

///去掉字符串左边的特殊符号
- (NSString *)stringByTrimmingLeftCharactersInset:(NSCharacterSet *)characterSet;

///去掉字符串右边的特殊字符
- (NSString *)stringByTrimmingRightCharactersInset:(NSCharacterSet *)characterSet;

@end
