//
//  CardController.m
//  XappCard
//
//  Created by  on 11.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "Controller.h"
//#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
//#import "Card.h"

@implementation Controller



+(Controller*)sharedController{
    static Controller *sharedController;
    
    @synchronized(sharedController){
        if (sharedController == nil) {
            sharedController = [[Controller alloc ]init];
        }
    }
    
    return sharedController;
}
@end
