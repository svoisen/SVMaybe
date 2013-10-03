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

#import "SVMaybe.h"
#import "NSObject+SVMaybe.h"

#pragma mark - SVNothingMaybe

@interface SVNothingMaybe : SVMaybe; @end

@implementation SVNothingMaybe

- (SVMaybe *)whenSomething:(SVMaybe *(^)(id))mapBlock
{
    return self;
}

- (SVMaybe *)andMaybe:(SVMaybe *)maybe
{
    return self;
}

- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue else:(SVMaybe *(^)(id))block
{
    return defaultValue;
}

- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue
{
    return defaultValue;
}

- (BOOL)isNothing
{
    return YES;
}

- (BOOL)isSomething
{
    return NO;
}

- (id)justValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-justValue: no value for Nothing"
                                 userInfo:nil];
}

- (id)whenNothingReturn:(id)defaultValue elseReturn:(id(^)(id))block
{
    return defaultValue;
}

- (id)whenNothingReturn:(id)defaultValue
{
    return defaultValue;
}

@end

#pragma mark - SVJustMaybe

@interface SVJustMaybe : SVMaybe; @end

@implementation SVJustMaybe
{
    id _value;
}

- (id)initWithValue:(id)value
{
    self = [super init];
    
    if (self)
    {
        _value = value;
    }
    
    return self;
}

- (SVMaybe *)whenSomething:(SVMaybe *(^)(id))block
{
    return block(_value);
}

- (SVMaybe *)andMaybe:(SVMaybe *)maybe
{
    return maybe;
}

- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue else:(SVMaybe *(^)(id))block
{
    return block(_value);
}

- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue
{
    return self;
}

- (BOOL)isNothing
{
    return NO;
}

- (BOOL)isSomething
{
    return YES;
}

- (id)justValue
{
    return _value;
}

- (id)whenNothingReturn:(id)defaultValue elseReturn:(id(^)(id))block
{
    return block([self justValue]);
}

- (id)whenNothingReturn:(id)defaultValue
{
    return [self justValue];
}

@end

#pragma mark - SVMaybe

@implementation SVMaybe

+ (SVMaybe *)nothing
{
    static SVNothingMaybe *nothingInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        nothingInstance = [[SVNothingMaybe alloc] init];
    });
    
    return nothingInstance;
}

+ (SVMaybe *)maybe:(id)value
{
    if (value == nil || [self isNothing:value])
    {
        return [self nothing];
    }

    return [[SVJustMaybe alloc] initWithValue:value];
}

- (BOOL)isNothing
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-isNothing: must be overridden in subclass"
                                 userInfo:nil];
}

- (BOOL)isSomething
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-isSomething: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)whenSomething:(SVMaybe *(^)(id))block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenSomething: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)andMaybe:(SVMaybe *)maybe
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-andMaybe: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue else:(SVMaybe *(^)(id))block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenNothing:else: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenNothing: must be overridden in subclass"
                                 userInfo:nil];
}

- (id)justValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-justValue: must be overridden in subclass"
                                 userInfo:nil];
}

- (id)whenNothingReturn:(id)defaultValue elseReturn:(id(^)(id))block
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenNothingReturn:else: must be overridden in subclass"
                                 userInfo:nil];
}

- (id)whenNothingReturn:(id)defaultValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenNothingReturn: must be overridden in subclass"
                                 userInfo:nil];
}

@end
