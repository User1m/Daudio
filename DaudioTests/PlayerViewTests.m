//
//  PlayerViewTests.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

@import AVFoundation;
#import <XCTest/XCTest.h>
#import "PlayerViewModel.h"
#import "Session.h"

@interface PlayerViewTests : XCTestCase

@end

@implementation PlayerViewTests {
    Session *session;
    PlayerViewModel *sut;
}

- (void)setUp {
    [super setUp];
    //given
    session = [Session new];
    sut = [[PlayerViewModel alloc]initWithSession:session];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlayerView_ShouldCanBeSetWithSession {
    //then
    XCTAssertEqualObjects(sut.session, session);
}

- (void)testPlayerView_CanStartPlayers {
    //when
//    [sut startPlayers];
    
    //then
    XCTAssertTrue(sut.isPlaying);
    XCTAssertEqual(sut.audioPlayer1.volume, 1.0);
    XCTAssertEqual(sut.audioPlayer2.volume, 0.0);
}


@end
