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
        if (extra && extra[@"icon"]) {
            NSString *iconPath = extra[@"icon"];
            // 检查是否已经是完整 URL（以 http:// 或 https:// 开头）
            if ([iconPath hasPrefix:@"http://"] || [iconPath hasPrefix:@"https://"]) {
                self.imageUrl = iconPath; // 直接使用完整 URL
            } else {
                // 拼接域名（处理相对路径）
                self.imageUrl = [NSString stringWithFormat:@"https://whyta.cn%@", iconPath];
            }
            
            // 对 URL 进行编码（处理特殊字符，如空格、中文）
            self.imageUrl = [self.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            self.imageUrl = @"";
        }
    }
    return self;
}

- (NSString *)realImageUrl {
    if (!self.imageUrl || ![self.imageUrl containsString:@"url="]) {
        return self.imageUrl; // 非代理 URL，直接返回
    }
    
    // 从代理 URL 中提取 Base64 编码的真实 URL
    NSRange urlRange = [self.imageUrl rangeOfString:@"url=" options:NSBackwardsSearch];
    if (urlRange.location != NSNotFound) {
        NSString *encodedUrl = [self.imageUrl substringFromIndex:urlRange.location + urlRange.length];
        
        // 处理可能的 URL 编码（如 %253D 是 "=" 的两次编码）
        encodedUrl = [encodedUrl stringByRemovingPercentEncoding];
        
        // Base64 解码
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encodedUrl options:0];
        if (decodedData) {
            NSString *realUrl = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            return realUrl;
        }
    }
    
    return self.imageUrl; // 解析失败，返回原 URL
}


@end
