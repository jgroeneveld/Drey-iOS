//
//  MenuLayer.h
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	GameModePlayFriend,
	GameModePlayAI
} GameMode;

@interface MenuLayer : CCLayer {
	CCMenu* topMenu_;
	CCMenu* middleMenu_;
	CCMenu* bottomMenu_;
	
	CCSprite* playFriendIndicator_;
	CCSprite* playAIIndicator_;	
	
	GameMode gameMode_;
}

@property(nonatomic, retain) CCMenu* topMenu;
@property(nonatomic, retain) CCMenu* middleMenu;
@property(nonatomic, retain) CCMenu* bottomMenu;

@property(nonatomic, retain) CCSprite* playFriendIndicator;
@property(nonatomic, retain) CCSprite* playAIIndicator;

@end
