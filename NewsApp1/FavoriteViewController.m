//
//  FavoriteViewController.m
//  NewsApp1
//
//  Created by yyh on 2025/7/24.
//

#import "FavoriteViewController.h"
#import "NewsCollectionViewCell.h"
#import "NewsModel.h"
#import "ViewController.h"
#import "NewsDetailViewController.h"

@interface FavoriteViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation FavoriteViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.favoriteNews = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收藏";
    
//    NSLog(@"collectionView 是否存在: %@", self.collectionView ? @"是" : @"否");
//    NSLog(@"collectionView 是否在视图层级中: %@", [self.collectionView isDescendantOfView:self.view] ? @"是" : @"否");
//       
//    NSLog(@"collectionView 是否隐藏: %@", self.collectionView.hidden ? @"是" : @"否");
//    NSLog(@"collectionView alpha 值: %f", self.collectionView.alpha);
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 设置CollectionView布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width - 30, 140);
    layout.minimumLineSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.collectionView.collectionViewLayout = layout;
    
    // 注册单元格
    [self.collectionView registerClass:[NewsCollectionViewCell class] forCellWithReuseIdentifier:@"FavoriteCell"];
    
    
    // 加载收藏数据
    [self loadFavoriteNews];
    
    // 删除后检查是否为空
    [self checkEmptyState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 每次进入页面时，重新加载收藏数据
    [self loadFavoriteNews];
    
    [self checkEmptyState];
}

- (void)loadFavoriteNews {
    self.favoriteNews = [NSMutableArray array];
    
    // 获取保存的收藏ID
    NSArray *favoriteIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"FavoriteNewsIds"];
    if (!favoriteIds || favoriteIds.count == 0) {
        NSLog(@"没有收藏的新闻");
        return;
    }
    
    // 关键：从标签栏控制器中找到“首页”的导航控制器
    UITabBarController *tabBarVC = (UITabBarController *)self.navigationController.parentViewController;
    if (!tabBarVC) {
        NSLog(@"未找到标签栏控制器");
        return;
    }
    
    // 假设“首页”是标签栏的第一个控制器（index 0）
    UINavigationController *mainNav = tabBarVC.viewControllers[0];
    if (!mainNav) {
        NSLog(@"未找到首页导航控制器");
        return;
    }
    
    // 从首页导航控制器中获取 ViewController
    ViewController *mainVC = (ViewController *)mainNav.viewControllers.firstObject;
    if (![mainVC isKindOfClass:[ViewController class]]) {
        NSLog(@"主页面不是 ViewController 类型");
        return;
    }
    
    // 安全获取所有新闻数据
    NSArray *allNews = mainVC.newsList;
    if (!allNews) {
        NSLog(@"主页面新闻列表为空");
        return;
    }
    
    // 匹配收藏的新闻
    for (NSString *newsId in favoriteIds) {
        for (NewsModel *news in allNews) {
            if ([news.newsId isEqualToString:newsId]) {
                [self.favoriteNews addObject:news];
                NSLog(@"加载一个收藏成功");
                break;
            }
        }
    }
    
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"收藏页面单元格数量: %ld", self.favoriteNews.count); // 关键日志
    return self.favoriteNews.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteCell" forIndexPath:indexPath];

    // 获取新闻模型
    NewsModel *newsModel = self.favoriteNews[indexPath.item];
    
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
                    NewsModel *currentModel = self.favoriteNews[indexPath.item];
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
    
    [cell setFavoriteState:YES];
    // 设置收藏按钮回调
    __weak typeof(self) weakSelf = self;
    cell.favoriteButtonTapped = ^(BOOL isSelected) {
        NSLog(@"回调一个收藏");
        [weakSelf handleFavoriteForNews:newsModel atIndexPath:indexPath isSelected:NO];
    };
    
    return cell;
}



// 保存收藏状态到本地
- (void)saveFavoriteStatus {
    // 将收藏的新闻ID存入 NSUserDefaults
    NSMutableArray *favoriteIds = [NSMutableArray array];
    for (NewsModel *news in self.favoriteNews) {
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
        for (NewsModel *news in self.favoriteNews) {
            news.isFavorite = [favoriteIds containsObject:news.newsId];
        }
    }
}

// 处理取消收藏
- (void)handleFavoriteForNews:(NewsModel *)newsModel atIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    // 1. 先更新模型状态
    newsModel.isFavorite = isSelected;
    
    // 2. 先从数据源中移除（关键：必须在删除 UI 前执行）
    NSInteger beforeCount = self.favoriteNews.count;
    [self.favoriteNews removeObject:newsModel];
    NSInteger afterCount = self.favoriteNews.count;
    NSLog(@"删除前数量: %ld, 删除后数量: %ld, 待删除indexPath: %@", beforeCount, afterCount, indexPath);
    
    // 3. 确保删除操作在主线程执行（关键：UI 操作必须在主线程）
    dispatch_async(dispatch_get_main_queue(), ^{
        // 4. 校验 indexPath 是否有效（防止越界）
        if (indexPath.item < beforeCount) {
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } else {
            NSLog(@"indexPath 无效，跳过删除");
            [self.collectionView reloadData]; // 无效时强制刷新
        }
        
        // 5. 如果数据源为空，额外刷新一次（可选，确保 UI 同步）
        if (afterCount == 0) {
            [self.collectionView reloadData];
        }
    });
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"已取消收藏" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    // 6. 更新本地存储和发送通知（原有逻辑）
    [self updateLocalFavoriteData:newsModel];
    NSDictionary *userInfo = @{@"newsId": newsModel.newsId};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsFavoriteStatusChanged" object:nil userInfo:userInfo];
}



// 更新本地存储
- (void)updateLocalFavoriteData:(NewsModel *)newsModel {
    NSMutableArray *favoriteIds = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FavoriteNewsIds"] mutableCopy];
    if (!favoriteIds) favoriteIds = [NSMutableArray array];
    [favoriteIds removeObject:newsModel.newsId];
    [[NSUserDefaults standardUserDefaults] setObject:favoriteIds forKey:@"FavoriteNewsIds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前点击的新闻模型
    NewsModel *selectedNews = self.favoriteNews[indexPath.item];
    
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];

    detailVC.newsModel = selectedNews;

    [self.navigationController pushViewController:detailVC animated:YES];
}

// 检查空状态，避免空数组操作
- (void)checkEmptyState {
    if (self.favoriteNews.count == 0) {
        NSLog(@"收藏列表已为空");
        
        // 1. 创建空视图容器（铺满整个CollectionView）
        UIView *emptyView = [[UIView alloc] init];
        emptyView.frame = self.collectionView.bounds;
        emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // 随父视图拉伸
        
        // 2. 创建居中标签
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂无收藏的新闻";
        label.textAlignment = NSTextAlignmentCenter;
        label.translatesAutoresizingMaskIntoConstraints = NO; // 禁用自动转换frame为约束
        [emptyView addSubview:label];
        
        // 3. 添加自动布局约束：让label在emptyView中居中
        [NSLayoutConstraint activateConstraints:@[
            // 水平居中
            [label.centerXAnchor constraintEqualToAnchor:emptyView.centerXAnchor],
            // 垂直居中
            [label.centerYAnchor constraintEqualToAnchor:emptyView.centerYAnchor],
            // 可选：限制标签宽度（避免文字过长溢出）
            [label.leadingAnchor constraintGreaterThanOrEqualToAnchor:emptyView.leadingAnchor constant:20],
            [label.trailingAnchor constraintLessThanOrEqualToAnchor:emptyView.trailingAnchor constant:-20]
        ]];
        
        // 4. 设置CollectionView的背景视图
        self.collectionView.backgroundView = emptyView;
    } else {
        self.collectionView.backgroundView = nil; // 有数据时隐藏
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}




#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
