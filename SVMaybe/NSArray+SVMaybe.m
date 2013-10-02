//
//  NSArray+SVMaybe.m
//  SVMaybe
//
//  Created by Sean Voisen on 10/2/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "NSArray+SVMaybe.h"
#import "SVMaybe.h"

@implementation NSArray (SVMaybe)

- (SVMaybe *)asMaybe
{
    if (self.count == 0)
    {
        return NOTHING;
    }
    
    return JUST(self);
}

- (NSArray *)onlyJusts
{
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[SVMaybe class]] == NO)
        {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Non-maybe type in array"
                                         userInfo:nil];
        }
        else
        {
            return [(SVMaybe *)evaluatedObject isJust];
        }
    }]];
}

- (NSArray *)stuff
{
    return nil;
}

@end
