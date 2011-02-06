//
//  CreditsLayer.m
//  drey
//
//  Created by Jaap Groeneveld on 17.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "CreditsLayer.h"
#import "MenuScene.h"

@implementation CreditsLayer

- (void) dealloc {


	[super dealloc];
}

- (id) init {
	if ((self = [super init]) != nil) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CCColorLayer* bg = [CCColorLayer layerWithColor:kBackgroundColor4];
		[self addChild:bg];	
		
		CCSprite* logo = [CCSprite spriteWithFile:@"raute2aCreditsLogo.png"];
		CCMenuItemSprite* logoItem = [CCMenuItemSprite itemFromNormalSprite:logo selectedSprite:logo target:self selector:@selector(linkPressed)];
		CCMenu* logoMenu = [CCMenu menuWithItems:logoItem, nil];
		logoMenu.position = ccp(winSize.width/2.0, winSize.height/2.0);
		[self addChild:logoMenu];
		
		CCSprite* back = [CCSprite spriteWithFile:@"backButton.png"];
		CCSprite* backSelected = [CCSprite spriteWithFile:@"backButtonSelected.png"];		
		CCMenuItemSprite* backItem = [CCMenuItemSprite itemFromNormalSprite:back selectedSprite:backSelected target:self selector:@selector(showMenuScene)];
		
		CCMenu* menu = [CCMenu menuWithItems:backItem, nil];
		menu.position = ccp(25, [CCDirector sharedDirector].winSize.height - 25);
		
		[self addChild:menu];
		
	}
	return self;
}

- (void) linkPressed {
	NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.raute2a.de" ];
	[[UIApplication sharedApplication] openURL:url];
	[url release];
}

- (void) showMenuScene {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5 scene:[MenuScene node] withColor:kBackgroundColor3]];	
}


@end
