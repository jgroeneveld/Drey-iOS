//
//  CreditsScene.m
//  drey
//
//  Created by Jaap Groeneveld on 17.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "CreditsScene.h"
#import "CreditsLayer.h"

@implementation CreditsScene

- (void) dealloc {


	[super dealloc];
}

- (id) init {
	if ((self = [super init]) != nil) {
		
		[self addChild:[CreditsLayer node]];
		
	}
	return self;
}

@end
