//
//  dreyAppDelegate.h
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright raute2a 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface dreyAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
