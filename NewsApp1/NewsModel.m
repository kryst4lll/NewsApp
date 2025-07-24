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
    if (![self.imageUrl containsString:@"url="]) {
        return self.imageUrl;
    }
    
    // 提取url=后的部分
    NSArray *components = [self.imageUrl componentsSeparatedByString:@"url="];
    if (components.count < 2) return self.imageUrl;
    
    NSString *encodedPart = components[1];
    
    // 关键修复：双重URL解码
    NSString *urlDecoded = [[encodedPart stringByRemovingPercentEncoding] stringByRemovingPercentEncoding];
    
    // Base64解码
    NSData *data = [[NSData alloc] initWithBase64EncodedString:urlDecoded options:0];
    if (!data) {
        NSLog(@"⚠️ Base64解码失败，原始字符串: %@", urlDecoded);
        return self.imageUrl;
    }
    
    NSString *realUrl = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"✅ 解码成功:\n原始URL: %@\n最终URL: %@", self.imageUrl, realUrl);
    
    return realUrl;
}

@end
