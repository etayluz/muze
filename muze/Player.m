//
//  Player.m
//  muzeme
//
//  Created by Etay Luz on 5/15/14.
//  Copyright (c) 2014 com.luzsoft.muzeme. All rights reserved.
//

#import "Player.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface Player ()

@end

@implementation Player

static Player *player;

+ (Player*)player
{
    return player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.movieNumber = 1;
    player = self;
    //self.didPressNextMovieButton = NO;
    self.isMovieLiked = NO;
    self.isMoviePaused = NO;
    
    /* NUDGE */
    self.nudge  = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.height-125/2)/2, 320-60/2, 125/2, 60/2)];
    self.nudge.image = [UIImage imageNamed:@"Nudge.png"];
    self.nudge.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.nudge];
    
    /* MENU */
    self.menu = [[UIImageView alloc] init];
    NSInteger menuHeight = 55;
    self.menu.frame = CGRectMake(0,320-menuHeight,self.view.frame.size.height,menuHeight); // +(self.view.frame.size.height-100*4.9) 480
    self.menu.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(89/255.0) blue:(122/255.0) alpha:1];
    [self.view insertSubview:self.menu atIndex:5];
    
    /* DISLIKE IMAGE */
    self.dislikeImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.frame.size.width*0.15, self.menu.frame.size.height*0.2, self.menu.frame.size.height*0.6, self.menu.frame.size.height*0.6*40/35)];
    self.dislikeImage.image = [UIImage imageNamed:@"Dislike.png"];
    self.dislikeImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.menu addSubview:self.dislikeImage];
    
    /* DISLIKE BUTTON */
    self.dislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dislikeButton addTarget:self
                           action:@selector(didPressDislikeButton)
                 forControlEvents:UIControlEventTouchDown];
    self.dislikeButton.frame = CGRectMake(self.dislikeImage.frame.origin.x - 15, 0, self.dislikeImage.frame.size.width+30,self.menu.frame.size.height);
    CALayer * layer1 = [self.dislikeButton layer];
    [layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.menu addSubview:self.dislikeButton];

    /* LIKE IMAGE */
    self.likeImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.dislikeImage.frame.origin.x + self.dislikeImage.frame.size.width+30, self.dislikeImage.frame.origin.y, self.menu.frame.size.height*0.6, self.menu.frame.size.height*0.6*40/35)];
    self.likeImage.image = [UIImage imageNamed:@"Like.png"];
    self.likeImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.menu addSubview:self.likeImage];
    
    /* LIKE BUTTON */
    self.likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.likeButton addTarget:self
                           action:@selector(didPressLikeButton)
                 forControlEvents:UIControlEventTouchDown];
    self.likeButton.frame = CGRectMake(self.likeImage.frame.origin.x - 15, 0, self.likeImage.frame.size.width+30,self.menu.frame.size.height);
    layer1 = [self.likeButton layer];
    [layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.menu addSubview:self.likeButton];
    
    /* PAUSE IMAGE */
    self.pauseImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.frame.size.width*0.60, self.dislikeImage.frame.origin.y*0.2, self.menu.frame.size.height*0.6, self.menu.frame.size.height*0.6*40/35)];
    self.pauseImage.image = [UIImage imageNamed:@"Like.png"];
    self.pauseImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.menu addSubview:self.pauseImage];
    
    /* PAUSE BUTTON */
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pauseButton addTarget:self
                        action:@selector(didPressLikeButton)
              forControlEvents:UIControlEventTouchDown];
    self.pauseButton.frame = CGRectMake(self.pauseImage.frame.origin.x - 15, 0, self.pauseImage.frame.size.width+30,self.menu.frame.size.height);
    layer1 = [self.likeButton layer];
    [layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.menu addSubview:self.pauseButton];
    
    return;
    /* MOVIE PLAYER */
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://etayluz.com/1.3gp"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieNowPlaying)
                                                 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                               object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinishPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerStateDidChange)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    self.movieNumber = 2;
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;//MPMovieScalingModeAspectFit; // MPMovieScalingModeAspectFit
    self.moviePlayer.view.frame = CGRectMake(0,0,self.view.frame.size.height,320);
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;//MPMovieControlStyleNone,MPMovieControlStyleDefault
    [self.moviePlayer prepareToPlay];

    [self.view addSubview:self.moviePlayer.view];
    [self.view addSubview:self.menu];
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];


    
    /* LIKE BUTTON */
    self.likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.likeButton addTarget:self
                   action:@selector(didPressLikeButton)
         forControlEvents:UIControlEventTouchDown];
    self.likeButton.frame = CGRectMake(self.view.frame.size.height*0.24, self.menu.frame.origin.y, 80,self.menu.frame.size.height);
    CALayer * layer2 = [self.likeButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:self.likeButton];
    
    /* MAIL BUTTON */
    self.mailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mailButton addTarget:self
                        action:@selector(didPressMailButton)
              forControlEvents:UIControlEventTouchDown];
    layer1 = [self.mailButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.mailButton setBackgroundImage:[UIImage imageNamed:@"Mail.png"] forState:UIControlStateNormal];
    self.mailButton.frame = CGRectMake(self.view.frame.size.height*0.44, self.menu.frame.origin.y+20, 256/4,30);
    self.mailButton.alpha = 0.35;
    [self.view addSubview:self.mailButton];
    
    /* PLAY AND PAUSE BUTTON */
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.playPauseButton addTarget:self
                   action:@selector(didPressPlayPauseButton)
         forControlEvents:UIControlEventTouchDown];
    //self.playPauseButton.frame = CGRectMake(self.view.frame.size.height*0.60,self.menu.frame.origin.y, 70, self.menu.image.size.height);
    layer2 = [self.playPauseButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:self.playPauseButton];
    
    /* NEXT BUTTON */
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton addTarget:self
                             action:@selector(didPressNextButton)
                   forControlEvents:UIControlEventTouchDown];
    //self.nextButton.frame = CGRectMake(self.view.frame.size.height*0.80,self.menu.frame.origin.y, 80, self.menu.image.size.height);
    layer2 = [self.nextButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    self.nextButton.hidden = YES;
    [self.view addSubview:self.nextButton];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if (self.isControlsShown)
        [self hideControls];
    else
        [self showControls];
}

- (void)didPressMailButton
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = (id)self;
        
        [mailer setSubject:@"New Feedback"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"etayluz@gmail.com", nil];
        [mailer setToRecipients:toRecipients];
        
//        UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
//        NSData *imageData = UIImagePNGRepresentation(myImage);
//        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];

}



-(void)hideControls
{
    self.isControlsShown = NO;
    self.menu.hidden = YES;
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.playPauseButton.enabled = NO;
    self.nextButton.enabled = NO;
    self.mailButton.hidden = YES;
}

-(void)showControls
{
    self.isControlsShown = YES;
    self.menu.hidden = NO;
    self.likeButton.enabled = YES;
    self.dislikeButton.enabled = YES;
    self.playPauseButton.enabled = YES;
    self.nextButton.enabled = YES;
    self.mailButton.hidden = NO;
    [self.hideControlsTimer invalidate];
    self.hideControlsTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
}



- (void)didPressLikeButton
{
//    if (self.isMoviePaused)
//        self.menu.image = [UIImage imageNamed:@"buttomBarSelectedPlay.png"];
//    else
//        self.menu.image = [UIImage imageNamed:@"buttomBarSelected.png"];
    self.isMovieLiked = YES;

    self.nextButton.hidden = NO;
}

- (void)didPressDislikeButton
{
    [self didPressNextButton];

}

- (void)movieNowPlaying
{
    //    NSLog(@"%ld", (long)self.moviePlayer.playbackState);
    //    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    NSLog(@"movieNowPlaying");
    self.movieDidStartPlaying = YES;
    //self.didPressNextMovieButton = NO;
}

- (void)movieDidFinishPlaying:(NSNotification *)notification
{
    //if (self.didPressNextMovieButton == NO)
    [self didPressNextButton];
    
    NSDictionary *notificationUserInfo = [notification userInfo];
    NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    MPMovieFinishReason reason = [resultValue intValue];
    if (reason == MPMovieFinishReasonPlaybackError)
    {
        NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
        if (mediaPlayerError && !self.isError)
        {
            self.isError = YES;
            NSLog(@"playback failed with error description: %@", [mediaPlayerError localizedDescription]);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops!"
                                                                message:@"Video couldn't be loaded. App will shut down."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            NSLog(@"playback failed without any given reason");
        }
    }
    else
        NSLog(@"movieDidFinishPlaying");
//    else
//        self.didPressNextMovieButton = NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        //home button press programmatically
//        UIApplication *app = [UIApplication sharedApplication];
//        [app performSelector:@selector(suspend)];
//        
//        //wait 2 seconds while app is going background
//        [NSThread sleepForTimeInterval:2.0];
    
        //exit app when app is in background
        exit(0);
}

- (void)moviePlayerStateDidChange
{
    NSLog(@"moviePlayerStateDidChange");
    if (self.movieDidStartPlaying == YES)
    {
        self.movieDidStartPlaying = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showControls];
    }
}

- (void)didPressNextButton
{
//    self.didPressNextMovieButton = YES;
    [self.moviePlayer.view removeFromSuperview];
    self.isMovieLiked = NO;
    self.isMoviePaused = NO;
    self.nextButton.hidden = YES;
   // self.menu.image = [UIImage imageNamed:@"buttomBar.png"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];

    [self.moviePlayer pause];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://etayluz.com/%ld.3gp", (long)self.movieNumber++]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieNowPlaying)
                                                     name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                                   object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinishPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerStateDidChange)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayer.view.frame = CGRectMake(0,0,self.view.frame.size.height,320);
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;//MPMovieControlStyleNone
    //[self.view addSubview:self.moviePlayer.view];
    [self.view insertSubview:self.moviePlayer.view atIndex:0];
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];
    [self.moviePlayer prepareToPlay];
    //self.menu.image = [UIImage imageNamed:@"buttomBar.png"];
}

- (void)didPressPlayPauseButton
{
    if (self.isMoviePaused == NO)
    {
        [self.moviePlayer pause];
        self.isMoviePaused = YES;
//        if (self.isMovieLiked)
//            self.menu.image = [UIImage imageNamed:@"buttomBarSelectedPlay.png"];
//        else
//            self.menu.image = [UIImage imageNamed:@"buttomBarPlay.png"];
    }
    else
    {
        [self.moviePlayer play];
        self.isMoviePaused = NO;
//        if (self.isMovieLiked)
//            self.menu.image = [UIImage imageNamed:@"buttomBarSelected.png"];
//        else
//            self.menu.image = [UIImage imageNamed:@"buttomBar.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
