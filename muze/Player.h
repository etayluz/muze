//
//  Player.h
//  muzeme
//
//  Created by Etay Luz on 5/15/14.
//  Copyright (c) 2014 com.luzsoft.muzeme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Player : UIViewController <UIAlertViewDelegate>
+ (Player*)player;
-(void)showControls;
@property   MPMoviePlayerController  *moviePlayer;
@property   UIImageView              *footer;
@property   NSInteger                 movieNumber;
@property   UIButton                 *playPauseButton;
@property   UIButton                 *nextButton;
@property   UIButton                 *dislikeButton;
@property   UIButton                 *likeButton;
@property   UIButton                 *mailButton;
@property   BOOL                      didPressNextMovieButton;
@property   BOOL                      movieDidStartPlaying;
@property   BOOL                      isMoviePaused;
@property   BOOL                      isMovieLiked;
@property   BOOL                      isControlsShown;
@property   NSTimer                  *hideControlsTimer;
@property   BOOL                      isError;
@end
