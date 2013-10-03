/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Sean Voisen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
