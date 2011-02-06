//
//  main.m
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright raute2a 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	srandom(time(NULL));
	
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	int retVal = UIApplicationMain(argc, argv, nil, @"dreyAppDelegate");
	[pool release];
	return retVal;
}
