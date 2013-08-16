//
//  CodingObject.h
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//


#import "Utilities.h"

@interface CodingObject : NSObject<NSCoding>{

	NSMutableArray *keys;

}

@property (nonatomic, strong) NSMutableArray *keys;

- (void)firstLoad;
- (void)load; 
- (void)loadEmptyKeys:(NSArray*)emptyKeys; 
- (void)loadOthers:(NSCoder*)aDecoder;
- (void)setup;

- (void)willSave;
- (void)saveOthers:(NSCoder*)coder;
@end
