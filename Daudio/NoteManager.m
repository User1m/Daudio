//
//  NoteManager.m
//  Daudio
//
//  Created by Claudius Mbemba on 1/1/17.
//  Copyright © 2017 Claudius Mbemba. All rights reserved.
//

#import "Note.h"
#import "NoteManager.h"

@implementation NoteManager

#pragma mark Save/Get

+ (void)saveNote:(Note *)note userDefaults:(NSUserDefaults *)userDefaults withKey:(NSString *)noteKey  {
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:note] forKey:noteKey];
}

+ (void)removeNoteWithKey:(NSString *)noteKey fromUserDefaults:(NSUserDefaults *)userDefaults {
    [userDefaults removeObjectForKey:noteKey];
}

+ (Note *)getNote:(NSString*)noteKey fromUserDefaults:(NSUserDefaults *)userDefaults {
    Note *decodedNote = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:noteKey]];
    return decodedNote;
}

@end
