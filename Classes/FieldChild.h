//
//  FieldChild.h
//  drey
//
//  Created by Jaap Groeneveld on 16.11.10.
//  Copyright 2010 raute2a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldChild : CCNode {
	Player owningPlayer_;
	int age_;
}

@property(nonatomic, assign) Player owningPlayer;
@property(nonatomic, assign) int age;

- (void) animateOwnerOpacityTo:(GLubyte) op;

@end
