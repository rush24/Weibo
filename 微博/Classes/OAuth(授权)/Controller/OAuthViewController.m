//
//  OAuthViewController.m
//  微博
//
//  Created by 张智勇 on 15/12/5.
//  Copyright © 2015年 张智勇. All rights reserved.
//

#import "OAuthViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ControllerTool.h"
#import "Account.h"
#import "AccountTool.h"

@interface OAuthViewController ()<UIWebViewDelegate>

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",AppKey,RedirectURL];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    webView.delegate = self;
}

#pragma mark - UIWebViewDelegate
/**
 *  webView每当发一次请求都会调用这个代理方法
 *
 *  @param webView
 *  @param request
 *  @param navigationType
 *
 *  @return YES:允许加载 NO:禁止加载
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:[NSString stringWithFormat:@"%@/?code=",RedirectURL]];
    if(range.location != NSNotFound){
        int from = range.location + range.length;
        NSString *code = [url substringFromIndex:from];
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}

#pragma mark - UIWebViewDelegate
/**
 *  UIWebView开始加载资源的时候调用(开始发送请求)
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中..."];
}

/**
 *  UIWebView加载完毕的时候调用(请求完毕)
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

/**
 *  UIWebView加载失败的时候调用(请求失败)
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

- (void)accessTokenWithCode:(NSString *)code{
    
    //封装请求参数
    AccessTokenParam *param = [[AccessTokenParam alloc]init];
    param.client_id = AppKey;
    param.client_secret = AppSecret;
    param.redirect_uri = RedirectURL;
    param.grant_type = @"authorization_code";
    param.code = code;
    
    //获得accesToken
    [AccountTool accessTokeWithParam:param success:^(Account *account) {
        
        [MBProgressHUD hideHUD];
        // 存储帐号模型
    
        [AccountTool save:account];
        //切换控制器
        [ControllerTool chooseRootViewController];
    } failure:^(NSError *erroe) {
        NSLog(@"存储账号失败");
        [MBProgressHUD hideHUD];
    }];
    
}

@end









