//
//  NewsDetailViewController.h
//  newsApp
//
//  Created by yyh on 2025/7/23.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailViewController : UIViewController

//@property (nonatomic, strong) NSString *newsTitle;
//@property (nonatomic, strong) NSString *newsContent;
//@property (nonatomic, strong) UIImage *newsImage;

// 接收新闻数据的属性
@property (nonatomic, strong) NewsModel *newsModel;

@end

NS_ASSUME_NONNULL_END
