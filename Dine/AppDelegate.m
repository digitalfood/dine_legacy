//
//  AppDelegate.m
//  Dine
//
//  Created by Pythis Ting on 2/12/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MainViewController.h"

NSString *kApplicationId = @"fBRzEFzV9FSrQlnUpokfbdEl4a8T6zpCMtCl5UFw";
NSString *kClientKey = @"jgjb5IDkcNrDJQTeQ97KyQZ3s49frMry5unqwUuu";

@interface AppDelegate () <PFLogInViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // Initiate Parse
    [Parse setApplicationId:kApplicationId clientKey:kClientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
    [PFFacebookUtils initializeFacebook];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self signedIn];
    } else {
                [self signedIn];
//        [self notSignedIn];
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

- (void)notSignedIn {
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.fields = (PFLogInFieldsFacebook);
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tea" ofType:@"gif"];
    NSURL *imageURL	 = [NSURL fileURLWithPath: filePath];
    
    // strech the image a bit to make it fit.
    NSString *htmlString = @"<html><body style='margin:0; padding:0;'><img src='%@' width='%fpx' height='%fpx'></body></html>";
    NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, imageURL, width, height];
    
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    webViewBG.userInteractionEnabled = NO;
    webViewBG.backgroundColor = [UIColor lightGrayColor];
    [webViewBG loadHTMLString:imageHTML baseURL:nil];
    [logInController.view addSubview:webViewBG];

    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    overlay.backgroundColor = [UIColor clearColor];
    
    UIFont *font= [UIFont systemFontOfSize:32];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    NSString *title = @"Dine.";
    CGRect textLabelRect = [title boundingRectWithSize:CGSizeMake(logInController.view.frame.size.width - 30, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attributes
                                                        context:nil];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, textLabelRect.size.width, textLabelRect.size.height)];
    textLabel.font = font;
    textLabel.text = @"Dine.";
    textLabel.textColor = [UIColor whiteColor];
    [overlay addSubview:textLabel];
    [logInController.view addSubview:overlay];
    
    // bring facebook login button to front
    [logInController.logInView addSubview:logInController.logInView.facebookButton];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = logInController;
    
    [[UINavigationBar appearance] setHidden:YES];
}

- (void)signedIn {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *vc = [[MainViewController alloc] init];
    self.window.rootViewController = vc;
}

@end
