//
//  SVMaybeTests.m
//  MaybeTests
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "SVMaybe.h"
#import "NSArray+SVMaybe.h"
#import <XCTest/XCTest.h>

MAKE_MAYBE_GENERIC(NSString)

@interface MaybeTests : XCTestCase

@end

@implementation MaybeTests

- (void)testIsNothingReturnsTrueForNothing
{
    XCTAssertTrue([[SVMaybe nothing] isNothing], @"");
}

- (void)testAndWithNothingReturnsNothing
{
    SVMaybe *foo = [[[SVMaybe just:[NSNumber numberWithInt:0]] and:[SVMaybe nothing]] and:[SVMaybe just:@"bar"]];
    XCTAssertEqual(foo, [SVMaybe nothing], @"");
}

- (void)testAndWithNothingUsingPreprocessorReturnsNothing
{
    SVMaybe *foo = [[JUST([NSNumber numberWithInt:0]) and:NOTHING] and:JUST(@"bar")];
    XCTAssertEqual(foo, NOTHING, @"");
}

- (void)testJustNilReturnsNothing
{
    XCTAssertEqual(JUST(nil), NOTHING, @"");
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

- (void)testNothingMappedReturnsNothing
{
    SVMaybe *bound = [NOTHING map:^SVMaybe *(id value) {
        return JUST(@"foo");
    }];
    
    XCTAssertEqual(NOTHING, bound, @"");
}

- (void)testSimpleMapping
{
    SVMaybe<NSString> *bound = [JUST(@"foo") map:^SVMaybe *(id value) {
        return JUST([(NSString *)value stringByAppendingString:@"bar"]);
    }];
    
    XCTAssertTrue([[bound justValue] isEqualToString:@"foobar"], @"");
}

- (void)testWhenNothingWithNothingReturnsNothingValue
{
    NSString *foo = [NOTHING whenNothing:@"foo" else:^id(id value) {
        return @"bar";
    }];
    
    XCTAssertTrue([foo isEqualToString:@"foo"], @"");
}

- (void)testWhenNothingWithJustCallsBlock
{
    NSString *foo = [JUST(@"foo") whenNothing:@"foo" else:^id(id value) {
        return @"bar";
    }];
    
    XCTAssertTrue([foo isEqualToString:@"bar"], @"");
}

- (void)testUseForStringConcatenation
{
    NSDictionary *person = @{@"firstName":@"Foo", @"lastName":@"Bar"};
    
    NSString *fullName = [[[JUST(person) and:JUST([person objectForKey:@"firstName"])] and:JUST([person objectForKey:@"lastName"])] whenNothing:@"" else:^id(id value) {
        return [NSString stringWithFormat:@"%@ %@", [person objectForKey:@"firstName"], [person objectForKey:@"lastName"]];
    }];

    XCTAssertTrue([fullName isEqualToString:@"Foo Bar"], @"");
}

- (void)testOnlyJustsOnNothingReturnsEmptyArray
{
    NSArray *arr = [NSArray arrayWithObjects:NOTHING, nil];
    XCTAssertEqual([arr onlyJusts].count, (NSUInteger)0U, @"");
}

- (void)testArrayOnlyJustsFilter
{
    NSDictionary *person = @{@"firstName":@"Foo", @"lastName":@"Bar"};
    
    NSString *fullName = [[[@[JUST(person), JUST([person objectForKey:@"firstName"]), JUST([person objectForKey:@"lastName"])] onlyJusts] asMaybe] whenNothing:@"" else:^id(id value) {
        return [NSString stringWithFormat:@"%@ %@", [person objectForKey:@"firstName"], [person objectForKey:@"lastName"]];
    }];
    
    XCTAssertTrue([fullName isEqualToString:@"Foo Bar"], @"");
}

@end
