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

//- (NSMutableArray*)availableHatCategorys{
//	[availableHatCategorys removeAllObjects];
//	
//	for (HatCategory *cat in hatCategorys) {
//		if (cat.available) {
//			[availableHatCategorys addObject:cat];
//		}
//	}
//	
//	return availableHatCategorys;
//}


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
//		availableHatCategorys = [NSMutableArray array];
		
		_availableHatImageNames = [NSMutableArray array];
	
		NSArray *hatCategoryArray = materialDict[@"HatCategories"];
		for (NSDictionary *dict in hatCategoryArray) {
			HatCategory *cat = [[HatCategory alloc]initWithDictionary:dict];
			[hatCategorys addObject:cat];
			
//			if (cat.available) {
//				[_availableHatImageNames addObjectsFromArray:cat.availableImgNames];
//			}
		}
		
//		NSLog(@"men available # %@, unavailable # %@",[hatCategorys[0] availableImgNames],[hatCategorys[0] unavailableImgNames]);
//
//		NSArray *hatArray = materialDict[@"Hat_Valentine"];
//		HatCategory *cat = [[HatCategory alloc]init];
//		cat.name = @"Valentine";
//		cat.hatImgNames = [NSMutableArray arrayWithArray:hatArray];
//		[hatCategorys addObject:cat];
//	
//		
//		cat = [[HatCategory alloc]init];
//		cat.name = @"Others";
//		hatArray = materialDict[@"Hat_Others"];
//		cat.hatImgNames = [NSMutableArray arrayWithArray:hatArray];
//		[hatCategorys addObject:cat];
//	
//		cat = [[HatCategory alloc]init];
//		cat.name = @"Temp";
//		hatArray = materialDict[@"Hat_Temp"];
//		cat.hatImgNames = [NSMutableArray arrayWithArray:hatArray];
//		[hatCategorys addObject:cat];
//	
//		cat = [[HatCategory alloc]init];
//		cat.name = @"New";
//		NSMutableArray *imgNames = [NSMutableArray array];
//		for (int i = 1; i<=50; i++) {
//			[imgNames addObject:[NSString stringWithFormat:@"Hat_new_%d.png",i]];
//		}
//		[hatCategorys addObject:cat];
//		cat.hatImgNames = imgNames;
//	
//		if (cat.available) {
//			[_availableHatImageNames addObjectsFromArray:cat.hatImgNames];
//		}
////		NSLog(@"hatOthers # %@",hatOthersImgNames);
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
