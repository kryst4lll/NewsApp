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
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 1. 缩略图
    _thumbnailImageView = [[UIImageView alloc] init];
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnailImageView.clipsToBounds = YES;
    _thumbnailImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_thumbnailImageView];
    
    // 2. 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.numberOfLines = 3;
    [self.contentView addSubview:_titleLabel];
    
    // 3. 发布时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
    
    // 设置约束（Auto Layout）
    _thumbnailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 缩略图（右侧，固定宽度，上下贴边）
        [_thumbnailImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_thumbnailImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [_thumbnailImageView.widthAnchor constraintEqualToConstant:120], // 缩略图宽度
        [_thumbnailImageView.heightAnchor constraintEqualToConstant:120], // 缩略图高度
        [_thumbnailImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor],
        
        // 标题（左侧，距离缩略图有间距）
        [_titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [_titleLabel.trailingAnchor constraintEqualToAnchor:_thumbnailImageView.leadingAnchor constant:-10], // 与缩略图保持间距
        
        // 发布时间（左侧，贴着 Cell 底部）
        [_timeLabel.leadingAnchor constraintEqualToAnchor:_titleLabel.leadingAnchor],
        [_timeLabel.trailingAnchor constraintEqualToAnchor:_titleLabel.trailingAnchor],
        [_timeLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10], // 贴着底部，距离 10pt
        [_timeLabel.topAnchor constraintGreaterThanOrEqualToAnchor:_titleLabel.bottomAnchor constant:5] // 至少距离标题 5pt
    ]];
}

//- (void)configureWithNews:(NewsModel *)news {
//    self.titleLabel.text = news.title;
//
//    // 加载网络图片（使用 SDWebImage）
//    if (news.imageUrl) {
//        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:news.imageUrl]
//                                  placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    } else {
//        self.thumbnailImageView.image = [UIImage imageNamed:@"placeholder"];
//    }
//}

@end
