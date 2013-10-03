//
//  SVMaybe.h
//  SVMaybe
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#define MAYBE(x) [SVMaybe maybe:x]
#define NOTHING [SVMaybe nothing]
#define MAP(something, value) ^SVMaybe *(id something) { return MAYBE(value); }

#import <Foundation/Foundation.h>

@interface SVMaybe : NSObject
+ (SVMaybe *)nothing;
+ (SVMaybe *)maybe:(id)value;
- (SVMaybe *)andMaybe:(SVMaybe *)maybe;
- (SVMaybe *)ifSomething:(SVMaybe *(^)(id))block;
- (SVMaybe *)whenNothing:(id)defaultValue else:(SVMaybe *(^)(id))block;
- (SVMaybe *)whenNothing:(id)defaultValue;
- (BOOL)isNothing;
- (BOOL)isSomething;
- (id)justValue;
@end