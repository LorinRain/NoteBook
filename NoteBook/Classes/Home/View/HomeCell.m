//
//  HomeCell.m
//  NoteBook
//
//  Created by Lorin on 15/7/13.
//  Copyright (c) 2015年 Lighting-Vista. All rights reserved.
//

#import "HomeCell.h"
#import "NSString+Lorin.h"

@implementation HomeCell
{
    UIImageView *jiazi;    // 左边的夹子
    UIImageView *cellBg;   // 单元格背景
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        // 设置背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        cellBg = [[UIImageView alloc] init];
        cellBg.image = [UIImage imageNamed: @"list_item_bg"];
        
        [self.contentView addSubview: cellBg];
        
        jiazi = [[UIImageView alloc] init];
        jiazi.image = [UIImage imageNamed: @"clip_normal"];
        
        [self.contentView addSubview: jiazi];
        
        // 自定义内容表现
        _contenLabel = [[UILabel alloc] init];
        _contenLabel.font = [UIFont systemFontOfSize: 16.f];
        _contenLabel.textColor = [UIColor colorWithRed: 110/255.f green: 67/255.f blue: 47/255.f alpha: 1];
        
        [cellBg addSubview: _contenLabel];
        
        // 自定义时间表现
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize: 13.f];
        _timeLabel.textColor = [UIColor colorWithRed: 185/255.f green: 166/255.f blue: 145/255.f alpha: 1];
        
        [cellBg addSubview: _timeLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    cellBg.frame = CGRectMake(0, 5, self.contentView.frame.size.width, 80);
    jiazi.frame = CGRectMake(0, 5, 20, cellBg.frame.size.height);
    
    // 内容与时间
    _contenLabel.frame = CGRectMake(cellBg.frame.size.height / 3 + 17, cellBg.frame.size.height / 3 + 8, cellBg.frame.size.width - (cellBg.frame.size.height / 3 + 10) - 20, cellBg.frame.size.height - (cellBg.frame.size.height / 3 + 10) - 10);
    _timeLabel.frame = CGRectMake(cellBg.frame.size.height / 3 + 17, 8, cellBg.frame.size.width - (cellBg.frame.size.height / 3 + 10) - 20, cellBg.frame.size.height / 3 - 10);
    
}

// 设置cell内容
- (void)setItem:(Note *)note
{
    _note = note;
    self.timeLabel.text = note.date;
    // 首页显示的文字，直接从文字部分开始，忽略文字前面的空格或换行
    NSString *tempText = [note.notedetail stringByTrimmingLeftCharactersInset: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.contenLabel.text = tempText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
