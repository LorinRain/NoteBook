//
//  NoteAddVC.h
//  NoteBook
//
//  Created by  on 14-9-27.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGNotePad.h"
#import "NoteDAO.h"

@interface NoteAddVC : UIViewController
{
    KGNotePad *notepad;
    UIView *navView;
    NoteDAO *noteDao;
    BOOL isTetxing;   // 是否正在编辑(由键盘通知监听)
}

// 导航栏表现
- (void)navShow;


@end
