//
//  NoteDetailController.h
//  NoteBook
//
//  Created by Lorin on 15/7/13.
//  Copyright (c) 2015年 Lighting-Vista. All rights reserved.
//  note详情页

#import <UIKit/UIKit.h>
#import "NoteTool.h"

typedef enum {
    kNoteEditeStateNew,     // 新建
    kNoteEditeStateEdit     // 编辑
}NoteEditState;

@interface NoteDetailController : UITableViewController

@property (nonatomic, assign) NoteEditState editState;
@property (nonatomic, strong) Note *note;

///初始化方法，初始的时候指定编辑状态
- (id)initWithEditState:(NoteEditState)state;

@end
