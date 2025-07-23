//
//  SceneDelegate.m
//  NewsApp1
//
//  Created by yyh on 2025/7/23.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    ViewController *VC = [[ViewController alloc] init];
    VC.navigationItem.title = @"新闻";  // 显示在导航栏
    
    // 将VC嵌入到导航控制器中
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:VC];
    navVC.tabBarItem.title = @"首页";
    navVC.tabBarItem.image = [UIImage systemImageNamed:@"house"]; // 系统图标
    
    UIViewController *controller1 = [[UIViewController alloc] init];
    controller1.view.backgroundColor = [UIColor whiteColor];
    controller1.navigationItem.title = @"收藏页面";  // 设置标题
    // 将controller1也嵌入到导航控制器中
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:controller1];
    navController1.tabBarItem.title = @"收藏";
    navController1.tabBarItem.image = [UIImage systemImageNamed:@"star"];
    
    UIViewController *controller2 = [[UIViewController alloc] init];
    
    UINavigationController *navcontroller2 = [[UINavigationController alloc] initWithRootViewController:controller2];
    navcontroller2.tabBarItem.title = @"我的";
    navcontroller2.tabBarItem.image = [UIImage systemImageNamed:@"person"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[navVC, navController1, navcontroller2]];
    
    // 设置标签栏样式
    UITabBar *tabBar = tabBarController.tabBar;
    tabBar.tintColor = [UIColor redColor];
    tabBar.unselectedItemTintColor = [UIColor grayColor];
    
    UITabBarAppearance *tabBarAppearance = [UITabBarAppearance new];
    tabBarAppearance.backgroundColor = [UIColor whiteColor];
    tabBarAppearance.shadowColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    tabBar.standardAppearance = tabBarAppearance;
    tabBar.scrollEdgeAppearance = tabBarAppearance;
    
    // 设置导航栏样式
    UINavigationBarAppearance *navBarAppearance = [UINavigationBarAppearance new];
    navBarAppearance.backgroundColor = [UIColor whiteColor];
    navBarAppearance.shadowColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [UINavigationBar appearance].standardAppearance = navBarAppearance;
    [UINavigationBar appearance].scrollEdgeAppearance = navBarAppearance;
    
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
