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

@interface Player : UIViewController
+ (Player*)player;
@property   MPMoviePlayerController  *moviePlayer;
@property   UIImageView              *footer;
@property   UIImageView              *playIcon;
@property   NSInteger                 movieNumber;
@property   UIButton                 *playPauseButton;
@property   UIButton                 *nextButton;
@property   BOOL                      didPressNextMovieButton;
@end
