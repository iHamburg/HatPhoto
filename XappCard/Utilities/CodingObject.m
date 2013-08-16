//
//  CodingObject.m
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingObject.h"

@implementation CodingObject

@synthesize keys;

//object第一此被调用,会由firstLoad

- (id)init{
//	L();
	if (self = [super init]) {
		[self firstLoad];
		
		// load 会定义keys
		[self load];
		
		// setup maybe unnecessary
		[self setup];
	}
	return self;
}


//如果是被loadArchived调用的load

- (id)initWithCoder:(NSCoder *)aDecoder{
	
	// without firstload, but keys will be initialized in "load"
	[self load];
	NSMutableArray *emptyKeys = [NSMutableArray array];

	for (int i = 0; i<[keys count]; i++) {
		
		NSString *key = [keys objectAtIndex:i];

		if (![aDecoder decodeObjectForKey:key]) {
			[emptyKeys addObject:key];
		}
		else
			[self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
		
	}
	
	// load the new key for update version
	[self loadEmptyKeys:emptyKeys];
	
	// load non-object: int, boolean
	[self loadOthers:aDecoder];
	
	[self setup];
	
	return self;
}

- (void)firstLoad{}

- (void)load{
	keys = [NSMutableArray array];
}

- (void)loadEmptyKeys:(NSArray*)emptyKeys{
	
}

- (void)loadOthers:(NSCoder*)aDecoder{
	
}

- (void)setup{
	
}

#pragma mark - Save

// 要求:在Controller调用saveArchived时会调用encode来save object
// 如果是array或是dictionary的话可以直接调用writefofile,当然保存的object都要是能够save的!

- (void) encodeWithCoder: (NSCoder *)coder
{
	// 处理保存前的设置:比如说UIImageView的设置image = nil

	[self willSave];
	
	// 默认保存所有的NSObject
	for (int i = 0; i<[keys count]; i++) {
		NSString *key = [keys objectAtIndex:i];

		[coder encodeObject:[self valueForKey:key] forKey:key];
	}
	
	// 保存int,bool等非NSObject
	[self saveOthers:coder];
}

- (void)saveOthers:(NSCoder *)coder{
	
}
- (void)willSave{}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone{
	
	CodingObject* clone =[[[self class] allocWithZone:zone] init];
	
	clone.keys = self.keys;
	
	return clone;
}

- (NSString*)description{

	NSString *description = [NSString string];
	for (int i = 0; i<[keys count]; i++) {
		NSString *key = [keys objectAtIndex:i]; 
		description = [description stringByAppendingFormat:@"%@:%@\n",key,[self valueForKey:key]];
	}
//	[setting description];
	
	return description;

}
@end
