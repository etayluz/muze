//
//  Player.h
//  muzeme
//
//  Created by Etay Luz on 5/15/14.
//  Copyright (c) 2014 com.luzsoft.muzeme. All rights reserved.
//

#import "YTPlayerView.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Player : UIViewController <UIAlertViewDelegate, UIGestureRecognizerDelegate, YTPlayerViewDelegate>
+ (Player*)player;
-(void)showMenu;
- (void)didPressNextButton;
@property   MPMoviePlayerController  *moviePlayer;
@property   UIView                   *menu;
@property   NSInteger                 movieNumber;
@property   UIButton                 *playPauseButton;
@property   UIButton                 *nextButton;
@property   UIButton                 *dislikeButton;
@property   UIButton                 *likeButton;
@property   UIButton                 *mailButton;
@property   UIButton                 *pauseButton;
@property   UIButton                 *playButton;
@property   UIButton                 *hideHelpButton;
@property   UIImageView              *nudge;
@property   UIImageView              *dislikeImage;
@property   UIImageView              *pauseImage;
@property   UIImageView              *nextImage;
@property   UIImageView              *playImage;
@property   UIImageView              *likeImage;
@property   BOOL                      movieWillStartPlaying;
@property   BOOL                      movieDidStartPlaying;
@property   BOOL                      isMoviePaused;
@property   BOOL                      isMovieLiked;
@property   BOOL                      isMenuShown;
@property   BOOL                      isHelpDone;
@property   NSTimer                  *hideMenuTimer;
@property   BOOL                      isError;
@property   UITapGestureRecognizer   *tap;
@property   UISwipeGestureRecognizer *swipeUp;
@property   UISwipeGestureRecognizer *swipeDown;
@property   UIView                   *helpOverlay;
@property(nonatomic, strong)        YTPlayerView *playerView;


@end
