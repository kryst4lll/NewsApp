// NewsDetailViewController.m
#import "NewsDetailViewController.h"
#import <WebKit/WebKit.h> // 导入WebKit框架

@interface NewsDetailViewController ()
@property (nonatomic, strong) WKWebView *webView; // 用于加载详情页URL
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1. 初始化WebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    // 2. 利用newsModel中的url加载详情页
    if (self.newsModel && self.newsModel.url) {
        NSURL *detailUrl = [NSURL URLWithString:self.newsModel.url];
        if (detailUrl) {
            NSURLRequest *request = [NSURLRequest requestWithURL:detailUrl];
            [self.webView loadRequest:request];
        }
    }
}

@end
