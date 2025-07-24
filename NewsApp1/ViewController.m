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
    self.newsList = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 120);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [collectionView registerClass:[NewsCollectionViewCell class] forCellWithReuseIdentifier:@"id"];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    
    // 获取新闻数据
    [self fetchNewsData];
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
    
    // 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 创建数据任务
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 停止加载指示器（在主线程中执行）
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        });
        
        // 检查错误
        if (error) {
            NSLog(@"请求错误: %@", error.localizedDescription);
            return;
        }
        
        // 解析JSON数据
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonDict isKindOfClass:[NSDictionary class]]) {
                // 检查状态
                NSString *status = jsonDict[@"status"];
                if ([status isEqualToString:@"success"]) {
                    // 获取items数组
                    NSArray *items = jsonDict[@"items"];
                    if (items && [items isKindOfClass:[NSArray class]]) {
                        // 清空现有数据
                        [self.newsList removeAllObjects];
                        
                        // 解析每个新闻项
                        for (NSDictionary *itemDict in items) {
                            NewsModel *newsModel = [[NewsModel alloc] initWithDictionary:itemDict];
                            [self.newsList addObject:newsModel];
                        }
                        
                        // 刷新CollectionView（在主线程中执行）
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.collectionView reloadData];
                        });
                    }
                }
            }
        }
    }];
    
    // 启动任务
    [task resume];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 10;
    return self.newsList.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    
//    //模拟数据
//    cell.titleLabel.text = [NSString stringWithFormat:@"这里是一个新闻的标题 %ld，点击我进入查看新闻详情.这里是一个新闻的标题，点击我进入查看新闻详情", (long)indexPath.row];
//    cell.timeLabel.text = @"2023-11-01";
//    cell.thumbnailImageView.image = [UIImage systemImageNamed:@"house"];
//    
//    cell.backgroundColor = [UIColor whiteColor];

    // 获取新闻模型
    NewsModel *newsModel = self.newsList[indexPath.item];
    
    // 设置标题
    cell.titleLabel.text = newsModel.title;
    
    // 加载图片（使用异步加载，避免阻塞主线程）
    if (newsModel.imageUrl) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageUrl = [NSURL URLWithString:newsModel.imageUrl];
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
        });
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];
    detailVC.title = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    detailVC.newsTitle = [NSString stringWithFormat:@"新闻标题 %ld", (long)indexPath.row];
    detailVC.newsContent = @"这里是新闻的详细内容，可以是多行文本。实际开发中应从网络或数据库加载。";
    detailVC.newsImage = [UIImage systemImageNamed:@"house"];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
