//
//  NoteDetailVC.h
//  NoteBook
//
//  Created by  on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGNotePad.h"
#import "NoteDAO.h"

@interface NoteDetailVC : UIViewController
{
    NSArray *noteList;
    KGNotePad *notepad;
    NoteDAO *noteDao;
    Note *note;
    BOOL isTetxing;   // 是否正在编辑(由键盘通知监听)
    UIView *navView;   // 导航栏view
    int numOfNote;
}


- (void)showDetail:(int)line;

// 导航栏表现
- (void)navShow;

// 点击记事本，进入编辑状态，点击保存，更新数据
- (void)reSaveNote;

// 删除记事
- (void)deleteNote;


@end
