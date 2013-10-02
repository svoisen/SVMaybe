//
//  SVMaybe.m
//  SVMaybe
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "SVMaybe.h"
#import "NSArray+SVMaybe.h"

#pragma mark - SVNothingMaybe

@interface SVNothingMaybe : SVMaybe; @end

@implementation SVNothingMaybe

- (SVMaybe *)map:(SVMaybe *(^)(id value))mapBlock
{
    return self;
}

- (SVMaybe *)and:(SVMaybe *)maybe
{
    return self;
}

- (BOOL)isNothing
{
    return YES;
}

- (BOOL)isJust
{
    return NO;
}

- (id)justValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-justValue: no value for Nothing"
                                 userInfo:nil];
}

- (id)whenNothing:(id)nothingValue else:(id (^)(id))justBlock
{
    return nothingValue;
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

- (SVMaybe *)map:(SVMaybe *(^)(id value))mapBlock
{
    return mapBlock(_value);
}

- (SVMaybe *)and:(SVMaybe *)maybe
{
    return maybe;
}

- (BOOL)isNothing
{
    return NO;
}

- (BOOL)isJust
{
    return YES;
}

- (id)justValue
{
    return _value;
}

- (id)whenNothing:(id)nothingValue else:(id (^)(id))justBlock
{
    return justBlock([self justValue]);
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

+ (SVMaybe *)just:(id)value
{
    if (value == nil)
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

- (BOOL)isJust
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-isJust: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)map:(SVMaybe *(^)(id))mapBlock
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-map: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)and:(SVMaybe *)maybe
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-and: must be overridden in subclass"
                                 userInfo:nil];
}

- (id)justValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-justValue: must be overridden in subclass"
                                 userInfo:nil];
}

- (id)whenNothing:(id)nothingValue else:(id (^)(id))justBlock
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-whenNothing:else: must be overridden in subclass"
                                 userInfo:nil];
}

@end
