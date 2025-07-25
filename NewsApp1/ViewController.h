//
//  ViewController.h
//  NewsApp1
//
//  Created by yyh on 2025/7/23.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NewsModel *> *newsList; // 新闻数据数组

- (void)saveFavoriteStatus;

@end

