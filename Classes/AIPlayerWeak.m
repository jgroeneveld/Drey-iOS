//
//  AIPlayerWeak.m
//  drey
//
//  Created by Jaap Groeneveld on 18.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import "AIPlayerWeak.h"


@implementation AIPlayerWeak

- (void) dealloc {


	[super dealloc];
}

- (id) init {
	if ((self = [super init]) != nil) {
		
		
		
	}
	return self;
}

- (void) reset {
	
}

- (Player) playerInArray:(NSMutableArray*) array forX:(int) x andY:(int) y
{
	return [[array objectAtIndex:indexForXandY(x,y)] intValue];
}

// gibt den index des freien feldes zurueck zum gewinnen oder -1
- (int) player:(Player) player almostWonInField1:(int) fi1 field2:(int) fi2 andField3:(int) fi3 {
	NSMutableArray* field = [self.field arrayRepresentation];
	Player p1 = [[field objectAtIndex:fi1] intValue];
	Player p2 = [[field objectAtIndex:fi2] intValue];
	Player p3 = [[field objectAtIndex:fi3] intValue];
	
	FieldChild* f1 = (FieldChild*) [self.field getChildByTag:fi1];
	FieldChild* f2 = (FieldChild*) [self.field getChildByTag:fi2];
	FieldChild* f3 = (FieldChild*) [self.field getChildByTag:fi3];	
	
	if (p1 == p2 && p3 == PlayerNone) {
		if (p1 == player && f1.age != 3 && f2.age != 3) {
			return fi3;
		}
	}
	
	if (p2 == p3 && p1 == PlayerNone) {
		if (p2 == player && f2.age != 3 && f3.age != 3) {
			return fi1;
		}
	}
	
	if (p1 == p3 && p2 == PlayerNone) {
		if (p1 == player && f1.age != 3 && f3.age != 3) {
			return fi2;
		}
	}
	
	return -1;
}

- (int) findMoveToWinForPlayer:(Player) player {
	int i;	
	int f00 = indexForXandY(0, 0);
	int f10 = indexForXandY(1, 0);
	int f20 = indexForXandY(2, 0);
	int f01 = indexForXandY(0, 1);
	int f11 = indexForXandY(1, 1);
	int f21 = indexForXandY(2, 1);
	int f02 = indexForXandY(0, 2);
	int f12 = indexForXandY(1, 2);
	int f22 = indexForXandY(2, 2);
	
	// zeile 0
	i = [self player: player almostWonInField1:f00 field2:f10 andField3:f20];
	if (i != -1) {
		return i;
	}
	
	// zeile 1
	i = [self player: player almostWonInField1:f01 field2:f11 andField3:f21];
	if (i != -1) {
		return i;
	}
	
	// zeile 2
	i = [self player: player almostWonInField1:f02 field2:f12 andField3:f22];
	if (i != -1) {
		return i;
	}
	
	// spalte 0
	i = [self player: player almostWonInField1:f00 field2:f01 andField3:f02];
	if (i != -1) {
		return i;
	}
	
	// spalte 1
	i = [self player: player almostWonInField1:f10 field2:f11 andField3:f12];
	if (i != -1) {
		return i;
	}		
	
	// spalte 2
	i = [self player: player almostWonInField1:f20 field2:f21 andField3:f22];
	if (i != -1) {
		return i;
	}		
	
	// ul nach or
	i = [self player: player almostWonInField1:f00 field2:f11 andField3:f22];
	if (i != -1) {
		return i;
	}
	
	// ur nach ol
	i = [self player: player almostWonInField1:f20 field2:f11 andField3:f02];
	if (i != -1) {
		return i;
	}	
	
	return -1;
}

- (bool) makeMoveToWin {
	int move = [self findMoveToWinForPlayer:PlayerTwo];
	if (move != -1) {
		[self.field makeMoveForChildWithTag:move byPlayer:PlayerTwo];
		return YES;
	}
	
	return NO;
}

- (bool) makeMoveToNotLose {
	int move = [self findMoveToWinForPlayer:PlayerOne];
	if (move != -1) {
		[self.field makeMoveForChildWithTag:move byPlayer:PlayerTwo];
		return YES;
	}
	
	return NO;
}



- (void) makeRandomMove {
	NSMutableArray* currentField = [self.field arrayRepresentation];
	NSMutableArray* freeFields = [NSMutableArray arrayWithCapacity:9];
	
	// find free fields
	for (int i = 0; i < [currentField count]; i++) {
		NSNumber* no = [currentField objectAtIndex:i];
		Player owner = [no intValue];
		if (owner == PlayerNone) {
			[freeFields addObject:[NSNumber numberWithInt:i]]; //save index in field
		}
	}
	
	// choose random one
	int randomIndex = rand() % [freeFields count];
	int tag = [[freeFields objectAtIndex:randomIndex] intValue];
	[self.field makeMoveForChildWithTag:tag byPlayer:PlayerTwo];
	
}

- (void) makeMove {
	if (![self makeMoveToWin]) {
		if (![self makeMoveToNotLose]) {
			[self makeRandomMove];
		}
	}
}

@end
