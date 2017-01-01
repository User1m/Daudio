//
//  Note.m
//  Daudio
//
//  Created by Claudius Mbemba on 1/1/17.
//  Copyright © 2017 Claudius Mbemba. All rights reserved.
//

#import "Note.h"

static NSString *formattedText = @"formattedText";

@implementation Note

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (self) {
        self.formattedText = [decoder decodeObjectForKey:formattedText];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.formattedText forKey:formattedText];
}

@end
