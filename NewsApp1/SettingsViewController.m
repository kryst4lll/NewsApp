#import "SettingsViewController.h"
#import <UIKit/UIKit.h>



@interface SettingsViewController ()

// 设置项数据（标题 + 类型）
@property (nonatomic, strong) NSArray *settingsItems;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)]; // 去除表头空白
    
    // 初始化设置项
    self.settingsItems = @[
        @{@"title": @"字体大小", @"type": @(SettingTypeFontSize)},
        @{@"title": @"背景颜色", @"type": @(SettingTypeBackgroundColor)}
    ];
    
    // 注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    NSDictionary *item = self.settingsItems[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 右侧箭头
    
    // 显示当前选中值（如“中”“白色”）
    SettingType type = [item[@"type"] integerValue];
    cell.detailTextLabel.text = [self currentValueForType:type];
    
    return cell;
}

#pragma mark - 处理单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.settingsItems[indexPath.row];
    SettingType type = [item[@"type"] integerValue];
    
    // 根据类型显示不同的设置界面
    if (type == SettingTypeFontSize) {
        [self showFontSizeSetting];
    } else if (type == SettingTypeBackgroundColor) {
        [self showBackgroundColorSetting];
    }
}

#pragma mark - 字体大小设置
- (void)showFontSizeSetting {
    // 创建字体大小选择框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择字体大小" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 当前选中的字体大小（从本地读取）
    FontSize currentSize = [self savedFontSize];
    
    // 添加选项：小
    UIAlertAction *smallAction = [UIAlertAction actionWithTitle:@"小" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveFontSize:FontSizeSmall];
    }];
    smallAction.enabled = (currentSize != FontSizeSmall); // 当前选中项禁用
    
    // 选项：中
    UIAlertAction *mediumAction = [UIAlertAction actionWithTitle:@"中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveFontSize:FontSizeMedium];
    }];
    mediumAction.enabled = (currentSize != FontSizeMedium);
    
    // 选项：大
    UIAlertAction *largeAction = [UIAlertAction actionWithTitle:@"大" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveFontSize:FontSizeLarge];
    }];
    largeAction.enabled = (currentSize != FontSizeLarge);
    
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:smallAction];
    [alert addAction:mediumAction];
    [alert addAction:largeAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 背景颜色设置
- (void)showBackgroundColorSetting {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择背景颜色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 当前选中的颜色（从本地读取）
    BGColor currentColor = [self savedBGColor];
    
    // 选项：白色
    UIAlertAction *whiteAction = [UIAlertAction actionWithTitle:@"白色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveBGColor:BGColorWhite];
    }];
    whiteAction.enabled = (currentColor != BGColorWhite);
    
    // 选项：浅灰色
    UIAlertAction *grayAction = [UIAlertAction actionWithTitle:@"浅灰色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveBGColor:BGColorLightGray];
    }];
    grayAction.enabled = (currentColor != BGColorLightGray);
    
    // 选项：浅蓝色
    UIAlertAction *blueAction = [UIAlertAction actionWithTitle:@"浅蓝色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveBGColor:BGColorLightBlue];
    }];
    blueAction.enabled = (currentColor != BGColorLightBlue);
    
    [alert addAction:whiteAction];
    [alert addAction:grayAction];
    [alert addAction:blueAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 本地存储与读取
// 保存字体大小
- (void)saveFontSize:(FontSize)size {
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:@"FontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData]; // 刷新单元格显示
    [self postSettingChangeNotification]; // 发送设置变更通知
}

// 读取保存的字体大小（默认“中”）
- (FontSize)savedFontSize {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"FontSize"];
}

// 保存背景颜色
- (void)saveBGColor:(BGColor)color {
    [[NSUserDefaults standardUserDefaults] setInteger:color forKey:@"BGColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"保存背景色：%ld", (long)color); // 打印保存的值（0=白，1=浅灰，2=浅蓝）
    [self.tableView reloadData];
    [self postSettingChangeNotification];
}

// 读取保存的背景颜色（默认“白色”）
- (BGColor)savedBGColor {
    BGColor color = [[NSUserDefaults standardUserDefaults] integerForKey:@"BGColor"];
    NSLog(@"读取背景色：%ld", (long)color); // 验证读取的值是否正确
    return color;
}

// 获取当前设置值的显示文本（如“中”“白色”）
- (NSString *)currentValueForType:(SettingType)type {
    if (type == SettingTypeFontSize) {
        switch ([self savedFontSize]) {
            case FontSizeSmall: return @"小";
            case FontSizeMedium: return @"中";
            case FontSizeLarge: return @"大";
            default: return @"中";
        }
    } else if (type == SettingTypeBackgroundColor) {
        switch ([self savedBGColor]) {
            case BGColorWhite: return @"白色";
            case BGColorLightGray: return @"浅灰色";
            case BGColorLightBlue: return @"浅蓝色";
            default: return @"白色";
        }
    }
    return @"";
}

#pragma mark - 发送设置变更通知
- (void)postSettingChangeNotification {
    // 发送通知，告知其他页面更新UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingsChanged" object:nil];
}

@end
