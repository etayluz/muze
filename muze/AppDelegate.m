//
//  AppDelegate.m
//  muzeme
//
//  Created by Etay Luz on 5/15/14.
//  Copyright (c) 2014 com.luzsoft.muzeme. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController =  [[Player alloc] init];
    [self.window makeKeyAndVisible];
    
    NSString *request = @"";
    NSLog(@"%@", request);
    [ApiRequest request:request method:@"POST" params:nil  completeBlock:^(NSDictionary *serachResults, NSError *error){
        if (!error) {

        }
        else
        {

        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    Player *player = [Player player];
    
    if (player.movieDidStartPlaying == NO)
    {
        player.movieNumber--;
        [MBProgressHUD hideHUDForView:player.view animated:YES];
        [player didPressNextButton];
    }
    else
    {
        if (!player.isMenuShown)
            [player showMenu];
        if (player.playImage.hidden == YES)
            [player.moviePlayer play];
    }
    
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
