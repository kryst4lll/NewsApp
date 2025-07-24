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
        // 强制解包可能导致崩溃，改为安全取值
        self.newsId = dict[@"id"] ?: @""; // 若 key 不存在，赋值空字符串
        self.title = dict[@"title"] ?: @"";
        self.url = dict[@"url"] ?: @"";
        
        // 处理图片 URL（容错：若 extra 或 icon 不存在）
        NSDictionary *extra = dict[@"extra"];
        if (extra && [extra isKindOfClass:[NSDictionary class]]) {
            NSString *iconPath = extra[@"icon"];
            if (iconPath && iconPath.length > 0) {
                self.imageUrl = [NSString stringWithFormat:@"https://whyta.cn%@", iconPath];
            } else {
                self.imageUrl = @""; // 无图片时赋值空字符串
            }
        } else {
            self.imageUrl = @"";
        }
    }
    return self;
}

@end
