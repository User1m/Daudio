//
//  Session.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "Session.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString *sessionKey = @"SessionKey";

@implementation Session

+ (void)saveSessions:(NSMutableArray<Session *> *)sessions userDefaults:(NSUserDefaults *)userDefaults  {
    [userDefaults setObject:sessions forKey:sessionKey];
}

+ (NSMutableArray<Session *>*)loadSessionsFromUserDefaults:(NSUserDefaults *)userDefaults {
    NSArray *sessions = [userDefaults objectForKey:sessionKey];
    return (sessions.count > 0) ? [NSMutableArray arrayWithArray:sessions] : [NSMutableArray new];
}

@end
