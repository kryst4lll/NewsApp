//
//  FavoriteViewController.h
//  NewsApp1
//
//  Created by yyh on 2025/7/24.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<NewsModel *> *favoriteNews; // 收藏的新闻数据

@end

NS_ASSUME_NONNULL_END
