//
//  AppDelegate.m
//  Dine
//
//  Created by Pythis Ting on 2/12/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Parse/Parse.h"
#import <ParseUI/ParseUI.h>
#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate () <PFLogInViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initiate Parse
    [Parse setApplicationId:@"fBRzEFzV9FSrQlnUpokfbdEl4a8T6zpCMtCl5UFw" clientKey:@"jgjb5IDkcNrDJQTeQ97KyQZ3s49frMry5unqwUuu"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
    [PFFacebookUtils initializeFacebook];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // hide status bar
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        // set navigation bar appearance
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:121.0/255.0 green:174.0/255.0 blue:1.0 alpha:1.0]];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        MainViewController *vc = [[MainViewController alloc] init];
        self.window.rootViewController = vc;
        
    } else {
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.delegate = self;
        logInController.fields = (PFLogInFieldsFacebook);
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = logInController;
        [[UINavigationBar appearance] setHidden:YES];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    // hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // set navigation bar appearance
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:121.0/255.0 green:174.0/255.0 blue:1.0 alpha:1.0]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *vc = [[MainViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
}

@end
