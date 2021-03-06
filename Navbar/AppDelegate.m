//
//  AppDelegate.m
//  Navbar
//
//  Created by Jake Scott on 2/03/13.
//  Copyright (c) 2013 superlogical. All rights reserved.
//

#import "AppDelegate.h"
#import "Settings.h"

@interface AppDelegate() {
    
}

@property (nonatomic, strong) PostsViewController *postsViewController;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;

@end

@implementation AppDelegate

@synthesize window;
@synthesize navController;
@synthesize networkStatus;

@synthesize hostReach;
@synthesize internetReach;
@synthesize wifiReach;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Settings *settings = [[Settings alloc]init];
   
    [Parse setApplicationId:[settings parseAppId]  clientKey: [settings parseClientKey]];
    [Parse offlineMessagesEnabled:NO];
    
    // Use Reachability to monitor connectivity
    [self monitorReachability];
    
    // Setup the posts controller
    self.postsViewController = [[PostsViewController alloc]initWithClassName:@"Post"];
    self.postsViewController.date = [[NSDate date] beginningOfDay];
    
    // Setup the nav controller
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.postsViewController];
    self.window.rootViewController = self.navController;
    
    // Set up our app's global UIAppearance
    [self setupAppearance];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[[UIColor colorWithRed:41/255.0 green:82/255.0 blue:88/255.0 alpha:1.0] imageFromColor] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0],
                        UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                    UITextAttributeFont : [UIFont fontWithName:@"Montserrat-Bold" size:17.0]
     }];
    
    [self.navController.navigationBar setTitleVerticalPositionAdjustment:3.0f forBarMetrics:UIBarMetricsDefault];
    
    if ([self.navController.navigationBar respondsToSelector:@selector(shadowImage)]) {
        self.navController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
}

#pragma mark - AppDelegate

- (BOOL)isParseReachable
{
    return self.networkStatus != NotReachable;
}

- (void)monitorReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
  
    self.hostReach = [Reachability reachabilityWithHostname: @"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification* )note
{
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    networkStatus = [curReach currentReachabilityStatus];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
