//
//  CoverCategory.h
//  MyeCard
//
//  Created by AppDevelopper on 09.01.13.
//
//

#import <Foundation/Foundation.h>

extern NSString* const HatCategoryMen;
extern NSString* const HatCategoryWomen;
extern NSString* const HatCategoryChildren;
extern NSString* const HatCategoryFunny;
extern NSString* const HatCategoryCareer;
extern NSString* const HatCategoryValentine;

@interface HatCategory : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *hatImgNames;
@property (nonatomic, strong) NSString *iapKey;
@property (nonatomic, strong) NSString *thumbImgName;
@property (nonatomic, assign) int available;


- (id)initWithDictionary:(NSDictionary*)dict;

- (int)availableNum;
- (NSArray*)availableImgNames;
- (NSArray*)unavailableImgNames;
- (NSString *)imgNameWithIndex:(int)index;
- (int)numOfCovers;

@end
