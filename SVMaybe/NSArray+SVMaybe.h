//
//  NSArray+SVMaybe.h
//  SVMaybe
//
//  Created by Sean Voisen on 10/2/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVMaybe;

@interface NSArray (SVMaybe)

- (SVMaybe *)asMaybe;
- (NSArray *)onlyJusts;

@end
