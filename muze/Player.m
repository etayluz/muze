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
    self.isMenuShown = YES;
    self.view.backgroundColor = [UIColor blueColor];
    
    /* NUDGE */
    self.nudge  = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.height-125/2)/2, 320-60/2, 125/2, 60/2)];
    self.nudge.image = [UIImage imageNamed:@"Nudge.png"];
    self.nudge.contentMode = UIViewContentModeScaleAspectFill;
    
    /* MENU */
    self.menu = [[UIView alloc] init];
    NSInteger menuHeight = 55;
    NSInteger iconHeight = menuHeight*0.6;
    NSInteger iconY =(menuHeight-iconHeight)/2;
    self.menu.frame = CGRectMake(0,320-menuHeight,self.view.frame.size.height,menuHeight); // +(self.view.frame.size.height-100*4.9) 480
    self.menu.backgroundColor = [UIColor colorWithRed:(69/255.0) green:(89/255.0) blue:(122/255.0) alpha:1];
    [self.view addSubview:self.menu];
    
    /* DISLIKE IMAGE */
    self.dislikeImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.frame.size.width*0.20, iconY, iconHeight*35/40, iconHeight)];
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
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor greenColor] CGColor]];
    [self.menu addSubview:self.dislikeButton];

    /* LIKE IMAGE */
    self.likeImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.dislikeImage.frame.origin.x + self.dislikeImage.frame.size.width*2, iconY, iconHeight*35/40, iconHeight)];
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
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.menu addSubview:self.likeButton];
    
    /* PAUSE IMAGE */
    self.pauseImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.frame.size.width*0.60, iconY, iconHeight*21/31, iconHeight)];
    self.pauseImage.image = [UIImage imageNamed:@"Pause.png"];
    self.pauseImage.contentMode = UIViewContentModeScaleAspectFill;
    self.pauseImage.hidden = NO;
    [self.menu addSubview:self.pauseImage];
    
    /* PAUSE BUTTON */
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pauseButton addTarget:self
                        action:@selector(didPressPauseButton)
              forControlEvents:UIControlEventTouchDown];
    self.pauseButton.frame = CGRectMake(self.pauseImage.frame.origin.x - 15, 0, self.pauseImage.frame.size.width+30,self.menu.frame.size.height);
    layer1 = [self.likeButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.menu addSubview:self.pauseButton];
    
    /* PLAY IMAGE */
    self.playImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.frame.size.width*0.61, iconY, iconHeight*21/31, iconHeight)];
    self.playImage.image = [UIImage imageNamed:@"Play.png"];
    self.playImage.contentMode = UIViewContentModeScaleAspectFill;
    self.playImage.hidden = YES;
    [self.menu addSubview:self.playImage];
    
    /* PLAY BUTTON */
    self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.playButton addTarget:self
                        action:@selector(didPressPlayButton)
              forControlEvents:UIControlEventTouchDown];
    self.playButton.frame = CGRectMake(self.playImage.frame.origin.x - 15, 0, self.playImage.frame.size.width+30,self.menu.frame.size.height);
    layer1 = [self.playButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    self.playButton.enabled = NO;
    [self.menu addSubview:self.playButton];
    
    /* NEXT IMAGE */
    self.nextImage  = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.frame.size.width*0.75, iconY, iconHeight*21/31, iconHeight)];
    self.nextImage.image = [UIImage imageNamed:@"Next.png"];
    self.nextImage.contentMode = UIViewContentModeScaleAspectFill;
    self.nextImage.hidden = YES;
    [self.menu addSubview:self.nextImage];
    
    /* NEXT BUTTON */
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton addTarget:self
                         action:@selector(didPressNextButton)
               forControlEvents:UIControlEventTouchDown];
    self.nextButton.frame = CGRectMake(self.nextImage.frame.origin.x - 15, 0, self.nextImage.frame.size.width+30,self.menu.frame.size.height);
    layer1 = [self.nextButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    self.nextButton.enabled = NO;
    [self.menu addSubview:self.nextButton];
    
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
    
    self.tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(toggleMenu)];
    self.tap.delegate = self;
    
    [self.moviePlayer.view addGestureRecognizer:self.tap];

    [self.view addSubview:self.moviePlayer.view];
    [self.view addSubview:self.nudge];
    [self.view addSubview:self.menu];
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];
    
    self.hideMenuTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideMenu) userInfo:nil repeats:NO];
}

- (void)toggleMenu
{
    if (self.isMenuShown)
    {
        [self hideMenu];
        
    }
    else
    {
        [self showMenu];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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



-(void)hideMenu
{
    self.isMenuShown = NO;
    [self.hideMenuTimer invalidate];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame;
        frame = self.menu.frame;
        frame.origin.y += (self.menu.frame.size.height);
        self.menu.frame=frame;
    }
    completion:^ (BOOL finished) {}
    ];
}

-(void)showMenu
{
    self.isMenuShown = YES;
    self.hideMenuTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideMenu) userInfo:nil repeats:NO];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame;
        frame = self.menu.frame;
        frame.origin.y -= (self.menu.frame.size.height);
        self.menu.frame=frame;
    }
    completion:^ (BOOL finished) {}
    ];
}



- (void)didPressLikeButton
{
    self.isMovieLiked = YES;
    self.likeImage.image = [UIImage imageNamed:@"LikeSelected.png"];
    self.nextImage.hidden = NO;
    self.nextButton.enabled = YES;
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
        if (!self.isMenuShown)
            [self showMenu];
    }
}

- (void)didPressNextButton
{
    self.pauseImage.hidden = NO;
    self.pauseButton.enabled = YES;
    self.playImage.hidden = YES;
    self.playButton.enabled = NO;
    self.isMovieLiked = NO;
    self.isMoviePaused = NO;
    self.nextImage.hidden = YES;
    self.nextButton.enabled = NO;
    self.likeImage.image = [UIImage imageNamed:@"Like.png"];
    [self.hideMenuTimer invalidate];
    self.hideMenuTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideMenu) userInfo:nil repeats:NO];
    [self.moviePlayer.view removeFromSuperview];
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
    [self.moviePlayer.view addGestureRecognizer:self.tap];
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

- (void)didPressPauseButton
{
    self.isMoviePaused = YES;
    [self.moviePlayer pause];
    self.pauseImage.hidden = YES;
    self.pauseButton.enabled = NO;
    self.playImage.hidden = NO;
    self.playButton.enabled = YES;
}

- (void)didPressPlayButton
{
    self.isMoviePaused = NO;
    [self.moviePlayer play];
    self.pauseImage.hidden = NO;
    self.pauseButton.enabled = YES;
    self.playImage.hidden = YES;
    self.playButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
