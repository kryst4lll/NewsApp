//
//  SettingsViewController.h
//  NewsApp1
//
//  Created by yyh on 2025/7/25.
//

#import <UIKit/UIKit.h>

// 定义设置项类型（方便区分不同设置）
typedef NS_ENUM(NSInteger, SettingType) {
    SettingTypeFontSize,    // 字体大小
    SettingTypeBackgroundColor // 背景颜色
};

// 字体大小选项
typedef NS_ENUM(NSInteger, FontSize) {
    FontSizeSmall,   // 小
    FontSizeMedium,  // 中（默认）
    FontSizeLarge    // 大
};

// 背景颜色选项
typedef NS_ENUM(NSInteger, BGColor) {
    BGColorWhite,    // 白色（默认）
    BGColorLightGray,// 浅灰
    BGColorLightBlue // 浅蓝
};

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UITableViewController

@end

NS_ASSUME_NONNULL_END
