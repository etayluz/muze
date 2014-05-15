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
    
    /* FOOTER */
    self.footer = [[UIImageView alloc] init];
    self.footer.image = [UIImage imageNamed:@"buttomBar.png"];
    self.footer.frame = CGRectMake(0.0, self.view.frame.size.height - self.footer.image.size.height*0.7, 320.0, self.footer.image.size.height*0.7);
    self.footer.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.footer];
    
    /* MOVIE PLAYER */
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://etayluz.com/1.3gp"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidStartPlaying)
                                                 name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                               object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinishPlaying) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//MPMovieScalingModeAspectFit; // MPMovieScalingModeAspectFit
    self.moviePlayer.view.frame = CGRectMake(0,0,320,self.view.frame.size.height - self.footer.frame.size.height);
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;//MPMovieControlStyleNone,MPMovieControlStyleDefault
    [self.moviePlayer prepareToPlay];

    [self.view addSubview:self.moviePlayer.view];
    
    /* DISLIKE BUTTON */
    UIButton *dislikeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dislikeButton addTarget:self
                   action:@selector(didPressDislikeButton)
         forControlEvents:UIControlEventTouchDown];
    dislikeButton.frame = CGRectMake(0, self.moviePlayer.view.frame.size.height, 80,self.footer.frame.size.height);
    CALayer * layer1 = [dislikeButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:dislikeButton];
    
    /* LIKE BUTTON */
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [likeButton addTarget:self
                   action:@selector(didPressLikeButton)
         forControlEvents:UIControlEventTouchDown];
    likeButton.frame = CGRectMake(80, self.moviePlayer.view.frame.size.height, 50,self.footer.frame.size.height);
    CALayer * layer2 = [likeButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:likeButton];
    
    /* PLAY ICON */
    self.playIcon = [[UIImageView alloc] init];
    self.playIcon.image = [UIImage imageNamed:@"play.png"];
    self.playIcon.frame = CGRectMake(215,self.moviePlayer.view.frame.size.height, 10, self.footer.image.size.height*0.7);
    self.playIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.playIcon.hidden = YES;
    [self.view addSubview:self.playIcon];
    
    /* PLAY AND PAUSE BUTTON */
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.playPauseButton addTarget:self
                   action:@selector(didPressPlayPauseButton)
         forControlEvents:UIControlEventTouchDown];
    self.playPauseButton.frame = CGRectMake(190,self.moviePlayer.view.frame.size.height, 55, self.footer.image.size.height*0.7);
    layer2 = [self.playPauseButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.view addSubview:self.playPauseButton];
    
    /* NEXT BUTTON */
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.nextButton addTarget:self
                             action:@selector(didPressNextButton)
                   forControlEvents:UIControlEventTouchDown];
    self.nextButton.frame = CGRectMake(320-70,self.moviePlayer.view.frame.size.height, 70, self.footer.image.size.height*0.7);
    layer2 = [self.nextButton layer];
    //[layer2 setBorderWidth:1.0];
    [layer2 setBorderColor:[[UIColor blackColor] CGColor]];
    self.nextButton.hidden = YES;
    [self.view addSubview:self.nextButton];
}


- (void)movieDidStartPlaying
{
//    NSLog(@"%ld", (long)self.moviePlayer.playbackState);
//    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    self.footer.image = [UIImage imageNamed:@"buttomBarSelected.png"];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];

    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://etayluz.com/2.3gp"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidStartPlaying)
                                                     name:MPMoviePlayerNowPlayingMovieDidChangeNotification
                                                   object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinishPlaying) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    self.moviePlayer.view.frame = CGRectMake(0,0,320,self.view.frame.size.height - self.footer.frame.size.height);
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:self.moviePlayer.view];
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];
    [self.moviePlayer prepareToPlay];
    self.footer.image = [UIImage imageNamed:@"buttomBar.png"];
}

- (void) didPressPlayPauseButton
{
    if (self.playIcon.hidden == YES)
    {
        [self.moviePlayer pause];
        self.playIcon.hidden = NO;
    }
    else
    {
        [self.moviePlayer play];
        self.playIcon.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
