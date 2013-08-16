//
//  FBPhoto.m
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FBPhoto.h"

@implementation FBPhoto

@synthesize photoID,thumbURLStr,width,height,img130URLStr,img320URLStr,img480URLStr,img600URLStr,originalURLStr;


- (id)initWithDictionary:(NSDictionary*)dict{
	if (self = [super init]) {
		photoID = dict[@"id"];
		thumbURLStr = dict[@"picture"];
		originalURLStr = dict[@"source"];
		width = [dict[@"width"] floatValue];
		height = [dict[@"height"] floatValue];
		
		NSArray *images = dict[@"images"];
		for (NSDictionary *imageDict in images) {
			float imageWidth = [imageDict[@"width"] floatValue];
			if (imageWidth == 130) {
				img130URLStr = imageDict[@"source"];
			}
		    else if(imageWidth == 320){
				img320URLStr = imageDict[@"source"];
		    }
			else if(imageWidth == 480){
				img480URLStr = imageDict[@"source"];
			}
			else if(imageWidth == 600){
				img600URLStr = imageDict[@"source"];
			}
		}
		
	}
	return self;
}

- (NSString*)description{
	NSArray *keys = @[@"photoID",@"thumbURLStr",@"originalURLStr",@"img130URLStr",@"img320URLStr",@"img480URLStr",@"img600URLStr"];
	NSString *str = @"";

	for (NSString *key in keys) {
		str = [str stringByAppendingFormat:@"%@:%@\n",key,[self valueForKey:key]];
	}
	return str;
}

@end
