//
//  TestVC.m
//  NoteBook
//
//  Created by  on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "TestVC.h"
#import "Note.h"
#import "TestCell.h"
#import "NoteDetailVC.h"
#import "NoteAddVC.h"

@implementation TestVC

#pragma mark - ViewLifeCycle视图生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 导航栏设置
    self.title = @"便签";
    //[self.navigationController.navigationBar setTintColor: [UIColor colorWithRed: 108/255.f green: 96/255.f blue: 90/255.f alpha: 1]];
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"title_bg_test.png"] forBarMetrics: UIBarMetricsDefault];
        
    noteDao = [[NoteDAO alloc] init];
//        
//    noteList = [[NSArray alloc] init];
//    
//    noteList = [noteDao queryFromDB];
    
//    Note *ha = [noteList objectAtIndex: 0];
//    
//    [noteDao updateNote: ha andContent: @"进来看看还有什么惊喜啊哈哈哈" andDate: [NSDate date]];
//    
//    Note *ha1 = [noteList objectAtIndex: 1];
//    
//    [noteDao updateNote: ha1 andContent: @"TIP:长按便签条，可上下移动" andDate: [NSDate date]];
//    
//    Note *ha2 = [noteList objectAtIndex: 2];
//    
//    [noteDao updateNote: ha2 andContent: @"项目项目项目目目" andDate: [NSDate date]];
//    
//    [noteDao addToDB: @"github.com" andDate: [NSDate date]];
//
//    [noteDao addToDB: @"TIP:点右上角按钮可新建一条便签" andDate: [NSDate date]];
    
    
    // 初始化表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20,  self.view.frame.size.width, self.view.frame.size.height - 44) style: UITableViewStylePlain];
    
    // 设置代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    // 设置行高
    _tableView.rowHeight = 90.f;
    
    // 设置分隔线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置回弹
    _tableView.bounces = NO;
    
    // 设置右边滚动位置条是否可见
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview: _tableView];
    
    // 设置表视图背景
    UIView *bgView = [[UIView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20,  self.view.frame.size.width, self.view.frame.size.height)];
    UIImageView *bgImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg.png"]];
    bgImg.frame = bgView.frame;
    [bgView addSubview: bgImg];
    
    _tableView.backgroundView = bgView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 每次进入页面，刷新数据
    
    //noteList = [[NSArray alloc] init];
    
    noteList = [noteDao queryFromDB];
    
    [_tableView reloadData];
    
    // 加载导航栏视图
    [self navViewShow];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 移除导航栏视图
    [navView removeFromSuperview];
}


#pragma mark - UITableViewDelegate数据源，协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if(cell == nil) {
        cell = [[TestCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
    }
    
    Note *notes = [noteList objectAtIndex: indexPath.row];
    
    cell.contenLabel.text = notes.content;
    
    // 规范时间显示格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *now = notes.date;
    
    NSString *temp = [dateFormatter stringFromDate: now];
    cell.timeLabel.text = temp;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    NoteDetailVC *noteDetail = [[NoteDetailVC alloc] init];
    [self.navigationController pushViewController: noteDetail animated: YES];
    [noteDetail showDetail: indexPath.row];
}

// 导航栏表现
- (void)navViewShow
{
    // 先将已经存在的navView移除
    [navView removeFromSuperview];
    
    navView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    
//    UIButton *btnBack = [UIButton buttonWithType: UIButtonTypeCustom];
//    btnBack.frame = CGRectMake(0, 0, 60, 44);
//    //[btnBack setImage: [UIImage imageNamed: @"back_button.9.png"] forState: UIControlStateNormal];
//    [btnBack addTarget: self action: @selector(btnBackClick) forControlEvents: UIControlEventTouchUpInside];
//    
//    UIImageView *img = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"back_button.9.png"]];
//    img.frame = CGRectMake(0, 0, btnBack.frame.size.width, btnBack.frame.size.height);
//    [btnBack addSubview: img];
//    
//    UILabel *backLabel = [[UILabel alloc] initWithFrame: CGRectMake(28, 2, 60-5, 45-5)];
//    backLabel.text = @"列表";
//    backLabel.textColor = [UIColor whiteColor];
//    backLabel.font = [UIFont systemFontOfSize: 11.f];
//    backLabel.backgroundColor = [UIColor clearColor];
//    [btnBack addSubview: backLabel];
//    
//    [navView addSubview: btnBack];
    
    UIButton *btnNew = [UIButton buttonWithType: UIButtonTypeCustom];
    btnNew.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width - 70, 0, 60, 44);
    //btnNew.backgroundColor = [UIColor whiteColor];
    [btnNew addTarget: self action: @selector(btnNewClick) forControlEvents: UIControlEventTouchUpInside];
    
    UIImageView *imgNew = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"button.png"]];
    imgNew.frame = CGRectMake(0, 0, btnNew.frame.size.width, btnNew.frame.size.height);
    [btnNew addSubview: imgNew];
    
    UIImageView *iconNew = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"new_note_icon.png"]];
    iconNew.frame = CGRectMake(15, 10, 30, 24);
    [imgNew addSubview: iconNew];
    
    [navView addSubview: btnNew];
        
    [self.navigationController.navigationBar addSubview: navView];
    
}

- (void)btnNewClick
{
    NoteAddVC *noteAdd = [[NoteAddVC alloc] init];
    [self.navigationController pushViewController: noteAdd animated: YES];
}



@end
