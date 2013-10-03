//
//  NSObject+SVMaybeTests.m
//  SVMaybe
//
//  Created by Sean Voisen on 10/2/13.
//  Copyright (c) 2013 Sean Voisen. All rights reserved.
//

#import "NSObject+SVMaybe.h"
#import <XCTest/XCTest.h>

@interface NSObject_SVMaybeTests : XCTestCase

@end

@implementation NSObject_SVMaybeTests

- (void)testAndMaybeWithEmptyStringIsNothing
{
    [NSString defineNothing:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [(NSString *)evaluatedObject length] == 0;
    }]];
    
    NSDictionary *person = @{@"firstName":@"Foo", @"lastName":@"", @"address":@{@"street":@"1234 Fake St."}};
    NSString *mailingAddress = [[person andMaybe:[person objectForKey:@"firstName"]] andMaybe:[person objectForKey:@"lastName"]];
    XCTAssertTrue(IS_NOTHING(mailingAddress), @"");
}

- (void)testAndMaybeWithStringsReturnsLastString
{
    NSDictionary *person = @{@"firstName":@"Foo", @"lastName":@"Bar", @"address":@{@"street":@"1234 Fake St."}};
    NSString *mailingAddress = [[person andMaybe:[person objectForKey:@"firstName"]] andMaybe:[person objectForKey:@"lastName"]];
    XCTAssertTrue([mailingAddress isEqualToString:@"Bar"], @"");
}

- (void)testBindWithEmptyStringReturnsNil
{
    [NSString defineNothing:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [(NSString *)evaluatedObject length] == 0;
    }]];
    
    NSDictionary *person = @{@"firstName":@"", @"lastName":@"Bar", @"address":@{@"street":@"1234 Fake St."}};
    NSString *possesiveName = [[person ifNotNothing:^id(NSDictionary *person) {
        return [person objectForKey:@"firstName"];
    }] ifNotNothing:^id(NSString *firstName) {
        return [NSString stringWithFormat:@"%@'s", firstName];
    }];
    
    XCTAssertNil(possesiveName, @"");
}

@end
