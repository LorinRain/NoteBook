//
//  NoteTool.h
//  NoteBook
//
//  Created by Lorin on 15/10/19.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Note.h"

@interface NoteTool : NSObject

@property (nonatomic, weak) AppDelegate *myDelegate;

///添加数据
- (void)addNewNote:(NSString *)content;

///查询数据
- (NSArray *)findAll;

///更新数据
- (void)updateNote:(Note *)note replaceString:(NSString *)content;

///删除数据
- (void)deleteNote:(Note *)note;

@end
