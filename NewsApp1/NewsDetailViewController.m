//
//  NewsDetailViewController.m
//  newsApp
//
//  Created by yyh on 2025/7/23.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *contentLabel;
//@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 确保模型数据已传递
    if (!self.newsModel) {
        NSLog(@"警告：未传递新闻数据");
        return;
    }
    
    // 4.1 显示标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.bounds.size.width - 40, 60)];
    titleLabel.numberOfLines = 0; // 支持多行
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = self.newsModel.title; // 使用传递的标题
    [self.view addSubview:titleLabel];
    
    // 4.2 显示图片（如果有）
    if (self.newsModel.image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width - 40, 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = self.newsModel.image; // 使用传递的图片
        [self.view addSubview:imageView];
    }
    
    // 4.3 显示详情内容（如果API返回了内容字段，这里替换为实际字段）
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, self.view.bounds.size.width - 40, 300)];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:16];
    // 注意：如果API返回的模型中有content字段，直接用 self.newsModel.content
    contentLabel.text = @"这里是新闻的详细内容...";
    [self.view addSubview:contentLabel];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
