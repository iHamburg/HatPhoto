//
//  SpriteManager.h
//  XappCard_2_0
//
//  Created by  on 17.03.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"
#import "HatCategory.h"


@interface SpriteManager : NSObject{

	
	int _lastRandomIndex;
	NSMutableArray *_availableHatImageNames;
}

@property (nonatomic, strong) NSMutableArray *hatCategorys;


+(id)sharedInstance;

- (NSString*)randomHatImageName;

@end
