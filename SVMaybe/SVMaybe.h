//
//  SVMaybe.h
//  SVMaybe
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#define MAKE_MAYBE_GENERIC(__className) \
@protocol __className <NSObject> \
@end \
@class __className;  \
@interface SVMaybe (__className##_SVMaybe_Generics) <__className> \
+ (SVMaybe <__className> *)nothing; \
+ (SVMaybe <__className> *)just:(__className *)value; \
- (__className *)justValue; \
@end

#define JUST(x) [SVMaybe just:x]
#define NOTHING [SVMaybe nothing]

#import <Foundation/Foundation.h>

@interface SVMaybe : NSObject
+ (SVMaybe *)nothing;
+ (SVMaybe *)just:(id)value;
- (SVMaybe *)and:(SVMaybe *)maybe;
- (SVMaybe *)map:(SVMaybe *(^)(id value))mapBlock;
- (id)whenNothing:(id)nothingValue else:(id(^)(id value))justBlock;
- (BOOL)isNothing;
- (BOOL)isJust;
- (id)justValue;
@end
