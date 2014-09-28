//
//  TestCell.m
//  NoteBook
//
//  Created by  on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

@synthesize timeLabel = _timeLabel;
@synthesize contenLabel = _contenLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.frame = CGRectMake(0, 0,320, 90);
        
        // 自定义cell样式，显示时间和标题
        UIImageView *cellImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"list_item_bg.png"]];
        cellImg.frame = CGRectMake(1, 6, self.contentView.frame.size.width - 3, self.contentView.frame.size.height - 6);
        
        [self.contentView addSubview: cellImg];
        
        // 自定义cell样式，左边的回形针
        UIImageView *cellClip = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"clip_normal.png"]];
        cellClip.frame = CGRectMake(0, 0, cellImg.frame.size.height / 3 + 5 - ((cellImg.frame.size.height / 3) / 3), self.contentView.frame.size.height);
        
        [self.contentView addSubview: cellClip];
        
        // 自定义内容表现
        _contenLabel = [[UILabel alloc] initWithFrame: CGRectMake(cellImg.frame.size.height / 3 + 10, cellImg.frame.size.height / 3 + 8, cellImg.frame.size.width - (cellImg.frame.size.height / 3 + 10) - 10, cellImg.frame.size.height - (cellImg.frame.size.height / 3 + 10) - 10)];
        
        [cellImg addSubview: _contenLabel];
        
        // 自定义时间表现
        _timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(cellImg.frame.size.height / 3 + 10, 8, cellImg.frame.size.width - (cellImg.frame.size.height / 3 + 10) - 20, cellImg.frame.size.height / 3 - 10)];
        
        [cellImg addSubview: _timeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    _contenLabel.font = [UIFont systemFontOfSize: 16.f];
    _contenLabel.textColor = [UIColor colorWithRed: 110/255.f green: 67/255.f blue: 47/255.f alpha: 1];
    _contenLabel.backgroundColor = [UIColor clearColor];
    
    _timeLabel.font = [UIFont systemFontOfSize: 13.f];
    _timeLabel.textColor = [UIColor colorWithRed: 185/255.f green: 166/255.f blue: 145/255.f alpha: 1];
    _timeLabel.backgroundColor = [UIColor clearColor];
    
}

@end
