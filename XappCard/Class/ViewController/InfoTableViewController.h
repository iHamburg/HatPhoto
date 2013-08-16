//
//  InfoTableViewController.h
//  HatPhoto
//
//  Created by AppDevelopper on 16.01.13.
//
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "InstructionViewController.h"

@interface InfoTableViewController : UITableViewController<InstructionDelegate>{
	
	InstructionViewController *_instructionVC;
	
	NSArray *_tableKeys, *_tableHeaders, *_tableImageNames;
	
	NSMutableArray *moreApps;
}

- (void)back;
- (void)aboutus;
- (void)tweetus;
- (void)facebook;
- (void)email;
- (void)supportEmail;
- (void)toAppstore:(NSString*)appID;

- (void)toInstruction;
@end
