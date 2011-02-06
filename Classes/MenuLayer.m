//
//  MenuLayer.m
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "MenuLayer.h"
#import "GameScene.h"
#import "CreditsScene.h"
#import "AIPlayerWeak.h"

@implementation MenuLayer
@synthesize topMenu = topMenu_, middleMenu = middleMenu_, bottomMenu = bottomMenu_, playFriendIndicator = playFriendIndicator_, playAIIndicator = playAIIndicator_;


- (void) dealloc {
	self.topMenu = nil;
	self.middleMenu = nil;
	self.bottomMenu = nil;
	
	self.playFriendIndicator = nil;
	self.playAIIndicator = nil;

	[super dealloc];
}

- (id) init {
	if ((self = [super init]) != nil) {
		
		CCColorLayer* bg = [CCColorLayer layerWithColor:kBackgroundColor4];
		[self addChild:bg];		
		
	}
	return self;
}

- (void) transitionInWithMenu:(CCMenu*) menu {
	for (CCMenuItem* i in menu.children) {
		i.scale = 0.0001;
		[i runAction:[CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:kMenuItemAnimationDuration scale:1] period: kElasticPeriod]];		
	}	
}

- (void) transitionIn {
	[self transitionInWithMenu:self.topMenu];
	[self transitionInWithMenu:self.middleMenu];
	[self transitionInWithMenu:self.bottomMenu];	
}

- (void) transitionOutWithMenu:(CCMenu*) menu andPressedItem:(CCMenuItem*) item finishSelector:(SEL) sel {
	for (CCMenuItem* i in menu.children) {
		if (i == item) {
			[i runAction:[CCSequence actions:
						  [CCDelayTime actionWithDuration:kMenuItemAnimationDuration/3.0], 
						  [CCEaseElasticIn actionWithAction:[CCScaleTo actionWithDuration:kMenuItemAnimationDuration scale:0.0001] period: kElasticPeriod],
						  [CCCallFunc actionWithTarget:self selector:sel],
						  nil]];
		} else {
			[i runAction:[CCEaseElasticIn actionWithAction:[CCScaleTo actionWithDuration:kMenuItemAnimationDuration scale:0.0001] period: kElasticPeriod]];		
		}
		
	}
}

- (void) transitionOutWithPressedItem:(CCMenuItem*) item finishSelector:(SEL) sel {
	[self transitionOutWithMenu:self.topMenu andPressedItem:item finishSelector:sel];
	
	[self transitionOutWithMenu:self.middleMenu andPressedItem:item finishSelector:sel];
	
	[self transitionOutWithMenu:self.bottomMenu andPressedItem:item finishSelector:sel];	
}

- (void) selectPlayAI {
	self.playFriendIndicator.opacity = 50;
	self.playAIIndicator.opacity = 255;
	gameMode_ = GameModePlayAI;
}

- (void) selectPlayFriend {
	self.playFriendIndicator.opacity = 255;
	self.playAIIndicator.opacity = 50;
	gameMode_ = GameModePlayFriend;	
}

- (void) onEnterTransitionDidFinish {
	CCSprite* blankSprite = [CCSprite spriteWithFile:@"menuItemBlank.png"];
	CCSprite* dreySprite = [CCSprite spriteWithFile:@"menuItemDrey.png"];
	
	// oben
	CCMenuItemSprite* drey = [CCMenuItemSprite itemFromNormalSprite:dreySprite selectedSprite:dreySprite];	
	
	CCMenuItemSprite* om = [CCMenuItemSprite itemFromNormalSprite:blankSprite selectedSprite:blankSprite];
	
	CCMenuItemSprite* or = [CCMenuItemSprite itemFromNormalSprite:blankSprite selectedSprite:blankSprite];	
	
	// mitte
	CCMenuItemSprite* ml = [CCMenuItemSprite itemFromNormalSprite:blankSprite selectedSprite:blankSprite];

	CCMenuItemSprite* startGame = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"menuItemPlay.png"] selectedSprite:[CCSprite spriteWithFile:@"menuItemPlaySelected.png"] target:self selector:@selector(startGamePressed:)];
	
	CCMenuItemSprite* mr = [CCMenuItemSprite itemFromNormalSprite:blankSprite selectedSprite:blankSprite target:self selector:@selector(chooseGameModePressed:)];
	
	self.playFriendIndicator = [CCSprite spriteWithFile:@"menuItemPlayFriend.png"];
	self.playFriendIndicator.anchorPoint = ccp(0,0);
	[mr addChild:self.playFriendIndicator];
	
	self.playAIIndicator = [CCSprite spriteWithFile:@"menuItemPlayAI.png"];
	self.playAIIndicator.anchorPoint = ccp(0,0);
	[mr addChild:self.playAIIndicator];
	
	[self selectPlayFriend];
	
	// unten
	CCMenuItemSprite* ul = [CCMenuItemSprite itemFromNormalSprite:blankSprite selectedSprite:blankSprite];
	
	CCMenuItemSprite* um = [CCMenuItemSprite itemFromNormalSprite:blankSprite selectedSprite:blankSprite];
	
	CCMenuItemSprite* raute2a = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"menuItemRaute2a.png"] selectedSprite:[CCSprite spriteWithFile:@"menuItemRaute2aSelected.png"] target:self selector:@selector(raute2aPressed:)];
	
	
	
	// menues
	self.topMenu = [CCMenu menuWithItems:drey, om, or, nil];
	[self.topMenu alignItemsHorizontallyWithPadding:kFieldSpacing];
	self.topMenu.position = ccp(160, 240+kFieldChildSize+kFieldSpacing);
	[self addChild:self.topMenu];
	
	self.middleMenu = [CCMenu menuWithItems:ml, startGame, mr, nil];
	[self.middleMenu alignItemsHorizontallyWithPadding:kFieldSpacing];
	self.middleMenu.position = ccp(160, 240);
	[self addChild:self.middleMenu];
	
	self.bottomMenu = [CCMenu menuWithItems:ul, um, raute2a, nil];
	[self.bottomMenu alignItemsHorizontallyWithPadding:kFieldSpacing];
	self.bottomMenu.position = ccp(160, 240-kFieldChildSize-kFieldSpacing);
	[self addChild:self.bottomMenu];	
	
	[self transitionIn];
}

- (void) chooseGameModePressed:(id) sender {
	NSLog(@"choose game mode pressed");
	
	if (gameMode_ == GameModePlayFriend) {
		[self selectPlayAI];
	} else if (gameMode_ == GameModePlayAI) {
		[self selectPlayFriend];
	}
}

- (void) startGamePressed:(id) sender {
	NSLog(@"start game pressed");
	
	[self transitionOutWithPressedItem:sender finishSelector:@selector(startGame)];
}

- (void) startGame {
	id game = nil;
	
	if (gameMode_ == GameModePlayAI) {
		game = [GameScene gameWithAI:[[[AIPlayerWeak alloc] init] autorelease]];
	} else {
		game = [GameScene game];
	}

				   
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5 scene:game withColor:kBackgroundColor3]];	
}

- (void) raute2aPressed:(id) sender {
	NSLog(@"raute2aPressed");
	
	[self transitionOutWithPressedItem:sender finishSelector:@selector(showCredits)];
}

- (void) showCredits {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5 scene:[CreditsScene node] withColor:kBackgroundColor3]];	
}


- (void) onExit {
	
}

@end
