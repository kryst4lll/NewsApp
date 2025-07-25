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
    self.contentView.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    
    // 2. 图片视图（右侧）
    self.newsImageView = [[UIImageView alloc] init];
    self.newsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.newsImageView.contentMode = UIViewContentModeScaleAspectFit; 
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
    
    // 创建收藏按钮
    self.favoriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.favoriteButton.frame = CGRectMake(10, 0, 20, 20);
    [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateSelected];
    [self.favoriteButton addTarget:self action:@selector(favoriteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favoriteButton];
    
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
    
    // 5. 添加分隔线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.separatorLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0]; // 灰色分隔线
    [self.contentView addSubview:self.separatorLine];
    
    // 分隔线约束（底部全宽，高度1pt）
    [NSLayoutConstraint activateConstraints:@[
        [self.separatorLine.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor], // 与标题左对齐
        [self.separatorLine.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10], // 与右侧间隔10pt
        [self.separatorLine.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor], // 底部对齐
        [self.separatorLine.heightAnchor constraintEqualToConstant:1] // 线高1pt
    ]];
}

// 按钮点击事件
- (void)favoriteButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.favoriteButtonTapped) {
        self.favoriteButtonTapped(sender.selected); // 回调给控制器
    }
}

// 设置收藏状态
- (void)setFavoriteState:(BOOL)isFavorite {
    self.favoriteButton.selected = isFavorite;
}

- (void)setSeparatorHidden:(BOOL)hidden {
    self.separatorLine.hidden = hidden;
}

@end
