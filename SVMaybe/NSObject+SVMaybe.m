//
//  NSObject+SVMaybe.m
//  SVMaybe
//
//  Created by Sean Voisen on 10/2/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "NSObject+SVMaybe.h"

static NSMapTable *nothingDefinitions;

__attribute__((constructor))
static void initialize_nothingDefinitions()
{
    nothingDefinitions = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory capacity:0];
}

@implementation NSObject (SVMaybe)

+ (void)defineNothing:(NSPredicate *)definition
{
    [nothingDefinitions setObject:definition forKey:self];
}

+ (BOOL)isNothing:(id)maybeSomething
{
    NSPredicate *definition;
    
    for (Class class in nothingDefinitions)
    {
        if ([maybeSomething isKindOfClass:class])
        {
            definition = [nothingDefinitions objectForKey:class];
        }
    }

    if (definition != nil)
    {
        return [definition evaluateWithObject:maybeSomething];
    }
    
    return maybeSomething == nil;
}

- (id)andMaybe:(id)maybeSomething
{
    if ([NSObject isNothing:self])
    {
        return nil;
    }
    
    return maybeSomething;
}

- (id)ifNotNothing:(id(^)(id maybeSomething))block
{
    if ([NSObject isNothing:self])
    {
        return nil;
    }
    
    return block(self);
}

@end
