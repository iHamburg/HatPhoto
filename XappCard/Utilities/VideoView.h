//
//  VideoView.h
//  Webmoebel
//
//  Created by Michael Zapf on 10.06.11.
//  Copyright 2011 mimagazine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

#import "Controller.h"

@protocol VideoViewDelegate;

@interface VideoView : UIView {

}

@property (nonatomic, readonly) BOOL playing;
@property (nonatomic, copy) NSURL* videoUrl;
@property (nonatomic, copy) NSString* videoFileName;
@property (nonatomic, strong) UIImage* startupImage;
@property (nonatomic, assign) BOOL enableControls;
@property (nonatomic, unsafe_unretained) IBOutlet id <VideoViewDelegate> delegate;
@property (nonatomic, strong) MPMoviePlayerController* moviePlayer;

- (void)play;
- (void)pause;
- (void)stop;

- (void)showVideoView;
- (void)setRepeatMode:(BOOL)repeat;
- (void)destroyMoviePlayer;
@end

@protocol VideoViewDelegate <NSObject>

@optional

- (void)videoViewDidStartPlaying:(VideoView*)videoView;
- (void)videoViewDidFinishPlaying:(VideoView*)videoView;
- (void)videoViewDidPausePlaying:(VideoView*)videoView;

@end
