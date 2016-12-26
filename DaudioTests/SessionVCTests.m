//
//  SessionVCTests.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SessionViewController.h"

@interface SessionVCTests : XCTestCase

@end

@implementation SessionVCTests {
    SessionViewController *sut;
}

- (void)setUp {
    [super setUp];
    //given
    sut = (SessionViewController *)[(UINavigationController *) [[UIStoryboard storyboardWithName:NSStringFromClass([SessionViewController class]) bundle:nil] instantiateInitialViewController] topViewController];
    
    //when
    [sut view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVC_ViewIsConnected {
    //then
    XCTAssertNotNil(sut.view);
}

- (void)testVC_TableViewIsConnected {
    //then
    XCTAssertNotNil(sut.tableView);
}

- (void)testSaveAllButton_ShouldBeConnectedAndHaveAction {
    NSString *sel = [NSString stringWithFormat:@"%@", NSStringFromSelector([sut.saveAllButton action])];
    
    //then
    XCTAssertNotNil(sut.saveAllButton);
    XCTAssertEqualObjects(sel, @"saveAllSessions:");
}

- (void)testAddButton_ShouldBeConnectedAndHaveAction {
    NSString *sel = [NSString stringWithFormat:@"%@", NSStringFromSelector([sut.addButton action])];
    
    //then
    XCTAssertNotNil(sut.addButton);
    XCTAssertEqualObjects(sel, @"createNewSession:");
}


@end
