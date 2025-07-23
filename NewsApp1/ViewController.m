//
//  ViewController.m
//  newsApp
//
//  Created by yyh on 2025/7/22.
//

#import "ViewController.h"
#import "NewsCollectionViewCell.h"
#import "NewsDetailViewController.h"

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
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    
    //模拟数据
    cell.titleLabel.text = [NSString stringWithFormat:@"这里是一个新闻的标题 %ld，点击我进入查看新闻详情.这里是一个新闻的标题，点击我进入查看新闻详情", (long)indexPath.row];
    cell.timeLabel.text = @"2023-11-01";
    cell.thumbnailImageView.image = [UIImage systemImageNamed:@"house"];
    
    cell.backgroundColor = [UIColor whiteColor];
   
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
