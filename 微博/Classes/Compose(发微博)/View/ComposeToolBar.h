//
//  ComposeToolBar.h
//  微博
//
//  Created by 张智勇 on 15/12/8.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ComposeToolbarButtonTypeCamera, // 照相机
    ComposeToolbarButtonTypePicture, // 相册
    ComposeToolbarButtonTypeMention, // 提到@
    ComposeToolbarButtonTypeTrend, // 话题
    ComposeToolbarButtonTypeEmotion // 表情
}ComposeToolBarButtonType;

@class ComposeToolBar;

@protocol ComposeToolBarDelegate <NSObject>

@optional
- (void)composeTool:(ComposeToolBar *)toolbar didClickedButton:(ComposeToolBarButtonType)buttonType;

@end

@interface ComposeToolBar : UIView
@property(nonatomic,weak) id<ComposeToolBarDelegate>delegate;
//是否显示表情按钮
@property(nonatomic,assign,getter = isShowEmotionButton) BOOL showEmotionButton;
@end
