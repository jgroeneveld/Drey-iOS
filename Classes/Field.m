//
//  Field.m
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "Field.h"

@implementation Field

- (void) dealloc {
	[p1F1_ release];
	[p1F2_ release];
	[p1F3_ release];	
	
	[p2F1_ release];
	[p2F2_ release];
	[p2F3_ release];	

	[super dealloc];
}

- (id) init {
	if ((self = [super init]) != nil) {		
		p1F1_ = nil;
		p1F2_ = nil;
		p1F3_ = nil;		
		p2F1_ = nil;
		p2F2_ = nil;
		p2F3_ = nil;				
		
		self.anchorPoint = ccp(0.5,0.5);
		float dim = 3*kFieldChildSize+2*kFieldSpacing;
		self.contentSize = CGSizeMake(dim, dim);
		
		for (int y = 0; y < 3; y++) {
			float yStartPos = kFieldChildSize/2.0;
			float yPos = yStartPos + (kFieldChildSize+kFieldSpacing)*y;
			
			for (int x = 0; x < 3; x++) {
				float xStartPos = kFieldChildSize/2.0;
				float xPos = xStartPos + (kFieldChildSize+kFieldSpacing)*x;
				
				FieldChild* field = [FieldChild node];
				field.position = ccp(xPos, yPos);
				[self addChild:field z:0 tag:x*3+y];
			}	
		}
		
	}
	return self;
}

- (void) cycleOwnedFieldsForPlayer:(Player) player withNewField:(FieldChild*) child {
	if (player == PlayerOne) {
		p1F3_.owningPlayer = PlayerNone;
		p1F3_.age = -1;
		[p1F3_ release];
		p1F3_ = p1F2_;
		p1F3_.age = 3;
		p1F2_ = p1F1_;
		p1F2_.age = 2;		
		p1F1_ = child;
		p1F1_.age = 1;		
		[child retain];
	} else if (player == PlayerTwo) {
		p2F3_.owningPlayer = PlayerNone;
		p2F3_.age = -1;		
		[p2F3_ release];
		p2F3_ = p2F2_;
		p2F3_.age = 3;		
		p2F2_ = p2F1_;
		p2F2_.age = 2;		
		p2F1_ = child;
		p2F1_.age = 1;		
		[child retain];	
	}	
}

- (bool) hitAt:(CGPoint) location byPlayer:(Player) player {	
	FieldChild* hitChild = nil;
	
	for (FieldChild* child in self.children) {
		float wh = child.contentSize.width/2.0;
		float hh = child.contentSize.height/2.0;
		
		CGPoint locationInField = [child convertToNodeSpace:location];	
		
		if (locationInField.x > -wh && locationInField.y > -hh && locationInField.x<wh && locationInField.y < hh) {
			hitChild = child;
			break;
		}
	}
	
	if (hitChild != nil) {
		if (hitChild.owningPlayer == PlayerNone) {
			[self makeMoveForChildWithTag:hitChild.tag byPlayer:player];
			
			return YES;
		}
	}
	
	return NO;
}

- (void) makeMoveForChildWithTag:(int) tag byPlayer:(Player) player {
	FieldChild* child = (FieldChild*) [self getChildByTag:tag];
	
	child.owningPlayer = player;
	
	// den aeltesten zuruecksetzen und circeln
	[self cycleOwnedFieldsForPlayer:player withNewField:child];
}

- (Player) playerInArray:(NSMutableArray*) array forX:(int) x andY:(int) y
{
	return [[array objectAtIndex:indexForXandY(x,y)] intValue];
}

- (Player) checkForWinner {
	return [self checkForWinnerInArray:[self arrayRepresentation]];
}

- (Player) checkForWinnerInArray:(NSMutableArray*) array {
	// fxy
	Player f00 = [self playerInArray:array forX:0 andY:0];
	Player f10 = [self playerInArray:array forX:1 andY:0];
	Player f20 = [self playerInArray:array forX:2 andY:0];
	Player f01 = [self playerInArray:array forX:0 andY:1];
	Player f11 = [self playerInArray:array forX:1 andY:1];
	Player f21 = [self playerInArray:array forX:2 andY:1];
	Player f02 = [self playerInArray:array forX:0 andY:2];
	Player f12 = [self playerInArray:array forX:1 andY:2];
	Player f22 = [self playerInArray:array forX:2 andY:2];
	
	// zeile 0
	if (f00 == f10 && f10 == f20) {
		if (f00 != PlayerNone) {
			return f00;
		}
	}
	
	// zeile 1
	if (f01 == f11 && f11 == f21) {
		if (f01 != PlayerNone) {
			return f01;
		}
	}
	
	// zeile 2
	if (f02 == f12 && f12 == f22) {
		if (f02 != PlayerNone) {
			return f02;
		}
	}	
	
	// spalte 0
	if (f00 == f01 && f01 == f02) {
		if (f00 != PlayerNone) {
			return f00;
		}
	}
	
	// spalte 1
	if (f10 == f11 && f11 == f12) {
		if (f10 != PlayerNone) {
			return f10;
		}
	}		

	// spalte 2
	if (f20 == f21 && f21 == f22) {
		if (f20 != PlayerNone) {
			return f20;
		}
	}			

	// ul nach or
	if (f00 == f11 && f11 == f22) {
		if (f00 != PlayerNone) {
			return f00;
		}
	}	
	
	// ur nach ol
	if (f20 == f11 && f11 == f02) {
		if (f20 != PlayerNone) {
			return f20;
		}
	}		
	
	return PlayerNone;
	
}

- (void) highlightBlocksOfPlayer:(Player) player {
	for (FieldChild* child in self.children) {
		if (child.owningPlayer != player) {
			[child animateOwnerOpacityTo:30];
		}
	}
}

- (NSMutableArray*) arrayRepresentation {
	id array = [NSMutableArray arrayWithCapacity:9];
	
	for (int i = 0; i < 9; i++) {
		[array insertObject:[NSNumber numberWithInt:((FieldChild*)[self getChildByTag:i]).owningPlayer] atIndex:i];
	}
	
	return array;
}

@end
