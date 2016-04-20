//
//  ViewController.m
//  NJKWebViewProgressDemo
//
//  Created by 时双齐 on 16/4/20.
//  Copyright © 2016年 亿信互联. All rights reserved.
//

#import "ViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "SVProgressHUD.h"

@interface ViewController ()<NJKWebViewProgressDelegate,UIWebViewDelegate>

@property(nonatomic,strong)NJKWebViewProgress *progressProxy;
@property(nonatomic,strong)NJKWebViewProgressView *webViewProgressView;
@property (strong, nonatomic)UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
}

//懒加载
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置加载进度条
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    
    [self loadString:@"http://www.baidu.com/"];
    
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    
//    [SVProgressHUD show];
//    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    [SVProgressHUD showImage:[UIImage imageNamed:@"Oval1"] status:@"加载成功"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

//加载网页
-(void)loadString:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:NO];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}



@end
