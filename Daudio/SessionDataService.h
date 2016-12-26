//
//  SessionDataService.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Session;
@protocol PlayerViewControllerDelegate;

@interface SessionDataService : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<Session *> *savedSessions;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults;
- (void)saveData;
- (void)loadData;


@end
