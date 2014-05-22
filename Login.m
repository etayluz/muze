//
//  Login.m
//  muze
//
//  Created by Etay Luz on 5/22/14.
//  Copyright (c) 2014 com.luzsoft.muzeme. All rights reserved.
//

#import "Login.h"
#import "AppDelegate.h"

@interface Login ()

@end

@implementation Login

static Login* login = nil;

+(Login*)login
{
    if (login == nil)
        login = [[self alloc] init];
    
    return login;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* BACKGROUND IMAGE */
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width)];
    if (self.view.frame.size.height == 490)
        backgroundView.image = [UIImage imageNamed:@"Login4.png"];
    else
        backgroundView.image = [UIImage imageNamed:@"Login5.png"];
    
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundView];
    
    /* FACEBOOK BUTTON */
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.facebookButton addTarget:self
                               action:@selector(didPressFacebookLoginButton)
                     forControlEvents:UIControlEventTouchDown];
    [self.facebookButton setBackgroundImage:[UIImage imageNamed:@"FacebookButton.png"] forState:UIControlStateNormal];
    self.facebookButton.frame = CGRectMake((self.view.frame.size.height - 200)/2, 320*0.8, 200, 45.5);
    [self.view addSubview:self.facebookButton];
}

-(void)didPressFacebookLoginButton
{
    [MBProgressHUD showHUDAddedTo:self.view message:@"Login" animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginComplete) name:@"facebookLoginComplete" object:nil];
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
}

- (void)facebookLoginComplete
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [UIView transitionWithView:appDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        [self dismissViewControllerAnimated:NO completion:nil];
                        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                        appDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                        appDelegate.window.rootViewController = [[Player alloc] init];
                        [appDelegate.window makeKeyAndVisible];
                    }
                    completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
