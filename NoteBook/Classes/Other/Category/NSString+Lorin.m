//
//  NSString+Lorin.m
//  NoteBook
//
//  Created by Lorin on 15/10/20.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "NSString+Lorin.h"

@implementation NSString (Lorin)

// 去掉字符串左边的特殊符号
- (NSString *)stringByTrimmingLeftCharactersInset:(NSCharacterSet *)characterSet
{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters: charBuffer];
    for(;location < length;location++) {
        if(![characterSet characterIsMember: charBuffer[location]]) {
            break;
        }
    }
    return [self substringWithRange: NSMakeRange(location, length - location)];
}

// 去掉字符串右边的特殊字符
- (NSString *)stringByTrimmingRightCharactersInset:(NSCharacterSet *)characterSet
{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters: charBuffer];
    for(;length > 0;length--) {
        if(![characterSet characterIsMember: charBuffer[length - 1]]) {
            break;
        }
    }
    return [self substringWithRange: NSMakeRange(location, length - location)];
}

@end
