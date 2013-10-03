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
    if (maybeSomething != nil)
    {
        NSPredicate *definition = [self getNothingDefinition:maybeSomething];
        
        if (definition != nil)
        {
            return [definition evaluateWithObject:maybeSomething];
        }
    }
    
    return maybeSomething == nil;
}

+ (BOOL)isSomething:(id)maybeSomething
{
    return ![self isNothing:maybeSomething];
}

#pragma mark - Private

+ (NSPredicate *)getNothingDefinition:(id)maybeSomething
{
    NSPredicate *definition = [nothingDefinitions objectForKey:[maybeSomething class]];
    
    // Special handling for class clusters or definitions of superclasses
    if (definition == nil)
    {
        for (Class class in nothingDefinitions)
        {
            if ([maybeSomething isKindOfClass:class])
            {
                return [nothingDefinitions objectForKey:class];
            }
        }
    }
    
    return nil;
}

@end
