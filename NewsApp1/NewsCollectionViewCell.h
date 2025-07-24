//
//  NewsCollectionViewCell.h
//  newsApp
//
//  Created by yyh on 2025/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *thumbnailImageView; // 新闻缩略图
@property (nonatomic, strong) UILabel *titleLabel;             // 标题
@property (nonatomic, strong) UILabel *timeLabel;              // 发布时间

@property (nonatomic, strong) UIImageView *newsImageView;
//@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
