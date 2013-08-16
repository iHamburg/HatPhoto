//
//  ContentTextViewController.h
//  XappCard
//
//  Created by  on 09.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@class PortfolioView;
@class PocketView;
@class MyView;
@interface ContentTextViewController : UIViewController{

}


@property (nonatomic, retain) ContentViewController *contentVC;
@property (nonatomic, retain) IBOutlet PortfolioView *portfolioView;

@property (nonatomic, retain) IBOutlet MyView *myView;
@property (nonatomic, retain) IBOutlet UITextView *textView;



- (void)pickProfile; //from profileView


// from root
- (void)setProfile:(UIImage*)img; 
- (void)changeFont:(UIFont*)font;

@end
