//
//  NoteTool.m
//  NoteBook
//
//  Created by Lorin on 15/10/19.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "NoteTool.h"

@implementation NoteTool

- (instancetype)init
{
    self = [super init];
    if(self) {
        // 得到应用程序代理类对象
        self.myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return self;
}

/*
 * CoreData 添加数据
 */
- (void)addNewNote:(NSString *)content
{
    Note *newNote = [NSEntityDescription insertNewObjectForEntityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    newNote.notedetail = content;
    // 日期转换
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    newNote.date = dateString;
    
    // 保存
    [self.myDelegate saveContext];
}

/*
 * CoreData 查询所有数据
 */
- (NSArray *)findAll
{
    // 创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设定查询哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    [request setEntity: entity];
    
    // 排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: @"date" ascending: NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects: sort, nil];
    [request setSortDescriptors: sortArray];
    
    // 执行查询
    NSError *error = nil;
    NSArray *result = [self.myDelegate.managedObjectContext executeFetchRequest: request error: &error];
    if(result == nil) {
        NSLog(@"error: %@, %@", error, [error userInfo]);
        return result;
    }
    
    return result;
}

/*
 * CoreData 更新
 */
- (void)updateNote:(Note *)note replaceString:(NSString *)content
{
    // 创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置查询哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    [request setEntity: entity];
    
    // 设置查询条件
    NSPredicate *predice = [NSPredicate predicateWithFormat: @"date = %@", note.date];
    [request setPredicate: predice];
    
    NSError *error = nil;
    NSArray *result = [self.myDelegate.managedObjectContext executeFetchRequest: request error: &error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate: [NSDate date]];
    note.date = dateString;
    note.notedetail = content;
    
    if(result.count > 0) {
        Note *temp = [result lastObject];
        temp.notedetail = note.notedetail;
        temp.date = note.date;
        
        // 保存
        [self.myDelegate saveContext];
    }
}

/*
 * CoreData 删除
 */
- (void)deleteNote:(Note *)note
{
    // 创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置查询哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Note" inManagedObjectContext: self.myDelegate.managedObjectContext];
    [request setEntity: entity];
    
    // 设置查询条件
    NSPredicate *predice = [NSPredicate predicateWithFormat: @"date = %@", note.date];
    [request setPredicate: predice];
    
    NSError *error = nil;
    NSArray *result = [self.myDelegate.managedObjectContext executeFetchRequest: request error: &error];
    
    if(result.count > 0) {
        Note *temp = [result lastObject];
        [self.myDelegate.managedObjectContext deleteObject: temp];
        
        // 保存
        [self.myDelegate saveContext];
    }
}

@end
