//
//  SVMaybeTests.m
//  MaybeTests
//
//  Created by Sean Voisen on 10/1/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "SVMaybe.h"
#import "NSObject+SVMaybe.h"
#import <XCTest/XCTest.h>

@interface MaybeTests : XCTestCase

@end

@implementation MaybeTests

- (void)testIsNothingReturnsTrueForNothing
{
    XCTAssertTrue([[SVMaybe nothing] isNothing], @"");
}

- (void)testAndMaybeNothingReturnsNothing
{
    SVMaybe *foo = [[[SVMaybe maybe:[NSNumber numberWithInt:0]] andMaybe:[SVMaybe nothing]] andMaybe:[SVMaybe maybe:@"bar"]];
    XCTAssertEqual(foo, [SVMaybe nothing], @"");
}

- (void)testAndMaybeNothingUsingPreprocessorReturnsNothing
{
    SVMaybe *foo = [[MAYBE([NSNumber numberWithInt:0]) andMaybe:NOTHING] andMaybe:MAYBE(@"bar")];
    XCTAssertEqual(foo, NOTHING, @"");
}

- (void)testMaybeNilReturnsNothing
{
    XCTAssertEqual(MAYBE(nil), NOTHING, @"");
}

- (void)testValueOfJustGivesValue
{
    SVMaybe *foo = MAYBE(@"bar");
    XCTAssertTrue([[foo justValue] isEqualToString:@"bar"], @"");
}

- (void)testValueOfNothingThrowsException
{
    XCTAssertThrows([NOTHING justValue], @"");
}

- (void)testNothingIfSomethingReturnsNothing
{
    SVMaybe *bound = [NOTHING ifSomething:^SVMaybe *(id value) {
        return MAYBE(@"foo");
    }];
    
    XCTAssertEqual(NOTHING, bound, @"");
}

- (void)testSimpleIfSomethingMapping
{
    SVMaybe *bound = [MAYBE(@"foo") ifSomething:^SVMaybe *(id value) {
        return MAYBE([(NSString *)value stringByAppendingString:@"bar"]);
    }];
    
    XCTAssertTrue([[bound justValue] isEqualToString:@"foobar"], @"");
}

- (void)testSimpleIfSomethingMappingWithMacro
{
    SVMaybe *bound = [MAYBE(@"foo") ifSomething:MAP(something, [something stringByAppendingString:@"bar"])];
    
    XCTAssertTrue([[bound justValue] isEqualToString:@"foobar"], @"");
}

- (void)testWhenNothingWithNothingReturnsDefaultValue
{
    NSString *foo = [NOTHING whenNothing:@"foo" else:^id(id value) {
        return MAYBE(@"bar");
    }];
    
    XCTAssertTrue([foo isEqualToString:@"foo"], @"");
}

- (void)testWhenNothingWithJustCallsBlock
{
    NSString *foo = [MAYBE(@"foo") whenNothing:@"foo" else:^id(id value) {
        return @"bar";
    }];
    
    XCTAssertTrue([foo isEqualToString:@"bar"], @"");
}

- (void)testComplexBindingWithMacro
{
    [NSString defineNothing:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [(NSString *)evaluatedObject length] == 0;
    }]];
    
    [NSDictionary defineNothing:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [(NSDictionary *)evaluatedObject count] == 0;
    }]];
    
    NSDictionary *person = @{@"firstName":@"", @"lastName":@"Bar", @"address":@{}};
    
    NSString *street = [[[MAYBE(person) ifSomething:MAP(person, MAYBE([person objectForKey:@"address"]))]
                                        ifSomething:MAP(address, MAYBE([address objectForKey:@"street"]))]
                                        whenNothing:@"No street"];
    
    XCTAssertTrue([street isEqualToString:@"No street"], @"");
}

@end
