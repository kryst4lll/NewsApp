//
//  ViewController.m
//  newsApp
//
//  Created by yyh on 2025/7/22.
//

#import "ViewController.h"
#import "NewsCollectionViewCell.h"
#import "NewsDetailViewController.h"
#import "NewsModel.h"
#import "FavoriteViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ViewController

- (instancetype)init{
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据数组
//    self.newsList = [NSMutableArray array];
    self.newsList = [NSMutableArray arrayWithCapacity:0];
    // 获取新闻数据
    [self fetchNewsData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 140);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[NewsCollectionViewCell class] forCellWithReuseIdentifier:@"id"];
    
    
    [self.view addSubview:self.collectionView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"heart.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(showFavoritePage)];
    
    // 注册通知监听：监听收藏状态变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFavoriteStatusChanged:)
                                                 name:@"NewsFavoriteStatusChanged"
                                               object:nil];
    
}
// 接收通知，更新主页面状态
- (void)onFavoriteStatusChanged:(NSNotification *)notification {
    NSString *changedNewsId = notification.userInfo[@"newsId"];
    if (!changedNewsId) return; // 安全校验：避免空ID
    
    // 遍历主页面数据源，更新状态（增加越界防护）
    for (NSInteger i = 0; i < self.newsList.count; i++) { // 用for循环而非for-in，方便索引操作
        NewsModel *news = self.newsList[i];
        if ([news.newsId isEqualToString:changedNewsId]) {
            news.isFavorite = NO; // 更新为未收藏
            
            // 局部刷新：只刷新当前修改的单元格（避免全局刷新的潜在问题）
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            return; // 找到后立即返回，避免无效循环
        }
    }
}

// 页面销毁时移除通知监听（避免内存泄漏）
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NewsFavoriteStatusChanged"
                                                  object:nil];
}




// 获取新闻数据
- (void)fetchNewsData {
    // 显示加载指示器
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    // 构建请求URL
    NSString *apiKey = @"d5c296b91907"; 
    NSString *urlString = [NSString stringWithFormat:@"https://whyta.cn/api/toutiao?key=%@", apiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"请求URL: %@", urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        });
        
        // 检查错误
        if (error) {
            NSLog(@"请求错误: %@", error.localizedDescription);
            return;
        }
        
        // 打印原始数据
        if (data) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"返回数据: %@", dataString);
            
            // 解析JSON
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonDict isKindOfClass:[NSDictionary class]]) {
                NSString *status = jsonDict[@"status"];
                NSLog(@"请求状态: %@", status);
                
                if ([status isEqualToString:@"success"]) {
                    NSArray *items = jsonDict[@"items"];
                    NSLog(@"items 数量: %ld", items.count);
                    
                    if (items && [items isKindOfClass:[NSArray class]] && items.count > 0) {
                        [self.newsList removeAllObjects];
                        
                        for (NSDictionary *itemDict in items) {
                            NewsModel *newsModel = [[NewsModel alloc] initWithDictionary:itemDict];
                            newsModel.isFavorite = NO;
                            [self.newsList addObject:newsModel];
                            
                            // 打印每个新闻的标题和图片URL
                            NSLog(@"新闻标题: %@", newsModel.title);
//                            NSLog(@"图片URL: %@", newsModel.imageUrl);
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"准备刷新，当前新闻数量: %ld", self.newsList.count); // 确认此时数量 > 0
                            NSLog(@"CollectionView 是否存在: %@", self.collectionView ? @"是" : @"否");
                            [self.collectionView reloadData];
                            NSLog(@"刷新后，CollectionView 可见单元格数量: %ld", self.collectionView.visibleCells.count);
                        });
                    } else {
                        NSLog(@"items 为空或格式错误");
                    }
                }
                else if([status isEqualToString:@"cache"]){
                    NSArray *items = jsonDict[@"items"];
                    // 新增日志：确认items是否存在及数量
                    NSLog(@"cache状态 - items数量: %ld", items.count);
                    
                    if (items && [items isKindOfClass:[NSArray class]] && items.count > 0) {
                        [self.newsList removeAllObjects];
                        for (NSDictionary *itemDict in items) {
                            NewsModel *newsModel = [[NewsModel alloc] initWithDictionary:itemDict];
                            newsModel.isFavorite = NO;
                            [self.newsList addObject:newsModel];
                            // 打印每个新闻的图片 URL
                            NSLog(@"新闻标题: %@，图片 URL: %@", newsModel.title, newsModel.imageUrl);
                        }
                        // 新增日志：确认self.newsList是否被填充
                        NSLog(@"cache状态 - 解析完成，newsList数量: %ld", self.newsList.count);
                        
                        // 刷新列表（主线程）
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 新增日志：确认刷新方法被调用
                            NSLog(@"cache状态 - 执行reloadData，当前newsList数量: %ld", self.newsList.count);
                            [self.collectionView reloadData];
                        });
                    }
                }
                else {
                    NSLog(@"请求失败，状态: %@", status);
                }
            } else {
                NSLog(@"JSON解析错误: %@", jsonError.localizedDescription);
            }
        } else {
            NSLog(@"返回数据为空");
        }
    }];
    
    [task resume];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 10;
    NSLog(@"numberOfItemsInSection: %ld", self.newsList.count);
    return self.newsList.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];

    // 获取新闻模型
    NewsModel *newsModel = self.newsList[indexPath.item];
    
    // 设置标题
    cell.titleLabel.text = newsModel.title;
    
    if (!newsModel.imageUrl || [newsModel.imageUrl isEqualToString:@"https://whyta.cn"]){
        cell.newsImageView.image = [UIImage systemImageNamed:@"newspaper"];
//        return cell;
    }
    
    // 加载图片（使用异步加载，避免阻塞主线程）
    else if (newsModel.imageUrl) {
        cell.newsImageView.image = [UIImage systemImageNamed:@"photo"]; // 加载中占位图
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSURL *imageUrl = [NSURL URLWithString:newsModel.imageUrl];
//            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            // 获取真实图片 URL
            NSString *realUrlString = [newsModel realImageUrl];
            NSURL *imageUrl = [NSURL URLWithString:realUrlString];
            if (!imageUrl) {
                NSLog(@"无效的图片 URL: %@", realUrlString);
                return;
            }

            // 请求真实图片 URL
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                newsModel.image = image;
                
                // 更新UI（在主线程中执行）
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 检查单元格是否仍然显示同一新闻
                    NewsModel *currentModel = self.newsList[indexPath.item];
                    if (currentModel == newsModel) {
                        cell.newsImageView.image = image;
                    }
                });
            }
            else {
//                NSLog(@"图片数据为空，URL: %@", newsModel.imageUrl);
            }
        });
    }
    
    // 设置收藏状态
    [cell setFavoriteState:newsModel.isFavorite];
    
    // 设置收藏按钮回调
    __weak typeof(self) weakSelf = self;
    cell.favoriteButtonTapped = ^(BOOL isSelected) {
        NSLog(@"回调一个收藏");
        [weakSelf handleFavoriteForNews:newsModel atIndexPath:indexPath isSelected:isSelected];
    };
    
    return cell;
}


// 处理收藏操作
- (void)handleFavoriteForNews:(NewsModel *)newsModel atIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    // 更新模型状态
    newsModel.isFavorite = isSelected;
    
    // 保存收藏状态到本地（示例：用 NSUserDefaults）
    [self saveFavoriteStatus];
    
    // 显示提示
    NSString *message = isSelected ? @"已收藏" : @"已取消收藏";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

// 保存收藏状态到本地
- (void)saveFavoriteStatus {
    // 将收藏的新闻ID存入 NSUserDefaults
    NSMutableArray *favoriteIds = [NSMutableArray array];
    for (NewsModel *news in self.newsList) {
        if (news.isFavorite) {
            [favoriteIds addObject:news.newsId];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:favoriteIds forKey:@"FavoriteNewsIds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"保存收藏成功，数量: %ld，IDs: %@", favoriteIds.count, favoriteIds);
}

// 从本地加载收藏状态（在 viewDidLoad 中调用）
- (void)loadFavoriteStatus {
    NSArray *favoriteIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"FavoriteNewsIds"];
    if (favoriteIds) {
        for (NewsModel *news in self.newsList) {
            news.isFavorite = [favoriteIds containsObject:news.newsId];
        }
    }
}

// 添加跳转到收藏页面的方法
- (void)showFavoritePage {
    FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self.navigationController pushViewController:favoriteVC animated:YES];
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前点击的新闻模型
    NewsModel *selectedNews = self.newsList[indexPath.item];
    
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];
//    detailVC.title = [NSString stringWithFormat:@"%@", @(indexPath.row)];
//    detailVC.newsTitle = [NSString stringWithFormat:@"新闻标题 %ld", (long)indexPath.row];
//    detailVC.newsContent = @"这里是新闻的详细内容，可以是多行文本。实际开发中应从网络或数据库加载。";
//    detailVC.newsImage = [UIImage systemImageNamed:@"house"];
    detailVC.newsModel = selectedNews;
    
//    detailVC.title = selectedNews.title;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
