//
//  PhotoDisplayViewController.m
//  travelAlbum
//
//  Created by XC on 7/19/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoDisplayViewController.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
//#import "AlbumEditViewController.h"
//#import "PhotoWidget.h"

@interface PhotoDisplayViewController ()

- (void)preparePhotos;

@end

@implementation PhotoDisplayViewController

@synthesize assetGroup,fbPhotos,source;


// 在nav中，每次都会重新load！
- (void)loadView{

	elcAssets = [NSMutableArray array];
    thumbs = [NSMutableArray array];
	thumbsInRow = [NSMutableArray array];

	
	numOfPhotoInRow = 3;
	thumbSize = isPad?CGSizeMake(75, 75):CGSizeMake(48, 48);
	margin = isPad?6:4;
	
	w = 320;
	h = 400;
	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
	self.view.backgroundColor = [UIColor blackColor];

    tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:tableView];
}

- (void)viewDidAppear:(BOOL)animated{
	L();
	[super viewDidAppear:animated];
	
	
	if (source == PhotoSourceAlbum) {
	

		dispatch_async(dispatch_get_main_queue(), ^{
			count = 1;
			[elcAssets removeAllObjects];
			@autoreleasepool {
				
				[self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
				 {
					 if(asset == nil) {
						 return;
					 }
					 
					 [elcAssets addObject:asset];
					 
					 count++;
				 }];

				
				dispatch_async(dispatch_get_main_queue(), ^{

					[tableView reloadData];
				});

							   
			}

		});

	}

	[tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (void)dealloc{
	L();

}

-(void)preparePhotos {
	L();

    count = 1;
	[elcAssets removeAllObjects];
    @autoreleasepool {
        
		/*
		 遍历asset的block是同步的，enumerate后面的代码必须等遍历结束才会被调用，所以self.assetGroup enumerateAssetsUsingBlock:这个函数本身需要放到后台运行
		 [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
		 可是这个后台程序可以调用[tableview reloadData];回到主线程？
         而遍历group是异步的，所以可以不用在后台
         */
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) 
         {
             if(asset == nil) {
                    return;
             }
 
			[elcAssets addObject:asset];

			 count++;
         }];    
        //只会调用一次
		//tableview 正式载入数据！
//		NSLog(@"photo count # %d", [elcAssets count]);
        [tableView reloadData];

        
    }
    
}


#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int num = 1;
	
	int allCount = MAX([fbPhotos count], [elcAssets count]);
	
	if (section == 0) {
		num = ceil((float)allCount/numOfPhotoInRow);
	}

	NSLog(@"num of rows # %d",num);
	return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hCell = isPad?80:54;
//	if (indexPath.section == 0) { // bg
//		hCell = isPad?80:54;
//	}
  
	return hCell;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier1 = @"Cell1";

	UITableViewCell *cell;
	
		
	cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
	[thumbsInRow removeAllObjects];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		for (int i = 0; i<numOfPhotoInRow; i++) {
			
			UIImageView *v = [[UIImageView alloc]initWithFrame:CGRectMake(margin+(thumbSize.width+margin)*i, margin, thumbSize.width, thumbSize.height)];
			v.userInteractionEnabled = YES;
			v.contentMode = UIViewContentModeScaleAspectFit;
			[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			[thumbsInRow addObject:v];
			[cell.contentView addSubview:v];
		}
	}
	else{
		
		[thumbsInRow addObjectsFromArray:cell.contentView.subviews];
		
	}
	
	for (int i = 0; i< numOfPhotoInRow ; i++) {
		int index = indexPath.row * numOfPhotoInRow +i;
		
		UIImageView *imgV = thumbsInRow[i];
		if (source == PhotoSourceAlbum) { //album
			if (index<[elcAssets count]) {
				
				ALAsset *asset = elcAssets[index];
				imgV.image = [UIImage imageWithCGImage:asset.thumbnail];
				imgV.tag = index+1;
	
			}
			else{
				// 防止最后一行多出的thumb被点击
				imgV.tag = 0;
				imgV.image = nil;
			}
		}
		else { //fb
				if (index<[fbPhotos count]) {
				
					FBPhoto *photo = fbPhotos[index];

					imgV.tag = index+1;
					[imgV setImageWithURL:[NSURL URLWithString:photo.thumbURLStr] placeholderImage:nil];

			}
			else{
				// 防止最后一行多出的thumb被点击
				imgV.tag = 0;
				imgV.image = nil;
			}
		}
		
	}
		

	return cell;
	
}


#pragma mark - IBAction

//
- (void)handleTap:(UITapGestureRecognizer*)tap{
//	
//	UIImageView *imgV = (UIImageView*)[tap view];
	
	
//	NSLog(@"alpha # %d",[imgV.image hasAlpha]);
//	
//	int index = [[tap view]tag]-1;
//	
//	if (index <0) {
//		NSLog(@"not found");
//		return;
//	}
//
//	PhotoWidget *widget;
//	if (source == PhotoSourceAlbum) {
//		ALAsset *asset = [elcAssets objectAtIndex:index];
//		
//        widget = [[PhotoWidget alloc]initWithAsset:asset];
//		
//	}
//	else if(source == PhotoSourceFacebook){
//		
//        FBPhoto *fbPhoto = fbPhotos[index];
//        widget = [[PhotoWidget alloc]initWithFBPhoto:fbPhoto];
//        widget.image = imgV.image;
//        
//	}
//	
//	
//	widget.transform = CGAffineTransformScale(widget.transform, 0.67, 0.67);
//	
//
//    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationAddPhotoWidget object:widget];
//	

}


@end
