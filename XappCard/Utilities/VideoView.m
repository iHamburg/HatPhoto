//
//  VideoView.m
//  Webmoebel
//
//  Created by Michael Zapf on 31.06.11.
//  Copyright 2011 mimagazine. All rights reserved.
//

#import "VideoView.h"

@interface VideoView ()


@property (nonatomic, strong) UIImageView* imageView;


- (void)initialize;
- (void)movieLoadStateDidChange:(NSNotification*)notification;
- (void)moviePlaybackStateDidChange:(NSNotification*)notification;
- (void)moviePlayBackDidFinish:(NSNotification*)notification;
- (void)setViews;
- (NSString*)stringWithState;

@end


@implementation VideoView
@synthesize moviePlayer;
@synthesize startupImage;
@synthesize videoUrl;
@synthesize videoFileName;
@synthesize imageView;
@synthesize enableControls;
@synthesize delegate;
//@synthesize playing;

- (void)setEnableControls:(BOOL)value{
	enableControls = value;
	self.moviePlayer.controlStyle = (value)?MPMovieControlStyleDefault:MPMovieControlStyleNone;
}

- (UIImageView*)imageView {
	if (imageView == nil) {
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:imageView];
	}
	return imageView;
}


- (BOOL)playing{
   // DLog(@"playing:%d",moviePlayer.playbackState);
    if (moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
        return YES;
    }
    else 
        return NO;
}

#define kButtonSizeThreshhold	400

- (void)setStartupImage:(UIImage *)value {
	if (value == startupImage) {
		return;
	}
	
	startupImage = value;
	self.imageView.image = startupImage;
}

- (id)initWithCoder:(NSCoder*)coder {
  
	if ((self = [super initWithCoder:coder])) {
		[self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
        [self initialize];
    }
    return self;
}
	
- (NSString*)stringWithState {
	NSMutableString* stateString = [NSMutableString stringWithString:@"- playbackState = < "];
	switch (self.moviePlayer.playbackState) {
		case MPMoviePlaybackStateStopped:
			[stateString appendString:@"MPMoviePlaybackStateStopped"];
			break;
		case MPMoviePlaybackStatePlaying:
			[stateString appendString:@"MPMoviePlaybackStatePlaying"];
			break;
		case MPMoviePlaybackStatePaused:
			[stateString appendString:@"MPMoviePlaybackStatePaused"];
			break;
		case MPMoviePlaybackStateInterrupted:
			[stateString appendString:@"MPMoviePlaybackStateInterrupted"];
			break;
		case MPMoviePlaybackStateSeekingForward:
			[stateString appendString:@"MPMoviePlaybackStateSeekingForward"];
			break;
		case MPMoviePlaybackStateSeekingBackward:
			[stateString appendString:@"MPMoviePlaybackStateSeekingBackward"];
			break;
	}
	
	[stateString appendString:@" > - loadState = < "];
	if (self.moviePlayer.loadState == MPMovieLoadStateUnknown) {
		[stateString appendString:@"MPMovieLoadStateUnknown "];
	}
	if (self.moviePlayer.loadState & MPMovieLoadStatePlayable) {
		[stateString appendString:@"MPMovieLoadStatePlayable "];
	}
	if (self.moviePlayer.loadState & MPMovieLoadStatePlaythroughOK) {
		[stateString appendString:@"MPMovieLoadStatePlaythroughOK "];
	}
	if (self.moviePlayer.loadState & MPMovieLoadStateStalled) {
		[stateString appendString:@"MPMovieLoadStateStalled "];
	}
	[stateString appendString:@">"];
	return stateString;
}

- (id)init {
    L();
	if ((self = [super init])) {
		[self initialize];
	}
	
	return self;
}

- (void)initialize {
   // L();
	self.enableControls = NO;
	
	// Register to receive a notification that the movie is now in memory and ready to play
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(movieLoadStateDidChange:) 
												 name:MPMoviePlayerLoadStateDidChangeNotification 
											   object:nil];
	
	// Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlaybackStateDidChange:) 
												 name:MPMoviePlayerPlaybackStateDidChangeNotification 
											   object:nil];
	
	// Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayWillEnterFullscreen:) 
												 name:MPMoviePlayerWillEnterFullscreenNotification 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayWillExitFullscreen:) 
												 name:MPMoviePlayerWillExitFullscreenNotification
											   object:nil];
    
  //  L();
   // DLog(@"View:%@",NSStringFromCGRect(self.frame));
    
}



- (void)layoutSubviews {
	
    [super layoutSubviews];
	self.imageView.frame = self.bounds;
    
}

/*
 enum {
 MPMovieLoadStateUnknown        = 0,
 MPMovieLoadStatePlayable       = 1 << 0,
 MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
 MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
 };
 typedef NSInteger MPMovieLoadState;
 
enum {
 MPMoviePlaybackStateStopped,
 MPMoviePlaybackStatePlaying,
 MPMoviePlaybackStatePaused,
 MPMoviePlaybackStateInterrupted,
 MPMoviePlaybackStateSeekingForward,
 MPMoviePlaybackStateSeekingBackward
 };
 typedef NSInteger MPMoviePlaybackState;

*/

- (void)setViews {
   // L();

	
	//if playing: decide on load state
	if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
	//	DLog(@"playstate == playing");
		//if still not loading of interruped for loading
		if (self.moviePlayer.loadState & MPMovieLoadStatePlaythroughOK && !(self.moviePlayer.loadState & MPMovieLoadStateStalled)) {
      //      DLog(@"show moviewPlayer");
			self.moviePlayer.view.hidden = NO;
			//[self hideActivityIndicator];
		}
		else {
			//[self showActivityIndicator];
     //       DLog(@"Error: loadstate!=Stalled");
		}
     
//		NSLog(@"video:%@",moviePlayer.view);
	}
    /*
	//if paused: stay on vieoView and hide others
	else if (self.moviePlayer.playbackState == MPMoviePlaybackStatePaused) {
		
		[UIView fadeOut:[NSArray arrayWithObject:self.imageView] withDuration:0.2f];
	}
	//if stopped...:hide videView and show others
	else if (self.moviePlayer.playbackState == MPMoviePlaybackStateStopped) {
        //DLog(@"")
		[UIView fadeIn:[NSArray arrayWithObject:self.imageView] withDuration:1.0f];
	}
	else {
		NSLog(@"[VideoView setViews] unhandled state");
	}
     */
}

#pragma mark -
#pragma mark Notifications

//  Notification called when the movie finished preloading.
- (void)movieLoadStateDidChange:(NSNotification*)notification {	
	MPMoviePlayerController* moviePlayerObj=[notification object];
	if (moviePlayerObj != self.moviePlayer) {
		return;
	}
	
//	NSLog(@"[VideoView movieLoadStateDidChange for player 0x%x] %@",self.moviePlayer, [self stringWithState]);
	[self setViews];
}

- (void)moviePlaybackStateDidChange:(NSNotification*)notification {
	MPMoviePlayerController* moviePlayerObj=[notification object];
	if (moviePlayerObj != self.moviePlayer) {
		return;
	}
	
//	NSLog(@"[VideoView moviePlaybackStateDidChange for player 0x%x] %@", self.moviePlayer, [self stringWithState]);
	[self setViews];
	
	if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying && [self.delegate respondsToSelector:@selector(videoViewDidStartPlaying:)]) {
      
		[self.delegate videoViewDidStartPlaying:self];
	}
	
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePaused && [self.delegate respondsToSelector:@selector(videoViewDidPausePlaying:)]) {
    
        [self.delegate videoViewDidPausePlaying:self];
        
    }
    
	if (self.moviePlayer.playbackState == MPMoviePlaybackStateStopped) {
		[self performSelector:@selector(destroyMoviePlayer) withObject:nil afterDelay:0.0]; //better safe than sorry ;)
	}
    
}

//  Notification called when the movie finished playing.
- (void)moviePlayBackDidFinish:(NSNotification*)notification {
	MPMoviePlayerController* moviePlayerObj=[notification object];
	if (moviePlayerObj != self.moviePlayer) {
	//	NSLog(@"%s other moviePlayer finished, doing nothing: 0x%x", __FUNCTION__, moviePlayerObj);
		return;
	}
	
	//NSLog(@"%s 0x%x %@", __FUNCTION__, moviePlayerObj, [self stringWithState]);

	//stop movie and don't call setViews: because no state has changed yet
	self.moviePlayer.shouldAutoplay = NO;
    [self.moviePlayer stop];
    
  //  if (self.delegate!=nil&& ![self.delegate isKindOfClass:[NSNull class]]) {
  //      DLog(@"Video.delegate:%@",self.delegate);
        if ([self.delegate respondsToSelector:@selector(videoViewDidFinishPlaying:)]) {
            [self.delegate videoViewDidFinishPlaying:self];
        }
   // }
	
}


- (void)destroyMoviePlayer {
	
	//NSLog(@"destroying movie player 0x%x", moviePlayer);
	
	//maybe reset from fullscreen
	if (self.moviePlayer.fullscreen) {
		[self.moviePlayer setFullscreen:NO animated:YES];
	}
	
	[moviePlayer.view removeFromSuperview];
	self.moviePlayer = nil;
}

#pragma mark -
#pragma mark Fullscreen
//enable the control only in fullscreen mode
//because the controls are aliased in non fullscreen mode
- (void)moviePlayWillEnterFullscreen:(NSNotification*)notification {
  //  L();
	MPMoviePlayerController* moviePlayerObj=[notification object];
	if (moviePlayerObj != self.moviePlayer) {
		return;
	}

	
	self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
}

- (void)moviePlayWillExitFullscreen:(NSNotification*)notification {
	MPMoviePlayerController* moviePlayerObj=[notification object];
	if (moviePlayerObj != self.moviePlayer) {
		return;
	}
	
	self.moviePlayer.controlStyle = MPMovieControlStyleNone;
}

#pragma mark -
#pragma mark Movie Control

- (void)play {
	
	if (moviePlayer == nil && videoUrl != nil) {
		moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoUrl];
		
	//	NSLog(@"created player 0x%x", moviePlayer);
		
		self.moviePlayer.controlStyle = MPMovieControlStyleNone;	//due aliasing of controlBar use this only in fullscreen mode when view isn't rotated
		//self.moviePlayer.repeatMode = MPMovieRepeatModeNone;
        self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
		self.moviePlayer.shouldAutoplay = YES;
		self.moviePlayer.view.frame = self.bounds;
		self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
//		self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		self.moviePlayer.useApplicationAudioSession = NO;
        self.moviePlayer.backgroundView.backgroundColor = [UIColor clearColor];
		self.moviePlayer.view.hidden = YES;	//hide at first
      
        
		[self insertSubview:moviePlayer.view aboveSubview:self.imageView];
      //  [self insertSubview:moviePlayer.view belowSubview:self.imageView];
	}
	
	if (self.moviePlayer.playbackState != MPMoviePlaybackStatePlaying) {
		self.moviePlayer.shouldAutoplay = YES;
		[self.moviePlayer play];
      //  [self performSelector:@selector(showVideoView) withObject:nil afterDelay:5];
	}
}

- (void)pause {
	if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
		[self.moviePlayer pause];
	}
}

- (void)stop {
	self.moviePlayer.shouldAutoplay = NO;
	[self.moviePlayer stop];
}

#pragma mark -
#pragma mark Control Buttons 


- (void)dealloc {
    L();
	self.startupImage = nil;
	
	// remove all movie notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerLoadStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillEnterFullscreenNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:nil];
	
}

#pragma mark - Intern
- (void)setRepeatMode:(BOOL)repeat{
    
   // L();
    // self.moviePlayer.repeatMode = MPMovieRepeatModeNone;
    if (repeat) {
        self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    }
    else{
        self.moviePlayer.repeatMode = MPMovieRepeatModeNone;
    }
}

- (void)showVideoView{
    L();
    //self.moviePlayer.view.hidden = NO;
   // self.imageView.hidden = YES;
}
@end
