//
//  HomeController.m
//  NoteBook
//
//  Created by Lorin on 15/7/13.
//  Copyright (c) 2015年 Lighting-Vista. All rights reserved.
//

#import "HomeController.h"
#import "HomeCell.h"
#import "NoteDetailController.h"
#import "NoteTool.h"

@interface HomeController ()
{
    ///数据数组
    NSMutableArray *_dataArray;
}

@property (nonatomic, strong) NoteTool *noteTool;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 设置导航栏
    [self setNavBar];
    
    // 设置表属性
    [self setTables];
    
    // 查询已有的note
    _dataArray = [NSMutableArray arrayWithArray: [self.noteTool findAll]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

#pragma mark - 设置导航栏
- (void)setNavBar
{
    // 背景图片
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"nav_bg"] forBarMetrics: UIBarMetricsDefault];
    
    // 导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                       //NSFontAttributeName:[UIFont systemFontOfSize: 18]
                                                                       }];
    // 导航栏返回按钮
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    UIImage *backButtonImage = [[UIImage imageNamed: @"back_button.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 0, 0, 0) resizingMode: UIImageResizingModeStretch];
    [barButtonItem setBackButtonBackgroundImage: backButtonImage forState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    // 将返回按钮的文字不显示在屏幕上
    [barButtonItem setBackButtonTitlePositionAdjustment: UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics: UIBarMetricsDefault];
    
    // 标题
    self.title = @"便签";
    // 右边的新增按钮
    UIButton *newNoteBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [newNoteBtn setBackgroundImage: [UIImage imageNamed: @"button_bg.png"] forState: UIControlStateNormal];
    [newNoteBtn setImage: [UIImage imageNamed: @"new_note_icon.png"] forState: UIControlStateNormal];
    newNoteBtn.bounds = CGRectMake(0, 0, 48, 40);
    [newNoteBtn addTarget: self action: @selector(newNoteButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: newNoteBtn];
}

#pragma mark - 设置表属性
- (void)setTables
{
    // 设置背景
    UIImageView *bg = [[UIImageView alloc] init];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    bg.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    bg.image = [UIImage imageNamed: @"home_bg"];
    
    bg.userInteractionEnabled = YES;
    
    self.tableView.backgroundView = bg;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 隐藏系统自带的线条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 隐藏右边滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - newNoteButtonAction 新建Note
- (void)newNoteButtonAction:(UIButton *)btn
{
    NoteDetailController *noteDetail = [[NoteDetailController alloc] initWithEditState: kNoteEditeStateNew];
    [self.navigationController pushViewController: noteDetail animated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if(cell == nil) {
        cell = [[HomeCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    cell.contenLabel.text = [(Note *)_dataArray[indexPath.row] notedetail];
    cell.timeLabel.text = [(Note *)_dataArray[indexPath.row] date];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NoteDetailController *noteDetail = [[NoteDetailController alloc] initWithEditState: kNoteEditeStateEdit];
    noteDetail.note = _dataArray[indexPath.row];
    [self.navigationController pushViewController: noteDetail animated: YES];
}

// 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.noteTool deleteNote: _dataArray[indexPath.row]];
    [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    [self reloadData];
    [self.tableView endUpdates];
}

#pragma mark - NoteTool
- (NoteTool *)noteTool
{
    if(!_noteTool) {
        _noteTool = [[NoteTool alloc] init];
    }
    
    return _noteTool;
}

#pragma mark - 刷新
- (void)reloadData
{
    // 查询数组
    _dataArray = [NSMutableArray arrayWithArray: [self.noteTool findAll]];
    // 刷新表格
    [self.tableView reloadData];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
