//
//  NSString+Extras.m
//  GoBeepItZXing
//
//  Created by AppDevelopper on 13.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extras.h"


@implementation NSString (NSString_Extras)

+ (NSString*)stringWithInt:(int)i{
    return [NSString stringWithFormat:@"%d",i];
}


+ (NSString*)stringWithFloat:(float)f{
    return [NSString stringWithFormat:@"%.2f",f];
}


- (UIColor*)colorFromHex
{
    NSString *hexColor = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([hexColor length] < 6)
        return [UIColor blackColor];
    if ([hexColor hasPrefix:@"#"])
        hexColor = [hexColor substringFromIndex:1];
    if ([hexColor length] != 6 && [hexColor length] != 8)
        return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [hexColor substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
    
    range.location = 6;
    NSString *aString = @"FF";
    if ([hexColor length] == 8)
        aString = [hexColor substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}

+ (NSString*)plistPathWithName:(NSString*)fileName{
	
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* myPlistPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
	NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	
	// If it's not there, copy it from the bundle
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ( ![fileManager fileExistsAtPath:myPlistPath] ) {

		if(![fileManager copyItemAtPath:path toPath:myPlistPath error:&error])
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", fileName);
	}       
    else{
        // DLog(@"plist is da");
    }
	return myPlistPath;    
	
}

+ (NSString*)dataFilePath:(NSString*)fileName{
	
	//	NSLog(@"fileName:%@",fileName);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
														 NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString* myPlistPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
	
	NSString *name = [fileName stringByDeletingPathExtension];
	NSString *pathExtension = [fileName pathExtension];
	
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:pathExtension];
	
	// If it's not there, copy it from the bundle
	NSError *error;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ( ![fileManager fileExistsAtPath:myPlistPath] && [fileManager fileExistsAtPath:path]) {
		//NSLog(@"copy begin, %@,to,%@",path,myPlistPath);
		if(![fileManager copyItemAtPath:path toPath:myPlistPath error:&error])
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", fileName);
	}       
    else{
        
    }
	
	
	return myPlistPath;
}


@end
