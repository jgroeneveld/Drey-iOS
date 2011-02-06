//
//  GameLayer.m
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "GameLayer.h"
#import "GameScene.h"
#import "MenuScene.h"

@interface GameLayer()
- (void) updateObjectsToMatchActivePlayer;
@end


@implementation GameLayer
@synthesize field = field_, activePlayer1 = activePlayer1_, activePlayer2 = activePlayer2_, ai = ai_, backMenu = backMenu_;
- (void) dealloc
{
	self.field = nil;
	self.activePlayer1 = nil;
	self.activePlayer2 = nil;	
	self.ai = nil;
	self.backMenu = nil;
	
	[super dealloc];
}

- (id) init
{
	self = [super init];
	if (self != nil) {			
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		allowHumansMove_ = NO;
		
		
		CCColorLayer* bg = [CCColorLayer layerWithColor:kBackgroundColor4];
		[self addChild:bg];		
		
		self.activePlayer1 = [CCSprite spriteWithFile:@"activePlayer1.png"];
		self.activePlayer1.position = ccp(winSize.width/2.0, self.activePlayer1.contentSize.height/2.0);
		self.activePlayer1.opacity = 0;
		[self addChild:self.activePlayer1];
		
		self.activePlayer2 = [CCSprite spriteWithFile:@"activePlayer2.png"];
		self.activePlayer2.position = ccp(winSize.width/2.0, winSize.height - self.activePlayer2.contentSize.height/2.0);
		self.activePlayer2.opacity = 0;		
		[self addChild:self.activePlayer2];
		
		CCSprite* back = [CCSprite spriteWithFile:@"backButton.png"];
		CCSprite* backSelected = [CCSprite spriteWithFile:@"backButtonSelected.png"];		
		CCMenuItemSprite* backItem = [CCMenuItemSprite itemFromNormalSprite:back selectedSprite:backSelected target:self selector:@selector(showMenuScene)];
		
		self.backMenu = [CCMenu menuWithItems:backItem, nil];
		self.backMenu.position = ccp(25, [CCDirector sharedDirector].winSize.height - 25);
		self.backMenu.opacity = 0;
		[self addChild:self.backMenu];		
		isBackButtonEnabled_ = NO;				
		
	}
	return self;
}

- (void) showMenuScene {
	if (isBackButtonEnabled_) {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuScene node] withColor:kBackgroundColor3]];
	}
}

- (CGPoint) fieldMiddlePosition {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	return ccp(kFieldBorderSpacingX + self.field.contentSize.width/2.0, winSize.height/2.0);
}

- (CGPoint) fieldTopPosition {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	return ccp(kFieldBorderSpacingX + self.field.contentSize.width/2.0, winSize.height - kFieldBorderSpacingY - self.field.contentSize.height/2.0);
}

- (CGPoint) fieldBottomPosition {
	return ccp(kFieldBorderSpacingX + self.field.contentSize.width/2.0, kFieldBorderSpacingY + self.field.contentSize.height/2.0);
}


- (void) onEnterTransitionDidFinish {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
													 priority:0
											  swallowsTouches:YES];
	
	self.field = [Field node];
	self.field.position = [self fieldMiddlePosition];
	self.field.scale = 0.0001;
	[self addChild:self.field];
	[self.field runAction:[CCSequence actions:
						   [CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:kFieldInAnimationDuration scale:1] period: kElasticPeriod], 
						   [CCDelayTime actionWithDuration:0.1],
						   [CCCallFunc actionWithTarget:self selector:@selector(updateObjectsToMatchActivePlayer)], 
						   nil]];
	
	float r = CCRANDOM_0_1();
	if (r < 0.5) {
		currentPlayer_ = PlayerOne;	
	} else {
		currentPlayer_ = PlayerTwo;
	}
	
	self.ai.field = self.field;
	[self.ai reset];

}

- (void) onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (void) updateObjectsToMatchActivePlayer {
	// move field
	if (currentPlayer_ == PlayerOne) {
		[self.field runAction:[CCEaseElasticIn actionWithAction:[CCMoveTo actionWithDuration:kFieldMoveDuration position:[self fieldBottomPosition]] period: kElasticPeriod*2]];
	} else if (currentPlayer_ == PlayerTwo) {
		[self.field runAction:[CCEaseElasticIn actionWithAction:[CCMoveTo actionWithDuration:kFieldMoveDuration position:[self fieldTopPosition]] period: kElasticPeriod*2]];
	}
	
	// fade active player
	if (currentPlayer_ == PlayerOne) {
		[self.activePlayer1 runAction:[CCFadeTo actionWithDuration:kActivePlayerFadeDuration opacity:255]];
		[self.activePlayer2 runAction:[CCFadeTo actionWithDuration:kActivePlayerFadeDuration opacity:0]];
	} else if (currentPlayer_ == PlayerTwo) {
		[self.activePlayer2 runAction:[CCFadeTo actionWithDuration:kActivePlayerFadeDuration opacity:255]];
		[self.activePlayer1 runAction:[CCFadeTo actionWithDuration:kActivePlayerFadeDuration opacity:0]];
	}
	
	// next move wenn feld verschoben
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:kFieldMoveDuration], [CCCallFunc actionWithTarget:self selector:@selector(nextPlayersMove)], nil]];
	
	// backtomenu button
	if (currentPlayer_ == PlayerOne) {	
		[self.backMenu runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15], [CCFadeTo actionWithDuration:0.25 opacity:155], nil]];		
		isBackButtonEnabled_ = YES;
	} else if (currentPlayer_ == PlayerTwo) {
		[self.backMenu runAction:[CCFadeTo actionWithDuration:0.25 opacity:0]];		
		isBackButtonEnabled_ = NO;		
	}		
}

- (void) didMoveNowProgress {
	// switch player
	if (currentPlayer_ == PlayerOne) {
		currentPlayer_ = PlayerTwo;
	} else if (currentPlayer_ == PlayerTwo) {
		currentPlayer_ = PlayerOne;
	}
	
	Player winner = [self.field checkForWinner];
	if (winner != PlayerNone) {
		NSLog(@"player %i won", winner);
		[self.field highlightBlocksOfPlayer:winner];
		gameOver_ = YES;
	} else {
		[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:kFieldOwnerFadeDuration/3.0], [CCCallFunc actionWithTarget:self selector:@selector(updateObjectsToMatchActivePlayer)], nil]];
	}
}

- (void) makeAIMove {
	[self.ai makeMove];
	[self didMoveNowProgress];
}



- (void) nextPlayersMove {
	if (currentPlayer_ == PlayerTwo && self.ai != nil) {
		[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:kAdditionalAIDelay], [CCCallFunc actionWithTarget:self selector:@selector(makeAIMove)], nil]];
	} else {
		allowHumansMove_ = YES;
	}


}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	
}

- (void) processPlayersMoveByTouchAt:(CGPoint) location {
	CGPoint locationInField = [self.field convertToNodeSpace:location];	
	
	if (locationInField.x > 0 && locationInField.y>0 && locationInField.x<self.field.contentSize.width && locationInField.y < self.field.contentSize.height) {
		
		bool validMove = [self.field hitAt:location byPlayer:currentPlayer_];
		
		if (validMove) {
			[self didMoveNowProgress];
			
			allowHumansMove_ = NO;
		}
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	if (!gameOver_) {
		CGPoint location = [touch locationInView:[touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];

		if (allowHumansMove_) {
			if (currentPlayer_ == PlayerOne || (self.ai == nil && currentPlayer_ == PlayerTwo)) { // nur wenn menschlicher spieler dran
				[self processPlayersMoveByTouchAt:location];
			}
		}
	} else {
		// achtung: der sieger ist genau der andere spieler, daher andersrum
		if (currentPlayer_ == PlayerTwo) {
			[self.field runAction:[CCMoveBy actionWithDuration:kFieldOutAnimationDuration position:ccp(0, -(self.field.contentSize.height + 100))]];
		} else if (currentPlayer_ == PlayerOne) {
			[self.field runAction:[CCMoveBy actionWithDuration:kFieldOutAnimationDuration position:ccp(0, +(self.field.contentSize.height + 100))]];
		}
		
		GameScene* game = nil;
		
		if (self.ai != nil) {
			game = [GameScene gameWithAI:self.ai];
		} else {
			game = [GameScene game];
		}
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:game withColor:kBackgroundColor3]];		
	}
	
	

}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	
}


@end
