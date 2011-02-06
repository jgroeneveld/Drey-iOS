//
//  GameLayer.h
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"
#import "AIPlayer.h"

@interface GameLayer : CCLayer {
	Player currentPlayer_;
	Field* field_;
	CCSprite* activePlayer1_;
	CCSprite* activePlayer2_;
	CCMenu* backMenu_;
	bool gameOver_;
	
	AIPlayer* ai_;
	
	bool allowHumansMove_;
	bool isBackButtonEnabled_;
}

@property(nonatomic, retain) Field* field;
@property(nonatomic, retain) CCSprite* activePlayer1;
@property(nonatomic, retain) CCSprite* activePlayer2;
@property(nonatomic, retain) CCMenu* backMenu;

@property(nonatomic, retain) AIPlayer* ai;
@end
