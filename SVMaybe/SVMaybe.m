//
//  SVMaybe.m
//  SVMaybe
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "SVMaybe.h"

#pragma mark - SVNothingMaybe

@interface SVNothingMaybe : SVMaybe; @end

@implementation SVNothingMaybe

- (void)bind:(SVMaybe *(^)(id value))binder
{
    binder(self);
}

- (SVMaybe *)then:(SVMaybe *)maybe
{
    return self;
}

- (BOOL)isNothing
{
    return YES;
}

- (id)justValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-justValue: no value for Nothing"
                                 userInfo:nil];
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

- (void)bind:(SVMaybe *(^)(id value))binder
{
    binder(_value);
}

- (SVMaybe *)then:(SVMaybe *)maybe
{
    return maybe;
}

- (BOOL)isNothing
{
    return NO;
}

- (id)justValue
{
    return _value;
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
    return [[SVJustMaybe alloc] initWithValue:value];
}

- (BOOL)isNothing
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-isNothing: must be overridden in subclass"
                                 userInfo:nil];
}

- (SVMaybe *)then:(SVMaybe *)maybe
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-then: must be overridden in subclass"
                                 userInfo:nil];
}

- (id)justValue
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-justValue: must be overridden in subclass"
                                 userInfo:nil];
}

@end
