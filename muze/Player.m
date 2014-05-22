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
    self.isMovieLiked = NO;
    self.isHelpDone = NO;
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
    
    /* YOUTUBE PLAYER */
    self.youTubePlayer = [[YTPlayerView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.height,600)];
    NSDictionary *playerVars = @{@"playsinline" : @1,@"autoplay":@1,@"controls":@0,@"iv_load_policy":@3,@"modestbranding":@1,@"showinfo":@0,@"cc_load_policy":@0,@"enablejsapi":@1,@"vq":@"large",@"rel":@0};
    [self.youTubePlayer loadWithVideoId:@"6sii6TcrS3I" playerVars:playerVars];//BW-tzEKwD7g//Bt9zSfinwFA
    self.youTubePlayer.backgroundColor = [UIColor redColor];
    self.youTubePlayer.delegate = self;
    self.youTubePlayer.hidden = YES;
    self.youTubePlayer.userInteractionEnabled = NO;
    self.youTubePlayer.tag = 1;
    [self.view addSubview:self.youTubePlayer];
   
    /* YOUTUBE PLAYER 2 */
    self.youTubePlayer2 = [[YTPlayerView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.height,600)];
    self.youTubePlayer2.backgroundColor = [UIColor redColor];
    self.youTubePlayer2.delegate = self;
    self.youTubePlayer2.hidden = YES;
    self.youTubePlayer2.userInteractionEnabled = NO;
    self.youTubePlayer2.tag = 2;
    //[self.view addSubview:self.youTubePlayer2];
    
    /* YOUTUBE VIDEO COVER */
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 320)];
    [self.view addSubview:self.cover];
    [self.view addSubview:self.nudge];
    [self.view addSubview:self.menu];
    
    /* GESTURES */
    self.tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(didPressMovie)];
    self.tap.delegate = self;
    self.swipeUp = [[UISwipeGestureRecognizer alloc]
                    initWithTarget:self action:@selector(didSwipeUp)];
    [self.swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    self.swipeDown = [[UISwipeGestureRecognizer alloc]
                      initWithTarget:self action:@selector(didSwipeDown)];
    [self.swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.cover addGestureRecognizer:self.tap];
    [self.cover addGestureRecognizer:self.swipeDown];
    [self.cover addGestureRecognizer:self.swipeUp];
    
    /* HELP OVERLAY VIEW */
    self.helpOverlay = [[UIView alloc] init];
    self.helpOverlay.frame = CGRectMake(0,0,self.view.frame.size.height,320);
    self.helpOverlay.backgroundColor = [UIColor blackColor];
    self.helpOverlay.alpha = 0.6;

    /* HELP OVERLAY IMAGE */
    UIImageView *helpImage  = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.height-568)*-1/7, -20, self.view.frame.size.height, 320)];
    helpImage.image = [UIImage imageNamed:@"Help.png"];
    helpImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.helpOverlay addSubview:helpImage];
    
    /* HIDE HELP BUTTON */
    self.hideHelpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hideHelpButton addTarget:self
                        action:@selector(didPressHideHelpButton)
              forControlEvents:UIControlEventTouchDown];
    self.hideHelpButton.frame = self.helpOverlay.frame;
    layer1 = [self.playButton layer];
    //[layer1 setBorderWidth:1.0];
    [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
    [self.helpOverlay addSubview:self.hideHelpButton];
    
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    NSLog(@"Tag=%ld", (long)playerView.tag);
    
    if (playerView.tag == 2)
        return;
    switch (state) {
        case kYTPlayerStateUnstarted:
            NSLog(@"kYTPlayerStateUnstarted");
        case kYTPlayerStateEnded:
            NSLog(@"kYTPlayerStateEnded");
            self.pauseImage.hidden = NO;
            self.pauseButton.enabled = YES;
            self.playImage.hidden = YES;
            self.playButton.enabled = NO;
            self.youTubePlayer.hidden = YES;
            [self.youTubePlayer cueVideoById:@"JvxHPtEsmFc" startSeconds:0 suggestedQuality:kYTPlaybackQualityMedium];
            break;
        case kYTPlayerStatePlaying:
            NSLog(@"kYTPlayerStatePlaying");
            self.youTubePlayer.hidden = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.checkLoadedFraction = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkTheLoadedFraction) userInfo:nil repeats:YES];
            break;
        case kYTPlayerStatePaused:
            NSLog(@"kYTPlayerStatePaused");
            break;
        case kYTPlayerStateBuffering:
            NSLog(@"kYTPlayerStateBuffering");
            break;
        case kYTPlayerStateQueued:
            NSLog(@"kYTPlayerStateQueued");
            [self.youTubePlayer playVideo];
            break;
        default:
            //[self.playerView playVideo];
            NSLog(@"default:%u", state);
            break;
    }
    
    //NSString *yourHTMLSourceCodeString = [self.playerView.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    //NSLog(@"%@",yourHTMLSourceCodeString);
}

-(void)checkTheLoadedFraction
{
    float currentTimeToDuration = [self.youTubePlayer currentTime]/[self.youTubePlayer duration];
    float videoLoadedFraction = [self.youTubePlayer videoLoadedFraction];
    NSLog(@"videoLoadedFraction=%f, currentTimeToDuration=%f, Duration=%d, Current=%f",videoLoadedFraction, currentTimeToDuration, [self.youTubePlayer duration], [self.youTubePlayer currentTime]);
    if (currentTimeToDuration <  videoLoadedFraction * 0.3)
    {
        //[self.checkLoadedFraction invalidate];
        NSLog(@"Load Next Video");
        //NSDictionary *playerVars2 = @{@"playsinline" : @1,@"autoplay":@1,@"controls":@0,@"iv_load_policy":@3,@"modestbranding":@1,@"showinfo":@0,@"cc_load_policy":@0,@"enablejsapi":@1,@"vq":@"large",@"rel":@0};
        //[self.youTubePlayer2 loadWithVideoId:@"6sii6TcrS3I" playerVars:playerVars2];//BW-tzEKwD7g//Bt9zSfinwFA

        [self.youTubePlayer2 cueVideoById:@"JvxHPtEsmFc" startSeconds:0 suggestedQuality:kYTPlaybackQualityMedium];

    }
    
    float currentTimeToDuration2 = [self.youTubePlayer2 currentTime]/[self.youTubePlayer duration];
    float videoLoadedFraction2 = [self.youTubePlayer2 videoLoadedFraction];
    NSLog(@"videoLoadedFraction2=%f, currentTimeToDuration2=%f, Duration2=%d, Current2=%f",videoLoadedFraction2, currentTimeToDuration2, [self.youTubePlayer2 duration], [self.youTubePlayer2 currentTime]);
}


- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
     NSLog(@"playerViewDidBecomeReady Tag=%ld",(long)playerView.tag);
    if (playerView.tag == 2)
    {
        [self.youTubePlayer2 playVideo];
        //return;
    }
    [self.youTubePlayer playVideo];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality
{
    NSLog(@"didChangeToQuality");
}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    NSLog(@"receivedError");
}


-(void)didPressHideHelpButton
{
    [self.helpOverlay removeFromSuperview];
    self.hideMenuTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideMenu) userInfo:nil repeats:NO];
    if(self.menu.frame.origin.y == 320)
        [self showMenu];
}

- (void)didPressMovie
{
    if (self.menu.frame.origin.y == 320 - self.menu.frame.size.height)
    {
        [self hideMenu];
        
    }
    else if(self.menu.frame.origin.y >= 320)
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


-(void)didSwipeUp
{
    if(self.menu.frame.origin.y == 320)
        [self showMenu];
}

-(void)didSwipeDown
{
    if (self.menu.frame.origin.y == 320 - self.menu.frame.size.height)
        [self hideMenu];
}

-(void)hideMenu
{
    [self.helpOverlay removeFromSuperview];
    if (!self.isHelpDone)
    {
        self.isHelpDone = YES;
        /* HELP OVERLAY VIEW */
        self.helpOverlay = [[UIView alloc] init];
        self.helpOverlay.frame = CGRectMake(0,0,self.view.frame.size.height,320);
        [self.view addSubview:self.helpOverlay];
        
        /* HELP OVERLAY IMAGE */
        UIImageView *helpImage  = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.height-568)*-1/7, -20, self.view.frame.size.height, 320)];
        helpImage.image = [UIImage imageNamed:@"Help2.png"];
        helpImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.helpOverlay addSubview:helpImage];
        
        /* HIDE HELP BUTTON */
        self.hideHelpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.hideHelpButton addTarget:self
                                action:@selector(didPressHideHelpButton)
                      forControlEvents:UIControlEventTouchDown];
        self.hideHelpButton.frame = self.helpOverlay.frame;
        CALayer *layer1 = [self.playButton layer];
        //[layer1 setBorderWidth:1.0];
        [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
        [self.helpOverlay addSubview:self.hideHelpButton];
    }
    
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
    self.hideMenuTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideMenu) userInfo:nil repeats:NO];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame;
        frame = self.menu.frame;
        frame.origin.y = 320 - self.menu.frame.size.height;
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

- (void)didPressNextButton
{
    [MBProgressHUD showHUDAddedTo:self.view message:@"Loading" animated:YES];
    [self.youTubePlayer stopVideo];
    self.youTubePlayer.hidden = YES;
    return;
}

- (void)didPressPauseButton
{
    [self.youTubePlayer pauseVideo];
    self.pauseImage.hidden = YES;
    self.pauseButton.enabled = NO;
    self.playImage.hidden = NO;
    self.playButton.enabled = YES;
}

- (void)didPressPlayButton
{
    [self.youTubePlayer playVideo];
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
