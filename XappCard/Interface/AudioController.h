//
//  AudioController.h
//  FirstThings_Uni
//
//  Created by  on 11.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import  <AVFoundation/AVFoundation.h>
#import "Utilities.h"
#import <AudioToolbox/AudioToolbox.h>

typedef enum{
	AudioTypeShake
}AudioType;

@interface AudioController : NSObject{

	NSArray *audioPlayers;


	SystemSoundID _audioIDs[1];
}

+(id)sharedInstance;

- (void)play:(AudioType)type delegate:(id)delegate;
- (void)playAudio:(AudioType)type;

@end
