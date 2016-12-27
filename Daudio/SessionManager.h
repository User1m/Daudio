//
//  SessionManager.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session;

@interface SessionManager : NSObject

+ (void)saveSessions:(NSArray<Session *> *)sessions userDefaults:(NSUserDefaults *)userDefaults;
+ (NSMutableArray<Session *>*)loadSessionsFromUserDefaults:(NSUserDefaults *)userDefaults;

@end
