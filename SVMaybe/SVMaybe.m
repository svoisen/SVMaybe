//
//  SVMaybe.m
//  SVMaybe
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "SVMaybe.h"
#import "NSObject+SVMaybe.h"

#pragma mark - SVNothingMaybe

@interface SVNothingMaybe : SVMaybe; @end

@implementation SVNothingMaybe

- (SVMaybe *)ifSomething:(SVMaybe *(^)(id value))mapBlock
{
    return self;
}

- (SVMaybe *)andMaybe:(SVMaybe *)maybe
{
    return self;
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

- (id)whenNothing:(id)defaultValue else:(id (^)(id))justBlock
{
    return defaultValue;
}

- (id)whenNothing:(id)defaultValue
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

- (SVMaybe *)ifSomething:(SVMaybe *(^)(id value))mapBlock
{
    return mapBlock(_value);
}

- (SVMaybe *)andMaybe:(SVMaybe *)maybe
{
    return maybe;
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

- (SVMaybe *)whenNothing:(id)defaultValue else:(SVMaybe *(^)(id))justBlock
{
    return justBlock([self justValue]);
}

- (SVMaybe *)whenNothing:(id)defaultValue
{
    return self;
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

- (SVMaybe *)ifSomething:(SVMaybe *(^)(id))mapBlock
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-ifSomething: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)andMaybe:(SVMaybe *)maybe
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-andMaybe: must be overridden in subclass"
                                 userInfo:nil];
}

- (id)justValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-justValue: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)whenNothing:(id)defaultValue else:(SVMaybe *(^)(id))justBlock
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenNothing:else: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)whenNothing:(id)defaultValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenNothing: must be overridden in subclass"
                                 userInfo:nil];
}

@end
