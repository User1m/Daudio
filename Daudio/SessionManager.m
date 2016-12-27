//
//  SessionManager.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "SessionManager.h"
#import "Session.h"

static NSString *sessionKey = @"SessionKey";

@implementation SessionManager

#pragma mark Save/Load

+ (void)saveSessions:(NSArray<Session *> *)sessions userDefaults:(NSUserDefaults *)userDefaults  {
    [userDefaults setObject:[self archiveObjects:sessions] forKey:sessionKey];
}

+ (NSMutableArray<Session *>*)loadSessionsFromUserDefaults:(NSUserDefaults *)userDefaults {
    NSMutableArray *unarchiveArray = [userDefaults objectForKey:sessionKey];
    NSMutableArray *dataArray = [NSMutableArray new];
    if (unarchiveArray.count > 0) {
        for (NSData *sessionData in unarchiveArray) {
            Session *decodedData = [NSKeyedUnarchiver unarchiveObjectWithData:sessionData];
            [dataArray addObject:decodedData];
        }
    }
    return dataArray;
}

+ (NSMutableArray *)archiveObjects:(NSArray *)dataArray {
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    for (Session *session in dataArray) {
        NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:session];
        [archiveArray addObject:encodedData];
    }
    return archiveArray;
}

@end
