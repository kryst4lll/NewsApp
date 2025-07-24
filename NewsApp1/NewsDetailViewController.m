// NewsDetailViewController.m
#import "NewsDetailViewController.h"
#import <WebKit/WebKit.h> // 导入WebKit框架

@interface NewsDetailViewController ()<WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView; // 用于加载详情页URL
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.UIDelegate = self; // 设置UIDelegate
    // 创建自定义配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 允许存储（Cookies、LocalStorage）
    config.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    
    // 允许JavaScript
    config.defaultWebpagePreferences.allowsContentJavaScript = YES;
    
    // 允许媒体自动播放
    config.mediaTypesRequiringUserActionForPlayback = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化WebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    // 利用newsModel中的url加载详情页
    if (self.newsModel && self.newsModel.url) {
        NSURL *detailUrl = [NSURL URLWithString:self.newsModel.url];
        if (detailUrl) {
            NSURLRequest *request = [NSURLRequest requestWithURL:detailUrl];
            [self.webView loadRequest:request];
        }
    }
}

// 处理存储权限请求
- (void)webView:(WKWebView *)webView requestStorageAccessForFrame:(WKFrameInfo *)frame completionHandler:(void (^)(WKPermissionDecision))completionHandler {
    completionHandler(WKPermissionDecisionGrant); // 自动授予权限
}

@end
