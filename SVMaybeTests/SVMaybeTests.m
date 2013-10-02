//
//  SVMaybeTests.m
//  MaybeTests
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "SVMaybe.h"
#import <XCTest/XCTest.h>

@interface MaybeTests : XCTestCase

@end

@implementation MaybeTests

- (void)testIsNothingReturnsTrueForNothing
{
    XCTAssertTrue([[SVMaybe nothing] isNothing], @"");
}

- (void)testThenWithNothingReturnsNothing
{
    SVMaybe *foo = [[[SVMaybe just:[NSNumber numberWithInt:0]] then:[SVMaybe nothing]] then:[SVMaybe just:@"bar"]];
    XCTAssertEqual(foo, [SVMaybe nothing], @"");
}

- (void)testThenWithNothingUsingPreprocessorReturnsNothing
{
    SVMaybe *foo = [[JUST([NSNumber numberWithInt:0]) then:NOTHING] then:JUST(@"bar")];
    XCTAssertEqual(foo, NOTHING, @"");
}

- (void)testValueOfJustGivesValue
{
    SVMaybe *foo = JUST(@"bar");
    XCTAssertTrue([[foo justValue] isEqualToString:@"bar"], @"");
}

- (void)testValueOfNothingThrowsException
{
    XCTAssertThrows([NOTHING justValue], @"");
}

@end
