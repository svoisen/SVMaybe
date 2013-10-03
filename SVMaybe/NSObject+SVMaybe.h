//
//  NSObject+SVMaybe.h
//  SVMaybe
//
//  Created by Sean Voisen on 10/2/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SVMaybe)

+ (void)defineNothing:(NSPredicate *)definition;
+ (BOOL)isNothing:(id)maybeSomething;

@end
