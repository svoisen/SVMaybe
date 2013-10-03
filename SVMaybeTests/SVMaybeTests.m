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
    SVMaybe *foo = [[Maybe([NSNumber numberWithInt:0]) andMaybe:Nothing] andMaybe:Maybe(@"bar")];
    XCTAssertEqual(foo, Nothing, @"");
}

- (void)testMaybeNilReturnsNothing
{
    XCTAssertEqual(Maybe(nil), Nothing, @"");
}

- (void)testValueOfJustGivesValue
{
    SVMaybe *foo = Maybe(@"bar");
    XCTAssertTrue([[foo justValue] isEqualToString:@"bar"], @"");
}

- (void)testValueOfNothingThrowsException
{
    XCTAssertThrows([Nothing justValue], @"");
}

- (void)testNothingIfSomethingReturnsNothing
{
    SVMaybe *bound = [Nothing whenSomething:^SVMaybe *(id value) {
        return Maybe(@"foo");
    }];
    
    XCTAssertEqual(Nothing, bound, @"");
}

- (void)testSimpleIfSomethingMapping
{
    SVMaybe *bound = [Maybe(@"foo") whenSomething:^SVMaybe *(id value) {
        return Maybe([(NSString *)value stringByAppendingString:@"bar"]);
    }];
    
    XCTAssertTrue([[bound justValue] isEqualToString:@"foobar"], @"");
}

- (void)testSimpleIfSomethingMappingWithMacro
{
    SVMaybe *bound = [Maybe(@"foo") whenSomething:MapMaybe(something, [something stringByAppendingString:@"bar"])];
    
    XCTAssertTrue([[bound justValue] isEqualToString:@"foobar"], @"");
}

- (void)testWhenNothingWithNothingReturnsDefaultValue
{
    NSString *foo = [Nothing whenNothingReturn:@"foo" elseReturn:^id(id value) {
        return Maybe(@"bar");
    }];
    
    XCTAssertTrue([foo isEqualToString:@"foo"], @"");
}

- (void)testWhenNothingWithJustCallsBlock
{
    NSString *foo = [Maybe(@"foo") whenNothingReturn:@"foo" elseReturn:^id(id value) {
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
    
    NSString *street = [[[Maybe(person) whenSomething:MapMaybe(person, [person objectForKey:@"address"])]
                                        whenSomething:MapMaybe(address, [address objectForKey:@"street"])]
                                        whenNothingReturn:@"No street"];
    
    XCTAssertTrue([street isEqualToString:@"No street"], @"");
}

- (void)testMultipleWhenElse
{
    [NSString defineNothing:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [(NSString *)evaluatedObject length] == 0;
    }]];
    
    [NSDictionary defineNothing:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [(NSDictionary *)evaluatedObject count] == 0;
    }]];
    
    NSDictionary *person = @{@"firstName":@"Foo", @"lastName":@"Bar", @"address":@{}};
    NSString *name = [[[Maybe(person) whenNothing:Maybe(@"No person") else:MapMaybe(person, [person objectForKey:@"firstName"])]
                                      whenNothing:Maybe(@"No first name")] justValue];
    
    XCTAssertTrue([name isEqualToString:@"Foo"], @"%@", name);
}

@end
