//
//  NewsModel.m
//  NewsApp1
//
//  Created by yyh on 2025/7/23.
//

#import "NewsModel.h"

@implementation NewsModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.newsId = dict[@"id"];
        self.title = dict[@"title"];
        self.url = dict[@"url"];
        
        // 处理图片URL
        NSDictionary *extra = dict[@"extra"];
        if (extra && extra[@"icon"]) {
            // 构建完整的图片URL
            self.imageUrl = [NSString stringWithFormat:@"https://whyta.cn%@", extra[@"icon"]];
        }
    }
    return self;
}

@end
