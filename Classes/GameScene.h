//
//  GameScene.h
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AIPlayer.h"

@interface GameScene : CCScene {

}

- (id) initWithAI:(AIPlayer*) ai;

+ (id) gameWithAI:(AIPlayer*) ai;
+ (id) game;

@end
