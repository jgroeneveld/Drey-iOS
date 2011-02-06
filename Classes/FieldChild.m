//
//  FieldChild.m
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "FieldChild.h"

enum SpriteTags {
	SpriteTagGround,
	SpriteTagOwner
};

@implementation FieldChild
@synthesize owningPlayer = owningPlayer_, age = age_;

- (void) dealloc {


	[super dealloc];
}

- (id) init {
	if ((self = [super init]) != nil) {
		
		CCSprite* field = [CCSprite spriteWithFile:@"emptyField.png"];
		[self addChild:field z:0 tag:SpriteTagGround];
		
		self.contentSize = field.contentSize;
		
		self.age = -1;
	}
	return self;
}

-(void) setOwningPlayer:(Player) p {
	if (owningPlayer_ != p) {
		owningPlayer_ = p;
		
		if (owningPlayer_ == PlayerNone) {
			CCNode* currentOwner = [self getChildByTag:SpriteTagOwner];
			[currentOwner runAction:[CCSequence actions:
									 [CCFadeOut actionWithDuration:kFieldOwnerFadeDuration],
									 [CCCallFunc actionWithTarget:self selector:@selector(currentOwnerFadedOut)],
									 nil]];
		} else {		
			CCSprite* newOwner;
			if (owningPlayer_ == PlayerOne) {
				newOwner = [CCSprite spriteWithFile:@"p1Field.png"];
			} else if (owningPlayer_ == PlayerTwo) {
				newOwner = [CCSprite spriteWithFile:@"p2Field.png"];
			}
			
			if (newOwner != nil) { // nur wenn es einen owner gibt
				[self addChild:newOwner z:0 tag:SpriteTagOwner];
				newOwner.opacity = 0;
				[newOwner runAction:[CCFadeIn actionWithDuration:kFieldOwnerFadeDuration]];
			}
		}
	}
}
			 
- (void) currentOwnerFadedOut {
	[self removeChildByTag:SpriteTagOwner cleanup:YES];
}

- (void) animateOwnerOpacityTo:(GLubyte) op {
	[((CCSprite*)[self getChildByTag:SpriteTagOwner]) runAction:[CCFadeTo actionWithDuration:kFieldOwnerFadeDuration opacity:op]];
}

@end
