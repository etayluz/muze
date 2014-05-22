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
    //self.window.rootViewController =  [[Player alloc] init];
    self.window.rootViewController = [[Login alloc] init];
    [self.window makeKeyAndVisible];
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"FBSessionStateCreatedTokenLoaded");
        // If there's one, just open the session silently, without showing the user the login UI
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email",@"age_range"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    return YES;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
        {
            NSLog(@"FBSessionStateOpen");
            [self completeFacebookLogin];
            break;
        }
            
        case FBSessionStateClosed:
        {
            NSLog(@"FBSessionStateClosed");
            break;
        }
            
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            NSLog(@"FBSessionStateClosedLoginFailed");
            Login *login = [Login login];
            [MBProgressHUD hideHUDForView:login.view animated:YES];
            break;
        }
        default:
        {
            NSLog(@"FB No State");
            break;
        }
    }
}

-(void)completeFacebookLogin
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id facebookUser, NSError *error) {
        if (!error) {
            NSLog(@"%@",facebookUser);
//            self.facebookUserData = [[NSMutableDictionary alloc] init];
//            [self.facebookUserData setValue:[result objectForKey:@"id"] forKey:@"facebook_id"];
//            [self.facebookUserData setValue:[result objectForKey:@"email"] forKey:@"email"];
//            //NSString *username = [[result objectForKey:@"email"] substringToIndex:[[result objectForKey:@"email"] rangeOfString:@"@"].location];
//            NSString* username = [[result objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"@" withString:@""];
//            username = [username stringByReplacingOccurrencesOfString:@"." withString:@""];
//            [self.facebookUserData setValue:username forKey:@"username"];
//            [self.facebookUserData setValue:[result objectForKey:@"first_name"] forKey:@"first_name"];
//            [self.facebookUserData setValue:[result objectForKey:@"last_name"] forKey:@"last_name"];
//            [self.facebookUserData setValue:[result objectForKey:@"birthday"] forKey:@"birthdate"];
//            [self.facebookUserData setValue:[result objectForKey:@"gender"] forKey:@"gender"];
//            [self.facebookUserData setValue:[FBSession.activeSession accessTokenData].accessToken  forKey:@"oauth_token"];
//
//            // READ: http://jeffreysambells.com/2013/03/01/asynchronous-operations-in-ios-with-grand-central-dispatch
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSURL *profilePicUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]]];
//                NSData  *avatar = [NSData dataWithContentsOfURL:profilePicUrl];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    if (avatar != nil) {
//                        [self.facebookUserData setValue:[avatar base64EncodedStringWithOptions:0] forKey:@"avatar"];
//                    }
//                    
//                    if (self.user == nil)
//                    {
//                        [ApiRequest request:@"login.json" method:@"POST" params:[NSDictionary dictionaryWithObjectsAndKeys:self.facebookUserData,@"user", nil] completeBlock:^(NSDictionary *user, NSError *error){
//                            if (!error) {
//                                NSLog(@"%@",user);
//                                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:user[@"user"] options:0 error:nil];
//                                NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
//                                [user_defaults setObject:[user[@"user"] objectForKey:@"authentication_token"] forKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiAuthKeyName"]];
//                                [user_defaults setObject:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] forKey:@"current_user"];
//                                [user_defaults synchronize];
//                                self.user = user[@"user"];
//                                self.user = [self.user mutableCopy];
//                                
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookLoginComplete" object:self];
//                            } else {
//                                [MBProgressHUD hideHUDForView:[RegistrationOptions registrationOptions].view animated:YES];
//                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Error 1" message:[error.userInfo[@"errors"] componentsJoinedByString:@"\n" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                                [alert show];
//                                return;
//                            }
//                        }];
//                    }
//                });
//            });
            
        } else {
            [MBProgressHUD hideHUDForView:[Login login].view animated:YES];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Error 2" message:[error.userInfo[@"errors"] componentsJoinedByString:@"\n" ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
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
//    Player *player = [Player player];
//    
//    if (player.movieDidStartPlaying == NO)
//    {
//        player.movieNumber--;
//        [MBProgressHUD hideHUDForView:player.view animated:YES];
//        [player didPressNextButton];
//    }
//    else
//    {
//        if (!player.isMenuShown)
//            [player showMenu];
//        if (player.playImage.hidden == YES)
//            [player.moviePlayer play];
//    }
    
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
