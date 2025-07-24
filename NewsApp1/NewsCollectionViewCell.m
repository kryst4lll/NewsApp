//
//  NewsCollectionViewCell.m
//  newsApp
//
//  Created by yyh on 2025/7/23.
//

#import "NewsCollectionViewCell.h"

@implementation NewsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI]; // 统一管理布局
    }
    return self;
}

// 单独抽取UI设置方法，便于维护
- (void)setupUI {
    // 1. 配置容器背景
    self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    
    // 2. 创建图片视图（右侧）
    self.newsImageView = [[UIImageView alloc] init];
    self.newsImageView.translatesAutoresizingMaskIntoConstraints = NO; // 禁用自动布局
    self.newsImageView.contentMode = UIViewContentModeScaleAspectFill; // 保持比例填充
    self.newsImageView.clipsToBounds = YES; // 裁剪超出部分
    self.newsImageView.backgroundColor = [UIColor clearColor]; // 占位背景
    [self.contentView addSubview:self.newsImageView];
    
    // 3. 创建标题标签（左侧）
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.numberOfLines = 0; // 自动换行
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail; // 超出部分省略
    [self.contentView addSubview:self.titleLabel];
    
    // 4. 约束布局（核心调整）
    [NSLayoutConstraint activateConstraints:@[
        // 图片视图约束（右侧）
        [self.newsImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10], // 右边缘距10
        [self.newsImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor], // 垂直居中
        [self.newsImageView.widthAnchor constraintEqualToConstant:100], // 图片宽度（增大减少裁剪）
        [self.newsImageView.heightAnchor constraintEqualToConstant:80], // 图片高度（减少裁剪）
        
        // 标题标签约束（左侧）
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10], // 左边缘距10
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10], // 上边缘距10
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10], // 下边缘距10
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.newsImageView.leadingAnchor constant:-10] // 与图片间距10
    ]];
}



@end
