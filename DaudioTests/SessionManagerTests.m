//
//  SessionManager.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Session.h"
#import "SessionManager.h"
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

static NSString *sessionKey = @"SessionKey";

@interface SessionManagerTests : XCTestCase

@end

@implementation SessionManagerTests {
    NSUserDefaults *mockDefaults;
}

- (void)setUp {
    [super setUp];
    //given
    mockDefaults = mock([NSUserDefaults class]);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testManager_CanSaveSessions {
    //when
    [SessionManager saveSessions:@[[Session new], [Session new]] userDefaults:mockDefaults];
    
    //then
    [verifyCount(mockDefaults, times(1)) setObject:instanceOf([NSArray class]) forKey:sessionKey];
}

- (void)testManager_CanLoadSavedSessions {
    //when
    [SessionManager loadSessionsFromUserDefaults:mockDefaults];
    
    //then
    [verifyCount(mockDefaults, times(1)) objectForKey:sessionKey];
}


@end
