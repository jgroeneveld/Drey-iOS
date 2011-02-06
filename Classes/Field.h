//
//  Field.h
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldChild.h"

#define indexForXandY(x, y) x*3+y

@interface Field : CCNode {
	FieldChild* p1F1_;
	FieldChild* p1F2_;
	FieldChild* p1F3_;	
	
	FieldChild* p2F1_;
	FieldChild* p2F2_;
	FieldChild* p2F3_;		
}

- (bool) hitAt:(CGPoint) location byPlayer:(Player) player; // return: valid move
- (void) makeMoveForChildWithTag:(int) tag byPlayer:(Player) player;
- (Player) playerInArray:(NSMutableArray*) array forX:(int) x andY:(int) y;
- (Player) checkForWinner;
- (Player) checkForWinnerInArray:(NSMutableArray*) array;
- (void) highlightBlocksOfPlayer:(Player) player;
- (NSMutableArray*) arrayRepresentation;

@end
