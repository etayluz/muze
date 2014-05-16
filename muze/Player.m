//
//  Player.m
//  muzeme
//
//  Created by Etay Luz on 5/15/14.
//  Copyright (c) 2014 com.luzsoft.muzeme. All rights reserved.
//

#import "Player.h"
#import "AppDelegate.h"

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
    self.didPressNextMovieButton = NO;
    self.isMovieLiked = NO;
    self.isMoviePaused = NO;
    
    /* FOOTER */
    self.footer = [[UIImageView alloc] init];
    self.footer.image = [UIImage imageNamed:@"buttomBar.png"];
    self.footer.frame = CGRectMake(0,320-70,self.view.frame.size.height,70); // +(self.view.frame.size.height-100*4.9) 480
    //self.footer.bounds = CGRectMake(160,320-70,100,70);
    // origin starts at 160; the width seems to be multiplied by 4.9
    //self.footer.frame = CGRectMake(0.0, 320 - self.footer.image.size.height*0.7, 320.0, self.footer.image.size.height*0.7);
    self.footer.contentMode = UIViewContentModeScaleToFill;
    self.footer.alpha = 0.5;
    
    /* MOVIE PLAYER */
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://etayluz.com/1.3gp"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieNowPlaying)
                                                 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                               object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinishPlaying) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
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
    [self.view addSubview:self.footer];
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];

    /* DISLIKE BUTTON */
    self.dislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dislikeButton addTarget:self
                   action:@selector(didPressDislikeButton)
         forControlEvents:UIControlEventTouchDown];
    self.dislikeButton.frame = CGRectMake(self.view.frame.size.height*0.05, self.footer.frame.origin.y, 85,self.footer.frame.size.height);
    CALayer * layer1 = [self.dislikeButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:self.dislikeButton];
    
    /* LIKE BUTTON */
    self.likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.likeButton addTarget:self
                   action:@selector(didPressLikeButton)
         forControlEvents:UIControlEventTouchDown];
    self.likeButton.frame = CGRectMake(self.view.frame.size.height*0.24, self.footer.frame.origin.y, 80,self.footer.frame.size.height);
    CALayer * layer2 = [self.likeButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:self.likeButton];
    
    /* MAIL BUTTON */
    self.mailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mailButton addTarget:self
                        action:@selector(didPressDislikeButton)
              forControlEvents:UIControlEventTouchDown];
    layer1 = [self.mailButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.mailButton setBackgroundImage:[UIImage imageNamed:@"Mail.png"] forState:UIControlStateNormal];
    self.mailButton.frame = CGRectMake(self.view.frame.size.height*0.44, self.footer.frame.origin.y+20, 256/4,30);
    self.mailButton.alpha = 0.35;
    [self.view addSubview:self.mailButton];
    
    /* PLAY AND PAUSE BUTTON */
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.playPauseButton addTarget:self
                   action:@selector(didPressPlayPauseButton)
         forControlEvents:UIControlEventTouchDown];
    self.playPauseButton.frame = CGRectMake(self.view.frame.size.height*0.60,self.footer.frame.origin.y, 70, self.footer.image.size.height);
    layer2 = [self.playPauseButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:self.playPauseButton];
    
    /* NEXT BUTTON */
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton addTarget:self
                             action:@selector(didPressNextButton)
                   forControlEvents:UIControlEventTouchDown];
    self.nextButton.frame = CGRectMake(self.view.frame.size.height*0.80,self.footer.frame.origin.y, 80, self.footer.image.size.height);
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


- (void)movieNowPlaying
{
//    NSLog(@"%ld", (long)self.moviePlayer.playbackState);
//    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    NSLog(@"movieNowPlaying");
    self.movieDidStartPlaying = YES;
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

-(void)hideControls
{
    self.isControlsShown = NO;
    self.footer.hidden = YES;
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.playPauseButton.enabled = NO;
    self.nextButton.enabled = NO;
    self.mailButton.hidden = YES;
}

-(void)showControls
{
    self.isControlsShown = YES;
    self.footer.hidden = NO;
    self.likeButton.enabled = YES;
    self.dislikeButton.enabled = YES;
    self.playPauseButton.enabled = YES;
    self.nextButton.enabled = YES;
    self.mailButton.hidden = NO;
    [self.hideControlsTimer invalidate];
    self.hideControlsTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
}

- (void)movieDidFinishPlaying
{
    if (self.didPressNextMovieButton == NO)
        [self didPressNextButton];
    else
        self.didPressNextMovieButton = NO;
}

- (void)didPressLikeButton
{
    if (self.isMoviePaused)
        self.footer.image = [UIImage imageNamed:@"buttomBarSelectedPlay.png"];
    else
        self.footer.image = [UIImage imageNamed:@"buttomBarSelected.png"];
    self.isMovieLiked = YES;

    self.nextButton.hidden = NO;
}

- (void)didPressDislikeButton
{
    [self didPressNextButton];

}

- (void)didPressNextButton
{
    self.didPressNextMovieButton = YES;
    [self.moviePlayer pause];
    [self.moviePlayer.view removeFromSuperview];
    self.isMovieLiked = NO;
    self.isMoviePaused = NO;
    self.nextButton.hidden = YES;
    self.footer.image = [UIImage imageNamed:@"buttomBar.png"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://etayluz.com/%ld.3gp", (long)self.movieNumber++]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieNowPlaying)
                                                     name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                                   object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinishPlaying) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerStateDidChange)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayer.view.frame = CGRectMake(0,0,self.view.frame.size.height,320);
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    //[self.view addSubview:self.moviePlayer.view];
    [self.view insertSubview:self.moviePlayer.view atIndex:0];
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];
    [self.moviePlayer prepareToPlay];
    self.footer.image = [UIImage imageNamed:@"buttomBar.png"];
}

- (void)didPressPlayPauseButton
{
    if (self.isMoviePaused == NO)
    {
        [self.moviePlayer pause];
        self.isMoviePaused = YES;
        if (self.isMovieLiked)
            self.footer.image = [UIImage imageNamed:@"buttomBarSelectedPlay.png"];
        else
            self.footer.image = [UIImage imageNamed:@"buttomBarPlay.png"];
    }
    else
    {
        [self.moviePlayer play];
        self.isMoviePaused = NO;
        if (self.isMovieLiked)
            self.footer.image = [UIImage imageNamed:@"buttomBarSelected.png"];
        else
            self.footer.image = [UIImage imageNamed:@"buttomBar.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
