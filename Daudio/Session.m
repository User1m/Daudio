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
static NSString *firstTrack = @"firstTrack";
static NSString *secondTrack = @"secondTrack";

@interface Session ()

@end

@implementation Session

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.firstTrack = [decoder decodeObjectForKey:firstTrack];
        self.secondTrack = [decoder decodeObjectForKey:secondTrack];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.firstTrack forKey:firstTrack];
    [coder encodeObject:self.secondTrack forKey:secondTrack];
}

#pragma mark Save/Load
+ (void)saveSessions:(NSArray<Session *> *)sessions userDefaults:(NSUserDefaults *)userDefaults  {
    [userDefaults setObject:[Session archiveObjects:sessions] forKey:sessionKey];
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
