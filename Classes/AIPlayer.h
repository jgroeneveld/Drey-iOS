//
//  AIPlayer.h
//  drey
//
//  Created by Jaap Groeneveld on 18.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"

@interface AIPlayer : NSObject {
	Field* field_;
}

@property(nonatomic, retain) Field* field;

- (void) reset; // aufrufen bevor der spieler benutzt wird
- (void) makeMove;

@end
