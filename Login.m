//
//  Login.m
//  muze
//
//  Created by Etay Luz on 5/22/14.
//  Copyright (c) 2014 com.luzsoft.muzeme. All rights reserved.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login


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
                               action:@selector(didPressFacebookButton)
                     forControlEvents:UIControlEventTouchDown];
    [self.facebookButton setBackgroundImage:[UIImage imageNamed:@"FacebookButton.png"] forState:UIControlStateNormal];
    self.facebookButton.frame = CGRectMake((self.view.frame.size.height - 200)/2, 320*0.8, 200, 45.5);
    [self.view addSubview:self.facebookButton];
}

-(void)didPressFacebookButton
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
