//
//  AppDelegate.m
//  Handychecks
//
//  Created by Shrishti Informatics on 11/25/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
@import GoogleMaps;
#import <Quickblox/Quickblox.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyDKWd03hc13YMu55k8TV5lywuQdjEjrd3I"];
    
    [QBSettings setApplicationID:35148];
    [QBSettings setAuthKey:@"mWrLbd4Nq9Rdypj"];
    [QBSettings setAuthSecret:@"X2Y8MZnnzDh2TJZ"];
     
    // Check to see if this is an iOS 8 device.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        // Register for push in iOS 8.
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        // Register for push in iOS 7 and under.
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    HomeViewController *home;
    MenuViewController *leftMenu;
    
    UINavigationController *navigationController;
    
    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    leftMenu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:login];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navigationController
                                                    leftMenuViewController:leftMenu
                                                    rightMenuViewController:nil];
    [container setPanMode:MFSideMenuPanModeNone];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(49.0/255) green:(153.0/255) blue:(206.0/255) alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.window.rootViewController = container;
    
    return YES;
}

// Handle remote notification registration.

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    const char* data = [devToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [devToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    [self sendProviderDeviceToken:token]; // custom method
}

- (void)sendProviderDeviceToken:(NSString *)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"device_token"];
    
    /*NSDictionary *urlDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Api" ofType:@"plist"]];
    NSString *url = [urlDictionary objectForKey:@"device_token"];
    
    NSString *post = [NSString stringWithFormat:@"device_token=%@", token];
    
    [[[Network alloc] init] POSTBlockWebservicewithParameters:post URL:url  block:^(NSDictionary * response) {
        NSLog(@"%@", [response objectForKey:@"response"]);
    }];*/
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s..userInfo=%@",__FUNCTION__,userInfo);
    /**
     * Dump your code here according to your requirement after receiving push
     */
    NSDictionary *pushData = [userInfo objectForKey:@"aps"];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Handychecks"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
