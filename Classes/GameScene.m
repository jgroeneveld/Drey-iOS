//
//  GameScene.m
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"

@implementation GameScene

- (void) dealloc
{
	
	[super dealloc];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self addChild:[GameLayer node]];
	}
	return self;
}

- (id) initWithAI:(AIPlayer*) ai {
	self = [super init];
	if (self != nil) {
		GameLayer* layer = [GameLayer node];
		layer.ai = ai;
		[self addChild:layer];
	}
	return self;	
}

+ (id) game {
	return [[[self alloc] init] autorelease];
}

+ (id) gameWithAI:(AIPlayer*) ai {
	return [[[self alloc] initWithAI:ai] autorelease];	
}

@end
