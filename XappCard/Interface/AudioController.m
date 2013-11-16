//
//  AudioController.m
//  FirstThings_Uni
//
//  Created by  on 11.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AudioController.h"

@implementation AudioController


// 事先将所有player都init好

- (id)init{
	if (self = [super init]) {

		NSArray *audioNames = [NSArray arrayWithObjects:@"Shake.mp3",nil];
		
		for(int i=0;i<[audioNames count];i++){
			SystemSoundID soundid = 0;
			NSURL *soundURL = [NSURL urlWithFilename:[audioNames objectAtIndex:i]];

			AudioServicesCreateSystemSoundID( (__bridge CFURLRef)(soundURL), &soundid);
			_audioIDs[i] = soundid;
			
		}
		
	}
	return self;
}

+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (void)play:(AudioType)type delegate:(id)delegate{

	AVAudioPlayer *player = [audioPlayers objectAtIndex:type];
	
	player.delegate = delegate;
	
	[player play];


}

- (void)playAudio:(AudioType)type{
	SystemSoundID soundid = _audioIDs[type];
	AudioServicesPlaySystemSound(soundid);
}

@end
