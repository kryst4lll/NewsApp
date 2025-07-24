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

- (void)setupUI {
    // 1. 容器样式
    self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    
    // 2. 图片视图（右侧）
    self.newsImageView = [[UIImageView alloc] init];
    self.newsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.newsImageView.contentMode = UIViewContentModeScaleAspectFit; // 关键修改点
    self.newsImageView.clipsToBounds = YES;
    self.newsImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.newsImageView];
    
    // 3. 标题标签（左侧）
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.titleLabel];
    
    // 4. 动态约束
    [NSLayoutConstraint activateConstraints:@[
        // 图片视图（右侧动态宽高）
        [self.newsImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        [self.newsImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.newsImageView.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:0.8],
        [self.newsImageView.widthAnchor constraintEqualToAnchor:self.newsImageView.heightAnchor multiplier:1.33], // 默认4:3
        
        // 标题标签（左侧自适应）
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.newsImageView.leadingAnchor constant:-10]
    ]];
}



@end
