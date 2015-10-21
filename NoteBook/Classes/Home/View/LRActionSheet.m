//
//  LRActionSheet.m
//  NoteBook
//
//  Created by Lorin on 15/10/21.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "LRActionSheet.h"
#import "UIImage+Lorin.h"

#define SCREENSIZE [UIScreen mainScreen].bounds.size
#define RGBCOLOR(r, g, b) [UIColor colorWithRed: r/255.f green: g/255.f blue: b/255.f alpha: 1]
#define BUTTONMAGIN 10   // 按钮间距

#define kDestroyButtonTag 1001
#define kNormalButtonTag 2002

@implementation LRActionSheet
{
    ///下面的弹出框
    UIView *actionSheetView;
    ///弹出框上半部分
    UIView *actionSheetTopView;
    ///弹出框下半部分
    UIView *actionSheetBottomView;
}

- (instancetype)initWithTitle:(NSString *)title destroyButtonTitle:(NSString *)destroyTitle otherButtonTitles:(NSArray *)others
{
    self = [super init];
    if(self) {
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        [tap addTarget: self action: @selector(hide)];
        [self addGestureRecognizer: tap];
        // 添加下面的弹出框
        actionSheetView = [[UIView alloc] init];
        actionSheetView.backgroundColor = RGBCOLOR(230, 230, 230);
        CATransition *animation = [CATransition animation];
        animation.duration = 0.2;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [actionSheetView.layer addAnimation: animation forKey: nil];
        [self addSubview: actionSheetView];
        // 弹出框上面添加两部分view
        actionSheetTopView = [[UIView alloc] init];
        actionSheetTopView.frame = CGRectMake(0, 0, SCREENSIZE.width, 45);
        [actionSheetView addSubview: actionSheetTopView];
        
        actionSheetBottomView = [[UIView alloc] init];
        CGFloat height = destroyTitle?(others.count+1)*45+(others.count)*BUTTONMAGIN+BUTTONMAGIN*2:others.count*45+(others.count-1)*BUTTONMAGIN+BUTTONMAGIN*2;
        actionSheetBottomView.frame = CGRectMake(0, 46, SCREENSIZE.width, height);
        [actionSheetView addSubview: actionSheetBottomView];
        
        // 往上半部分视图上添加标题和取消按钮
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.textColor = RGBCOLOR(65, 65, 65);
        titleLabel.font = [UIFont systemFontOfSize: 12.f];
        titleLabel.frame = CGRectMake(0, 0, actionSheetTopView.frame.size.width, actionSheetTopView.frame.size.height);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [actionSheetTopView addSubview: titleLabel];
        //titleLabel.backgroundColor = [UIColor redColor];
        // 取消按钮
        UIButton *btnCancel = [UIButton buttonWithType: UIButtonTypeCustom];
        [btnCancel setBackgroundImage: [UIImage resizedImage: @"btn_menu_titile_p.png"] forState: UIControlStateNormal];
        btnCancel.frame = CGRectMake(actionSheetTopView.frame.size.width - 5 - 47, 5, 47, 45 - 10);
        [btnCancel setTitle: @"取消" forState: UIControlStateNormal];
        [btnCancel setTitleColor: RGBCOLOR(65, 65, 65) forState: UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize: 12];
        [btnCancel addTarget: self action: @selector(hide) forControlEvents: UIControlEventTouchUpInside];
        [actionSheetTopView addSubview: btnCancel];
        
        // 添加上下分割线
        UIImageView *line = [[UIImageView alloc] initWithImage: [UIImage resizedImage: @"line.png"]];
        line.frame = CGRectMake(0, 45, SCREENSIZE.width, 1);
        [actionSheetView addSubview: line];
        
        // 往下半部分视图上添加按钮
        if(destroyTitle) {
            // 有毁灭性按钮
            if(others == nil || others.count == 0) {
                // 没有其他按钮
                UIButton *btnDestroy = [UIButton buttonWithType: UIButtonTypeCustom];
                [btnDestroy setBackgroundImage: [UIImage resizedImage: @"btn_menu_red_n.png"] forState: UIControlStateNormal];
                btnDestroy.frame = CGRectMake(20, BUTTONMAGIN, SCREENSIZE.width-20*2, 45);
                [btnDestroy setTitle: destroyTitle forState: UIControlStateNormal];
                btnDestroy.titleLabel.font = [UIFont systemFontOfSize: 15];
                [btnDestroy addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                
                btnDestroy.tag = kDestroyButtonTag;
                
                [actionSheetBottomView addSubview: btnDestroy];
            } else {
                // 有其他按钮，先加载其他按钮
                for(NSInteger i = 0;i < others.count;i++) {
                    UIButton *btnNormal = [UIButton buttonWithType: UIButtonTypeCustom];
                    [btnNormal setBackgroundImage: [UIImage resizedImage: @"btn_menu_grey_n.png"] forState: UIControlStateNormal];
                    btnNormal.frame = CGRectMake(20, BUTTONMAGIN*(i+1)+45*i, SCREENSIZE.width-20*2, 45);
                    [btnNormal setTitle: others[i] forState: UIControlStateNormal];
                    btnNormal.titleLabel.font = [UIFont systemFontOfSize: 15];
                    [btnNormal addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                    
                    btnNormal.tag = kNormalButtonTag+i;
                    
                    [actionSheetBottomView addSubview: btnNormal];
                }
                // 然后加载毁灭性按钮
                UIButton *btnDestroy = [UIButton buttonWithType: UIButtonTypeCustom];
                [btnDestroy setBackgroundImage: [UIImage resizedImage: @"btn_menu_red_n.png"] forState: UIControlStateNormal];
                btnDestroy.frame = CGRectMake(20, BUTTONMAGIN*(others.count+1)+45*others.count, SCREENSIZE.width-20*2, 45);
                [btnDestroy setTitle: destroyTitle forState: UIControlStateNormal];
                btnDestroy.titleLabel.font = [UIFont systemFontOfSize: 15];
                [btnDestroy addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                
                btnDestroy.tag = kDestroyButtonTag;
                
                [actionSheetBottomView addSubview: btnDestroy];
            }
        } else {
            // 没有毁灭性按钮
            if(others == nil || others.count == 0) {
                // 没有其他按钮
            } else {
                // 有其他按钮，先加载其他按钮
                for(NSInteger i = 0;i < others.count;i++) {
                    UIButton *btnNormal = [UIButton buttonWithType: UIButtonTypeCustom];
                    [btnNormal setBackgroundImage: [UIImage resizedImage: @"btn_menu_grey_n.png"] forState: UIControlStateNormal];
                    btnNormal.frame = CGRectMake(20, BUTTONMAGIN*(i+1)+45*i, SCREENSIZE.width-20*2, 45);
                    [btnNormal setTitle: others[i] forState: UIControlStateNormal];
                    btnNormal.titleLabel.font = [UIFont systemFontOfSize: 15];
                    [btnNormal addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                    
                    btnNormal.tag = kNormalButtonTag+i;
                    
                    [actionSheetBottomView addSubview: btnNormal];
                }
            }
        }
        
        // 毁灭性按钮的tag设为-1
        _destructiveButtonIndex = -1;
    }
    
    return self;
}

- (void)show
{
    [UIView animateWithDuration: 0.2 animations:^{
        // 背景半透明
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.5];
    } completion:^(BOOL finished) {
        
    }];
    
    UIView *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, SCREENSIZE.width, SCREENSIZE.height);
    CGFloat actionSheetHeight = actionSheetTopView.frame.size.height + actionSheetBottomView.frame.size.height;
    actionSheetView.frame = CGRectMake(0, self.frame.size.height - actionSheetHeight, self.frame.size.width, actionSheetHeight);
    [window addSubview: self];
}

- (void)hide
{
    [UIView animateWithDuration: 0.2 animations:^{
        CGRect rect = actionSheetView.frame;
        rect.origin.y += rect.size.height;
        actionSheetView.frame = rect;
        
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

// 按钮点击事件
- (void)buttonAction:(UIButton *)btn
{
    // 点击按钮，提示框消失
    [self hide];
    
    if(btn.tag == kDestroyButtonTag) {
        if([_delegate respondsToSelector: @selector(actionSheet:buttonClickedAtIndex:)]) {
            [_delegate actionSheet: self buttonClickedAtIndex: _destructiveButtonIndex];
        }
    } else if(btn.tag >= kNormalButtonTag) {
        if([_delegate respondsToSelector: @selector(actionSheet:buttonClickedAtIndex:)]) {
            [_delegate actionSheet: self buttonClickedAtIndex: btn.tag - kNormalButtonTag];
        }
    }
}

@end
