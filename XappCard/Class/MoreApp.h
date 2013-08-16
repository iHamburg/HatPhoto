//
//  MoreApp.h
//  InstaMagazine
//
//  Created by AppDevelopper on 14.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 
 - myecard
 - tinykitchen
 - nsc
 
 */
@interface MoreApp : NSObject

@property (nonatomic, strong) NSString *name, *title, *description, *imgName, *pAppid, *fAppid;
@property (nonatomic, strong) NSString *caption;

- (id)initWithName:(NSString*)name dictionary:(NSDictionary*)dict;

@end
