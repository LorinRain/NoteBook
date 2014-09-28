//
//  TestVC.h
//  NoteBook
//
//  Created by  on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteDAO.h"

@interface TestVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *noteList;    // 接收查询到的数据(记事)
    NoteDAO *noteDao;
    UIView *navView;
}

// 导航栏表现
- (void)navViewShow;

@end
