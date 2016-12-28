//
//  SessionDataService.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/26/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "SessionDataService.h"
#import "SessionManager.h"
#import "SessionTableViewCell.h"
#import "PlayerViewController.h"
#import "Session.h"
#import <Objection/Objection.h>
@import MediaPlayer;

static NSString *reuseID = @"sessionCell";
static NSString *userDefaults = @"userDefaults";
static NSString *musicImage = @"music";


@interface SessionDataService()
@property (nonatomic, strong, readwrite) NSMutableArray<Session *> *savedSessions;
@end

@implementation SessionDataService

objection_requires(userDefaults)

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults {
    self = [super init];
    if (self) {
        self.userDefaults = defaults;
        [self loadData];
    }
    return self;
}

- (void)saveData {
    [SessionManager saveSessions:[self.savedSessions copy] userDefaults:self.userDefaults];
}

- (void)loadData {
    self.savedSessions = [SessionManager loadSessionsFromUserDefaults:self.userDefaults];
}

- (void)addSession:(Session *)session {
    [self.savedSessions addObject:session];
}

- (void)removeSession:(NSUInteger)idx {
    [self.savedSessions removeObjectAtIndex:idx];
}

#pragma mark TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    Session *session = [self.savedSessions objectAtIndex:indexPath.row];
    UIImage *art1 = [session.firstTrack.artwork imageWithSize:cell.firstTrackArtImageView.bounds.size];
    UIImage *art2 = [session.secondTrack.artwork imageWithSize:cell.secondTrackArtImageView.bounds.size];
    cell.firstTrackLabel.text = session.firstTrack.title;
    cell.secondTrackLabel.text = session.secondTrack.title;
    cell.firstTrackArtImageView.image = (art1) ? art1 : [UIImage imageNamed:musicImage];
    cell.secondTrackArtImageView.image = (art2) ? art2 : [UIImage imageNamed:musicImage];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedSessions.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.savedSessions removeObjectAtIndex:indexPath.row];
        [self saveData];
        [tableView reloadData];
    }
}

@end
