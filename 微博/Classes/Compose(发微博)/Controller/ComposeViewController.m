//
//  ComposeViewController.m
//  微博
//
//  Created by 张智勇 on 15/9/11.
//  Copyright (c) 2015年 张智勇. All rights reserved.
//

#import "ComposeViewController.h"
#import "EmotionView.h"
#import "ComposeToolBar.h"
#import "ComposePhotosView.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "StatusTool.h"
#import "EmotionKeyboard.h"
#import "Emotion.h"
#import "EmotionTextView.h"

@interface ComposeViewController()<ComposeToolBarDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,weak)EmotionTextView *textView;
@property(nonatomic,weak)ComposeToolBar *toolBar;
@property(nonatomic,weak)ComposePhotosView *photosView;
@property(nonatomic,assign,getter=isChangingKerboard) BOOL changingKeyboard;
@property(nonatomic,strong)EmotionKeyboard *keyboard;//懒加载必须用强指针
@end

@implementation ComposeViewController

/**
 *  keyboard懒加载
 *
 *  @return
 */
- (EmotionKeyboard *)keyboard{
    if(!_keyboard){
        //懒加载中不能不能调用get方法，会死循环，但此处实际上用的是set方法
        self.keyboard = [EmotionKeyboard keyboard];
        self.keyboard.width = ScreenW;
        self.keyboard.height = 216;
    }
    return _keyboard;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    //设置导航栏内容
    [self setNavBar];
    
    //添加输入控件
    [self setTextView];
    
    //添加发微博工具条
    [self setToolBar];
    
    //添加相册视图
    [self setPhotosView];
    
    //监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:EmotionDidSelectedNotification object:nil];
    //监听表情删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:EmotionDidDeletedNotification object:nil];
}

/**
 *  发微博工具条
 */
- (void)setToolBar{
    ComposeToolBar *toolBar = [[ComposeToolBar alloc]init];
    toolBar.width = self.view.width;
    toolBar.height = 44;
    toolBar.delegate = self;
    self.toolBar = toolBar;
    
    //显示
    toolBar.y = self.view.height - toolBar.height;
    [self.view addSubview:toolBar];
}

/**
 *  添加输入控件
 */
- (void)setTextView{
    EmotionTextView *textView  = [[EmotionTextView alloc]init];
    textView.alwaysBounceVertical = YES;//能拖拽
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    self.textView = textView;
    
    textView.delegate = self;//成为textview（也就是UIScrollView）代理
    
    textView.placehoder = @"分享新鲜事...";
    textView.font = [UIFont systemFontOfSize:15];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  添加相册视图
 */
- (void)setPhotosView{
    ComposePhotosView *photosView = [[ComposePhotosView alloc]init];
    photosView.width = self.textView.width;
    photosView.height = self.textView.height;
    photosView.y = 70;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

/**
 *  view显示完毕的时候再弹出键盘，避免显示控制器view的时候会卡住
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（叫出键盘）
    [self.textView becomeFirstResponder];
}

/**
 *  view关闭前先退出键盘
 */
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

/**
 *  设置导航栏内容
 */
- (void)setNavBar{
    NSString *name = [AccountTool account].name;
    if(name){
        //构建文字
        NSString *prefix = @"发微博";
        NSString *text = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[text rangeOfString:prefix]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[text rangeOfString:name]];
        
        //创建label
        UILabel *label = [[UILabel alloc]init];
        label.attributedText = string;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.width = 100;
        label.height = 44;
        self.navigationItem.titleView = label;
        
    }else{
        self.title = @"发微博";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send{
    //发送有图片微博
    if(self.photosView.images.count){
        [self sendStatusWithImage];
    }else{//发送无图片微博
        [self sendStatusWithoutImage];
    }
    //关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发送有图片微博
 */
- (void)sendStatusWithImage{
    
    //封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
//    //发送post请求
//    [HttpTool post:@"https://upload.api.weibo.com/2/statuses/upload.json" params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        UIImage *image = [self.photosView.images firstObject];
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"status.jpg" mimeType:@"image/jpeg"];
//    } success:^(id responseObj) {
//        
//        [MBProgressHUD showSuccess:@"发表成功"];
//    } failure:^(NSError *error) {
//        
//        [MBProgressHUD showError:@"发表失败"];
//    }];
    
}

/**
 *  发送无图片微博
 */
- (void)sendStatusWithoutImage{
    
    //封装请求参数
    SendStatusParam *param = [SendStatusParam param];
    param.status = self.textView.realText;
    
    //发送POST请求
    [StatusTool sendStatusesWithParam:param success:^(SendStatusResult *result) {
        [MBProgressHUD showSuccess:@"发表成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发表失败"];
    }];
}

#pragma mark - 键盘处理
/**
 *  当键盘将要出现时
 *
 *  @param note
 */
- (void)keyboardWillShow:(NSNotification *)note{
    //键盘弹出所需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        //取出键盘高度
        CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardFrame.size.height;
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
}

/**
 *  当键盘将要隐藏时
 *
 *  @param note
 */
- (void)keyboardWillHide:(NSNotification *)note{
    
    if(self.isChangingKerboard){
        return;
    }
    //键盘弹出所需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


/**
 *  当textview文字改变时调用
 *
 *  @param textView 
 */
- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}


#pragma mark - ComposeToolBarDelegate
/**
 *  监听toolbar内部按钮点击
 *
 *  @param toolbar
 *  @param buttonType
 */
- (void)composeTool:(ComposeToolBar *)toolbar didClickedButton:(ComposeToolBarButtonType)buttonType{
    switch (buttonType) {
        case ComposeToolbarButtonTypeCamera:
            [self openCamera];//打开相机
            break;
        
        case ComposeToolbarButtonTypePicture:
            [self openAlbum];//打开相册
            break;
            
        case ComposeToolbarButtonTypeEmotion:
            [self openEmotion];//打开表情
            break;
            
        default:
            break;
    }
}

//打开相机
- (void)openCamera{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])    return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

//打开相册
- (void)openAlbum{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])    return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

//打开表情
- (void)openEmotion{
    self.changingKeyboard = YES;
    
    if(self.textView.inputView){//如果当前是自定义键盘，切换为系统键盘
        self.textView.inputView = nil;
        self.toolBar.showEmotionButton = YES;
        
    }else{
        self.textView.inputView = self.keyboard;
        self.toolBar.showEmotionButton = NO;
    }
    //关闭键盘
    [self.textView resignFirstResponder];
    
    self.changingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //打开键盘
        [self.textView becomeFirstResponder];
    });
}

/**
 *  当选中表情时调用
 *
 *  @param note 里面包含选中的表情
 */
- (void)emotionDidSelected:(NSNotification *)note{
    Emotion *emotion = note.userInfo[SelectedEmotion];
    
    //拼接表情
    [self.textView appendEmotion:emotion];
    
    //检测文字长度
    [self textViewDidChange:self.textView];
}

/**
 *  当点击表情键盘上的删除按钮时调用
 */
- (void)emotionDidDeleted:(NSNotification *)note
{
    [self.textView deleteBackward];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //取出选中图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //添加图片到相册视图
    [self.photosView addImage:image];
}

@end









