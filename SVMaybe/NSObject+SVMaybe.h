//
//  NSObject+SVMaybe.h
//  SVMaybe
//
//  Created by Sean Voisen on 10/2/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_NOTHING(x) [NSObject isNothing:x]
#define IS_NOT_NOTHING(x) ![NSObject isNothing:x]

@interface NSObject (SVMaybe)

+ (void)defineNothing:(NSPredicate *)definition;
+ (BOOL)isNothing:(id)maybeSomething;
- (id)andMaybe:(id)maybeSomething;
- (id)ifNotNothing:(id(^)(id maybeSomething))block;
- (id)whenNothing

@end
