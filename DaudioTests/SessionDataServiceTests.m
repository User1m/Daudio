//
//  SessionDataServiceTests.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SessionDataService.h"
#import "SessionViewController.h"
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Session.h"

@interface SessionDataServiceTests : XCTestCase

@end

@implementation SessionDataServiceTests {
    SessionViewController *vc;
    SessionDataService *sut;
    UITableView *table;
}

- (void)setUp {
    [super setUp];
    //given
    vc = (SessionViewController *)[(UINavigationController *) [[UIStoryboard storyboardWithName:NSStringFromClass([SessionViewController class]) bundle:nil] instantiateInitialViewController] topViewController];
    //when
    [vc view];
    table = vc.tableView;
    sut = vc.dataService;

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSDS_CanLoadData {
    [sut loadData];
    assertThat(sut.savedSessions, is(notNilValue()));
}

- (void)testSDS_CanSaveData {
    NSUserDefaults *mockUD = mock([NSUserDefaults class]);
    sut.userDefaults = mockUD;
    [sut saveData];
    [verify(mockUD) setObject:instanceOf([NSArray class]) forKey:instanceOf([NSString class])];
}

- (void)testSDSTableView_ShouldReturnCorrectSaveSessionsCount {
    //given
    sut.savedSessions = [@[[Session new],[Session new]] mutableCopy];
    
    //when
    NSUInteger tableCount = [sut tableView:table numberOfRowsInSection:0];
    
    //then
    assertThatInteger(tableCount, is(equalToInt((NSUInteger)2)));
}

@end
