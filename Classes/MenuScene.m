//
//  MenuScene.m
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "MenuScene.h"
#import "MenuLayer.h"

@implementation MenuScene

- (void) dealloc
{
	
	[super dealloc];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self addChild:[MenuLayer node]];
	}
	return self;
}



@end
