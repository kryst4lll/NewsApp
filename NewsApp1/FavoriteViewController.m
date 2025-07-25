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
        return cell;
    }
    
    // 加载图片（使用异步加载，避免阻塞主线程）
    if (newsModel.imageUrl) {
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

// 处理收藏操作
//- (void)handleFavoriteForNews:(NewsModel *)newsModel atIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
//    // 更新模型状态
//    newsModel.isFavorite = isSelected;
//    
//    // 保存收藏状态到本地（示例：用 NSUserDefaults）
//    [self saveFavoriteStatus];
//    
//    // 显示提示
//    NSString *message = isSelected ? @"已收藏" : @"已取消收藏";
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//        [self presentViewController:alert animated:YES completion:nil];
//    });
//}

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
    newsModel.isFavorite = isSelected;
    [self updateLocalFavoriteData:newsModel];
    [self.favoriteNews removeObject:newsModel];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    // 2. 发送通知：携带取消收藏的新闻ID
    NSDictionary *userInfo = @{@"newsId": newsModel.newsId};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsFavoriteStatusChanged"
                                                        object:nil
                                                      userInfo:userInfo];
    
    // 提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"已取消收藏" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
//    // 步骤1：获取当前的UITabBarController（底边栏控制器）
//    UITabBarController *tabBarVC = (UITabBarController *)self.navigationController.parentViewController;
//
//    // 步骤2：遍历底边栏的子控制器，找到主页面（ViewController）
//    ViewController *mainVC = nil;
//    if (tabBarVC) {
//        for (UIViewController *vc in tabBarVC.viewControllers) {
//            // 底边栏的子控制器通常是导航控制器（UINavigationController）
//            if ([vc isKindOfClass:[UINavigationController class]]) {
//                UINavigationController *nav = (UINavigationController *)vc;
//                // 导航控制器的根控制器可能是主页面
//                if ([nav.viewControllers.firstObject isKindOfClass:[ViewController class]]) {
//                    mainVC = (ViewController *)nav.viewControllers.firstObject;
//                    break;
//                }
//            }
//        }
//    }
//    
//    // 步骤3：更新主页面的收藏状态（安全判断，避免nil）
//    if (mainVC && mainVC.newsList) {
//        for (NewsModel *mainNews in mainVC.newsList) {
//            if ([mainNews.newsId isEqualToString:newsModel.newsId]) {
//                mainNews.isFavorite = NO; // 取消收藏
//                break;
//            }
//        }
//        [mainVC.collectionView reloadData]; // 刷新主页面
//    } else {
//        NSLog(@"未找到主页面，无法同步状态"); 
//    }
}

// 更新本地存储
- (void)updateLocalFavoriteData:(NewsModel *)newsModel {
    NSMutableArray *favoriteIds = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FavoriteNewsIds"] mutableCopy];
    if (!favoriteIds) favoriteIds = [NSMutableArray array];
    [favoriteIds removeObject:newsModel.newsId];
    [[NSUserDefaults standardUserDefaults] setObject:favoriteIds forKey:@"FavoriteNewsIds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 从收藏中移除新闻
//- (void)removeFavoriteForNews:(NewsModel *)news atIndexPath:(NSIndexPath *)indexPath {
//    // 更新模型状态
//    news.isFavorite = NO;
//    
//    // 从收藏列表中移除
//    [self.favoriteNews removeObject:news];
//    
//    // 更新UI
//    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//    
//    // 保存收藏状态
//    ViewController *mainVC = (ViewController *)self.navigationController.viewControllers.firstObject;
//    [mainVC saveFavoriteStatus];
//    
//    // 显示提示
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"已取消收藏" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//        [self presentViewController:alert animated:YES completion:nil];
//    });
//}







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
