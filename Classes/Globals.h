//
//  Globals.h
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

typedef enum {
	PlayerNone,
	PlayerOne,
	PlayerTwo
} Player;

#define kBackgroundColor3 ccc3(23, 23, 23)
#define kBackgroundColor4 ccc4(23, 23, 23, 255)
#define kBackToMenuButtonColor ccc4(26, 26, 26, 255)

extern const float kMenuItemAnimationDuration;

extern const float kElasticPeriod;

extern const float kFieldSpacing;
extern const float kFieldBorderSpacingX;
extern const float kFieldBorderSpacingY;
extern const float kFieldChildSize;
extern const float kFieldMoveDuration;
extern const float kFieldOwnerFadeDuration;
extern const float kActivePlayerFadeDuration;
extern const float kFieldInAnimationDuration;
extern const float kFieldOutAnimationDuration;

extern const float kAdditionalAIDelay;

extern const float kBackToMenuButtonSize;