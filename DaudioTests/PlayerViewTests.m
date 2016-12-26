//
//  PlayerViewTests.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlayerView.h"
#import "Session.h"

@interface PlayerViewTests : XCTestCase

@end

@implementation PlayerViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlayerView_ShouldCanBeSetWithSession {
    
    //given
    Session *session = [Session new];
    PlayerView *sut = [[PlayerView alloc]initWithSession:session];
    
    //then
    XCTAssertEqualObjects(sut.session, session);
}


@end
