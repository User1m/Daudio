//
//  NoteManager.h
//  Daudio
//
//  Created by Claudius Mbemba on 1/1/17.
//  Copyright © 2017 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Note;

@interface NoteManager : NSObject

+ (void)saveNote:(Note *)note userDefaults:(NSUserDefaults *)userDefaults withKey:(NSString *)noteKey;
+ (void)removeNoteWithKey:(NSString *)noteKey fromUserDefaults:(NSUserDefaults *)userDefaults;
+ (Note *)getNote:(NSString*)noteKey fromUserDefaults:(NSUserDefaults *)userDefaults;

@end
