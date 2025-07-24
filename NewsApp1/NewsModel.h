//
//  NewsModel.h
//  NewsApp1
//
//  Created by yyh on 2025/7/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imageUrl; // 图片URL
@property (nonatomic, strong) UIImage *image;   // 图片对象

// 初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
