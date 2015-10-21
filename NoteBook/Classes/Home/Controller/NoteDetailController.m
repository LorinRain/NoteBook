//
//  NoteDetailController.m
//  NoteBook
//
//  Created by Lorin on 15/7/13.
//  Copyright (c) 2015年 Lighting-Vista. All rights reserved.
//

#import "NoteDetailController.h"
#import "LRActionSheet.h"

@interface NoteDetailController ()<LRActionSheetDelegate>
{
    ///导航栏右边的按钮
    UIButton *rightBarButton;
    
    ///数据存取
    NoteTool *_noteTool;
    
    ///判断键盘是否出现
    BOOL isKeyboardShow;
    
    ///键盘高度
    double keyBoardHeight;
}

///编辑区域
@property (nonatomic, strong) UITextView *textView;

@end

@implementation NoteDetailController

- (id)initWithEditState:(NoteEditState)state
{
    self = [super init];
    if(self) {
        _editState = state;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 设置表属性
    [self setTables];
    
    // 搭建UI
    [self buildUI];
    
    // 初始化NoteTool
    _noteTool = [[NoteTool alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardDidShow:) name: UIKeyboardDidShowNotification object: nil];
    
    // 注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardDidHide:) name: UIKeyboardDidHideNotification object: nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardDidShowNotification object: nil];
    
    // 解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardDidHideNotification object: nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 如果是新建，则弹出键盘
    if(_editState == kNoteEditeStateNew) {
        [self.textView becomeFirstResponder];
        // 内容置0
        self.textView.text = nil;
    }
}

#pragma mark - 键盘出现通知
// 键盘出现时，导航栏相应变化
- (void)keyboardDidShow:(NSNotification *)notif
{
    // 这个方法会多次调用，所以需要添加判断
    if(isKeyboardShow == NO) {
        // 获得键盘尺寸
        NSDictionary *info = [notif userInfo];
        NSValue *aValue = [info objectForKey: UIKeyboardFrameEndUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        // 重新定义输入框的尺寸
        CGRect viewFrame = self.textView.frame;
        // 42为中文键盘的中文选择栏的高度
        viewFrame.size.height -= (keyboardSize.height+42);
        //notepad.frame = viewFrame;
        keyBoardHeight = keyboardSize.height+42;
        
        self.textView.frame = viewFrame;
        
        isKeyboardShow = YES;
    }
    
    // 键盘出现的时候，右边按钮
    // 如果是编辑态
    [self setNavRightButton: @"完成"];
    
}

- (void)keyboardDidHide:(NSNotification *)notif
{
    isKeyboardShow = NO;
    // 键盘消失时，恢复原有高度
    CGRect viewFrame = self.textView.frame;
    viewFrame.size.height += keyBoardHeight;
    self.textView.frame = viewFrame;
    
    // 如果是编辑态，则右边为删除
    if(_editState == kNoteEditeStateEdit) {
        [self setNavRightButton: @"删除"];
    } else {
        [self setNavRightButton: nil];
    }
}

#pragma mark - 设置表属性
- (void)setTables
{
    // 设置背景
    UIImageView *bg = [[UIImageView alloc] init];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    bg.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    bg.contentMode = UIViewContentModeScaleAspectFill;
    //bg.clipsToBounds = YES;
    bg.image = [[UIImage imageNamed: @"note_paper_background_full.png"] stretchableImageWithLeftCapWidth: 0 topCapHeight: 0];
    
    bg.userInteractionEnabled = YES;
    
    self.tableView.backgroundView = bg;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 隐藏系统自带的线条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 隐藏右边滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - 搭建UI
-(void)buildUI
{
    [self.view addSubview: self.textView];
    // 如果是编辑态，则显示笔记的文字
    if(_editState == kNoteEditeStateEdit) {
        self.textView.text = _note.notedetail;
        [self setNavRightButton: @"删除"];
    }
    // 初始状态下的键盘为不显示
    isKeyboardShow = NO;
}

#pragma mark - 导航栏右边的按钮
- (void)setNavRightButton:(NSString *)title
{
    if(title == nil) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        if(!rightBarButton) {
            rightBarButton = [UIButton buttonWithType: UIButtonTypeCustom];
            [rightBarButton setBackgroundImage: [UIImage imageNamed: @"button_bg.png"] forState: UIControlStateNormal];
            rightBarButton.bounds = CGRectMake(0, 0, 48, 40);
            rightBarButton.titleLabel.font = [UIFont systemFontOfSize: 13];
            [rightBarButton addTarget: self action: @selector(rightBarButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        }
        [rightBarButton setTitle: title forState: UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: rightBarButton];
    }
}

#pragma mark 导航栏右边按钮点击事件
- (void)rightBarButtonAction:(UIButton *)button
{
    if([[button titleForState: UIControlStateNormal] isEqualToString: @"完成"]) {
        // 判断是否有文字
        if([self.textView hasText]) {
            // 判断状态
            if(_editState == kNoteEditeStateNew) {
                // 保存
                [_noteTool addNewNote: self.textView.text];
                _note = [[_noteTool findAll] firstObject];
            } else {
                // 更新
                [_noteTool updateNote: _note replaceString: self.textView.text];
            }
            
            // 完成后更新状态
            _editState = kNoteEditeStateEdit;
            
            // 隐藏键盘
            [self.textView resignFirstResponder];
        }
    } else if([[button titleForState: UIControlStateNormal] isEqualToString: @"删除"]) {
        // 隐藏键盘
        [self.textView resignFirstResponder];
        // 弹出提示框
        LRActionSheet *actionSheet = [[LRActionSheet alloc] initWithTitle: @"确定删除此便签？" destroyButtonTitle: @"删除" otherButtonTitles: nil];
        actionSheet.delegate = self;
        [actionSheet show];
    }
}

#pragma mark - 编辑区域
- (UITextView *)textView
{
    if(!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(20, 5, self.view.frame.size.width-20*2, self.view.frame.size.height-10*2);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        // 设置行间距
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.lineSpacing = 10;  // 字体行间距
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize: 16.f],
                                     NSParagraphStyleAttributeName:paragrapStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithRed: 110/255.f green: 67/255.f blue: 47/255.f alpha: 1]};
        _textView.attributedText = [[NSAttributedString alloc] initWithString: @" " attributes: attributes];
    }
    
    return _textView;
}

#pragma mark - LRActionSheet Delegate
- (void)actionSheet:(LRActionSheet *)actionSheet buttonClickedAtIndex:(NSInteger)index
{
    if(index == actionSheet.destructiveButtonIndex) {
        // 删除
        [_noteTool deleteNote: _note];
        // 返回前一页
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver: self];
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
