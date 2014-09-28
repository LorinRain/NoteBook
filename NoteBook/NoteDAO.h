//
//  NoteDAO.h
//  NoteBook
//
//  Created by  on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"
#import "Note.h"

@interface NoteDAO : NSObject

@property (nonatomic, strong) CoreData *myDelegate;
@property (nonatomic, strong) NSMutableArray *entries;

// 保存数据
- (void)addToDB:(NSString *)content andDate:(NSDate *)now;

// 查询
- (NSArray *)queryFromDB;

// 更新操作
- (void)updateNote:(Note *)note andContent:(NSString *)content andDate:(NSDate *)date;

// 删除操作
- (void)deleteNote:(Note *)note;

@end
