//
//  SpriteManager.m
//  XappCard_2_0
//
//  Created by  on 17.03.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "SpriteManager.h"
#import "RootViewController.h"
#import "HatCategory.h"

@implementation SpriteManager


//@synthesize hatCategoryFont;
@synthesize hatCategorys;




+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (id)init{
	
	if (self = [super init]) {

		
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
		NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
		
		
		hatCategorys = [NSMutableArray array];

		_availableHatImageNames = [NSMutableArray array];
	
		NSArray *hatCategoryArray = materialDict[@"HatCategories"];
		for (NSDictionary *dict in hatCategoryArray) {
			HatCategory *cat = [[HatCategory alloc]initWithDictionary:dict];
			[hatCategorys addObject:cat];
        }
	}
	return self;
}




- (NSString*)randomHatImageName{
//	UIImage *image;
	int index = arc4random()%[_availableHatImageNames count];
	while (index == _lastRandomIndex) {
		index = arc4random()%[_availableHatImageNames count];
	}
	_lastRandomIndex = index;
//	NSLog(@"all # %d,randomIndex # %d",[_availableHatImageNames count],index);
	return _availableHatImageNames[index];
}

@end
