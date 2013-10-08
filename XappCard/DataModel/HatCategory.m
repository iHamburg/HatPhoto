//
//  CoverCategory.m
//  MyeCard
//
//  Created by AppDevelopper on 09.01.13.
//
//

#import "HatCategory.h"
#import "Utilities.h"

NSString* const HatCategoryMen = @"Men";
 NSString* const HatCategoryWomen = @"Women";
NSString* const HatCategoryChildren = @"Children";
 NSString* const HatCategoryFunny = @"Funny";
 NSString* const HatCategoryCareer = @"Role";
 NSString* const HatCategoryValentine = @"Love";

@implementation HatCategory

@synthesize name,hatImgNames,iapKey, thumbImgName,available;

- (NSString*)thumbImgName{
	return [NSString stringWithFormat:@"catagory_%@.jpg",name];
}



- (int)availableNum{
	
	if (isPaid()||isIAPFullVersion) {
		return self.numOfCovers;
	}
	else{

		return available;
	}
	
}


- (id)initWithDictionary:(NSDictionary*)dict{
	if (self = [super init]) {
		
		self.name = dict[@"name"];
		self.hatImgNames = [NSMutableArray arrayWithArray:dict[@"imgNames"]];
		self.available = [dict[@"available"] intValue];
	
	}
	
	return self;
}

- (id)init{
	if (self = [super init]) {
		hatImgNames = [NSMutableArray array];
	}
	return self;
}

#pragma mark -
/**
 
 前availableNum的hat是available的，后面是unavailable的
 */

- (NSArray*)availableImgNames{
	NSRange availableRange = NSMakeRange(0, self.availableNum);
	return [hatImgNames subarrayWithRange:availableRange];
}
- (NSArray*)unavailableImgNames{
	NSRange availableRange = NSMakeRange(self.availableNum, [hatImgNames count]-self.availableNum);
	return [hatImgNames subarrayWithRange:availableRange];
}

-(NSString *)imgNameWithIndex:(int)index{
	return hatImgNames[index];
}

- (int)numOfCovers{

	return [hatImgNames count];
}

@end
