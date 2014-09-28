//
//  NoteDAO.m
//  NoteBook
//
//  Created by  on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NoteDAO.h"

@implementation NoteDAO

@synthesize myDelegate;
@synthesize entries;

// 保存数据
- (void)addToDB:(NSString *)content andDate:(NSDate *)now
{
    self.myDelegate = [[CoreData alloc] init];
    Note *note = (Note *)[NSEntityDescription insertNewObjectForEntityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    
    [note setContent: content];
    [note setDate: now];
    
    NSError *error;
    
    BOOL isSaveSuccess = [self.myDelegate.managedObjectContext save: &error];
    
    if(!isSaveSuccess) {
        NSLog(@"Error; %@,%@",error, [error userInfo]);
    } else {
        NSLog(@"Save success!");
    }
    
}

// 查询
- (NSArray *)queryFromDB
{
    self.myDelegate = [[CoreData alloc] init];
    // 创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    // 设置请求实体
    [request setEntity: entity];
    
    // 对结果进行排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: @"date" ascending: NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects: sort, nil];
    [request setSortDescriptors: sortArray];
    
    NSError *error = nil;
    // 执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.myDelegate.managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    if(mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
        return mutableFetchResult;
    } 
    
    self.entries = mutableFetchResult;
    
    NSLog(@"The count is:%d",[entries count]);
    
//    for(Note *note in entries) {
//        NSLog(@"Content:%@----Date:%@",note.content,note.date);
//    }
    
    return self.entries;
    
}

// 更新操作
- (void)updateNote:(Note *)note andContent:(NSString *)content andDate:(NSDate *)date
{
    self.myDelegate = [[CoreData alloc] init];
    // 创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    // 设置请求实体
    [request setEntity: entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"date = %@",note.date];
    [request setPredicate: predicate];
    
    NSError *error;
    NSArray *mutableFetchResult = [self.myDelegate.managedObjectContext executeFetchRequest: request error: &error];
    
    [note setDate: date];
    [note setContent: content];
    
    if([mutableFetchResult count] > 0) {
        Note *temp = [mutableFetchResult lastObject];
        temp.content = note.content;
        temp.date = note.date;
        //NSError *error;
        BOOL isUpdateSuccess = [self.myDelegate.managedObjectContext save: &error];
        if(!isUpdateSuccess) {
            NSLog(@"Error:%@,%@",error, [error userInfo]);
        } else {
            NSLog(@"更新成功");
        }
    
    }
}

// 删除操作
- (void)deleteNote:(Note *)note
{
    self.myDelegate = [[CoreData alloc] init];
    // 创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    // 设置请求实体
    [request setEntity: entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"date = %@",note.date];
    [request setPredicate: predicate];
    
    NSError *error;
    NSArray *mutableFetchResult = [self.myDelegate.managedObjectContext executeFetchRequest: request error: &error];
    
    if([mutableFetchResult count] > 0) {
        Note *temp = [mutableFetchResult lastObject];
        [self.myDelegate.managedObjectContext deleteObject: temp];
        [self.entries removeObject: note];
        
        NSError *error;
        if(![self.myDelegate.managedObjectContext save: &error]) {
            NSLog(@"Error:%@,%@",error, [error userInfo]);
        } else {
            NSLog(@"删除成功");
        }
    }
}


@end
