//
//  InfoTableViewController.m
//  HatPhoto
//
//  Created by AppDevelopper on 16.01.13.
//
//

#import "InfoTableViewController.h"
#import "MoreApp.h"
#import "InstructionViewController.h"
#import "FacebookManager.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Info";
	
	
	_tableHeaders = @[@"",@"",@"More Apps"];
	_tableKeys = @[@[@"Guide"],@[@"About Us",@"Facebook",@"Twitter",@"Contact us"],
	@[@"My eCard",@"Everalbum",@"Tiny Kitchen",@"NSC"]];
	_tableImageNames = @[@"Info_Xappsoft.png",@"Info_Facebook.png",@"Info_Twitter.png",@"Info_Email.png"];
	
	NSArray *moreAppNames = @[@"myecard",@"everalbum",@"tinykitchen",@"nsc"];
	NSString *moreAppsPlistPath = [[NSBundle mainBundle] pathForResource:@"MoreApps" ofType:@"plist"];
	NSDictionary *moreAppsDict = [NSDictionary dictionaryWithContentsOfFile:moreAppsPlistPath];
	moreApps = [NSMutableArray array];
	for (NSString *name in moreAppNames) {
		MoreApp *app = [[MoreApp alloc]initWithName:name dictionary:moreAppsDict[name]];
		[moreApps addObject:app];
	}

	UIBarButtonItem *backBB = self.navigationItem.leftBarButtonItem;
	[backBB setAction:@selector(back)];
//	NSLog(@"more Apps # %@",moreApps);
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back{
	L();
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_tableHeaders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_tableKeys[section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return _tableHeaders[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	int row = indexPath.row;
	int section = indexPath.section;
	
	UITableViewCell *cell;
	
    if (section == 0) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

		cell.textLabel.text = [_tableKeys[section] objectAtIndex:row];

		cell.textLabel.textAlignment = NSTextAlignmentCenter;
	}
	else {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

		cell.textLabel.text = [_tableKeys[section] objectAtIndex:row];
		cell.imageView.layer.cornerRadius = 5;
		cell.imageView.layer.masksToBounds = YES;
		if (section == 1) {
			UIImage *img = [UIImage imageWithContentsOfFileName:_tableImageNames[row]];
			cell.imageView.image = [img imageByScalingAndCroppingForSize:CGSizeMake(34, 34)];
		}
		else if (section == 2) {
			MoreApp *app = moreApps[row];
			NSString *caption = app.caption;
//			NSLog(@"caption # %@",caption);
			cell.detailTextLabel.text = caption;
			cell.imageView.image = [[UIImage imageWithContentsOfFileName:[app imgName]] imageByScalingAndCroppingForSize:CGSizeMake(34, 34)];

			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	int row = indexPath.row;
	int section  = indexPath.section;
	
	if (section == 0) { //guide
		[self toInstruction];
	}
	else if(section == 1){ //@"About Us",@"Facebook",@"Twitter",@"Contact us"
		if (row == 0) {
			[self aboutus];
		}
		else if(row ==1){
			[self facebook];
		}
		else if(row == 2){
			[self tweetus];
		}
		else if(row == 3){
			[self supportEmail];
		}
		
	}
	else if(section == 2){ // more apps
		MoreApp *moreApp = moreApps[row];
		NSString *appid = moreApp.fAppid;
		
//		NSString *urlStr = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",appid];
//		NSURL *url = [NSURL URLWithString:urlStr];
//		[[UIApplication sharedApplication] openURL:url];
		
		[self toAppstore:appid];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Function

#pragma mark -

- (void)toInstruction{
	
	if (!_instructionVC) {
		_instructionVC = [[InstructionViewController alloc]init];
		_instructionVC.view.alpha = 1;
		_instructionVC.delegate = self;
	}
	
//	[_instructionVC]
	[self.navigationController.view addSubview:_instructionVC.view];
	
}

- (void)closeInstruction:(InstructionViewController *)vc{
	
	[_instructionVC.view removeFromSuperview];
}


- (void)aboutus{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.xappsoft.de/index.php?lang=en"]];
}
- (void)tweetus{
		[[ExportController sharedInstance]sendTweetWithText:STwitter image:[UIImage imageNamed:@"Icon-72.png"]];
}
- (void)facebook{
	
	
		[[FacebookManager sharedInstance]feed];
}
- (void)email{
	
//	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//						  SRecommendEmailTitle, @"subject",
//						  SRecommendEmailBody,@"emailBody",
//						  nil];
//	
//	[[ExportController sharedInstance] sendEmail:dict];
	
}
- (void)supportEmail{
	
	
	NSDictionary *dict2 = @{
	@"subject": SSupportEmailTitle,
	@"toRecipients": @[@"support@xappsoft.de"]
	};
	
	[[ExportController sharedInstance] sendEmail:dict2];
}

- (void)appstore{
//	MoreApp *app = moreApps[selectedIndex];
//	NSString *appid =isPaid()?app.pAppid:app.fAppid;
//	
//	NSString *urlStr = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",appid];
//	NSURL *url = [NSURL URLWithString:urlStr];
//	[[UIApplication sharedApplication] openURL:url];
}


- (void)toAppstore:(NSString*)appID{
	NSString *urlStr = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",appID];

	NSLog(@"url # %@",urlStr);
	
	NSURL *url = [NSURL URLWithString:urlStr];
	[[UIApplication sharedApplication] openURL:url];
}

@end
