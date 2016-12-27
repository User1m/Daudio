//
//  Session.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "Session.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Objection/Objection.h>

static NSString *firstTrack = @"firstTrack";
static NSString *secondTrack = @"secondTrack";

@interface Session ()

@end

@implementation Session

- (instancetype)init {
    self = [super init];
    if (self) {
        _isNewSession = YES;
    }
    return self;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
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

@end
