//
//  SessionTests.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Session.h"
#import "MockMPMediaItem.h"

@interface SessionTests : XCTestCase

@end

@implementation SessionTests {
    Session *sut;
    MockMPMediaItem *item;

}

- (void)setUp {
    [super setUp];
    
    //given
    sut = [Session new];
    item = [MockMPMediaItem new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSessionFirstTrack_CanBeSet {
    //when
    sut.firstTrack = item;
    
    //then
    XCTAssertEqual(sut.firstTrack, item);
}

- (void)testSessionFirstTrackTitle_CanBeRetrieved {
    //when
    sut.firstTrack = item;

    //then
    XCTAssertEqualObjects(sut.firstTrack.title, @"Controlla");
}

- (void)testSessionSecondTrack_CanBeSet {
    //when
    sut.secondTrack = item;
    
    //then
    XCTAssertEqual(sut.secondTrack, item);
}

- (void)testSessionSecondTrackTitle_CanBeRetrieved {
    //when
    sut.secondTrack = item;
    
    //then
    XCTAssertEqualObjects(sut.secondTrack.title, @"Controlla");
}

@end
