//
//  Session.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPMediaItem;

@interface Session : NSCoder

@property (nonatomic, strong) MPMediaItem *firstTrack;
@property (nonatomic, strong) MPMediaItem *secondTrack;

+ (void)saveSessions:(NSArray<Session *> *)sessions userDefaults:(NSUserDefaults *)userDefaults;
+ (NSMutableArray<Session *>*)loadSessionsFromUserDefaults:(NSUserDefaults *)userDefaults;

@end
