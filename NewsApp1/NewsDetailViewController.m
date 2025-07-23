//
//  NewsDetailViewController.m
//  newsApp
//
//  Created by yyh on 2025/7/23.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新闻详情";
    
    // 大图
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.image = _newsImage;
    [self.view addSubview:_imageView];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"新闻"; // 设置传入的标题
    [self.view addSubview:_titleLabel];
    
    // 内容
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont boldSystemFontOfSize:16];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = _newsContent;
    [self.view addSubview:_contentLabel];

    // 设置约束（Auto Layout）
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 大图（顶部 + 左右撑满，高度固定）
        [_imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [_imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_imageView.heightAnchor constraintEqualToConstant:200],
        
        // 标题（在大图下方，左右有边距）
        [_titleLabel.topAnchor constraintEqualToAnchor:_imageView.bottomAnchor constant:20],
        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [_titleLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        
        // 内容（在标题下方）
        [_contentLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:10],
        [_contentLabel.leadingAnchor constraintEqualToAnchor:_titleLabel.leadingAnchor],
        [_contentLabel.trailingAnchor constraintEqualToAnchor:_titleLabel.trailingAnchor],
        [_contentLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20]
    ]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
