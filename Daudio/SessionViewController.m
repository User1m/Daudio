//
//  SessionViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "SessionTableViewCell.h"
#import "SessionViewController.h"
#import "PlayerViewController.h"
#import "UIViewController+Storyboard.h"
#import "Session.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SessionViewController () <UITableViewDelegate, UITableViewDataSource, PlayerViewControllerDelegate>

@end

@implementation SessionViewController {
    Session *_selectedSession;
    PlayerViewController *playerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    playerVC = [PlayerViewController controllerWithStoryboard];
    self.savedSessions = [Session loadSessionsFromUserDefaults:NSUserDefaults.standardUserDefaults];
}

#pragma mark TableView Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
    Session * session = [_savedSessions objectAtIndex:indexPath.row];
    cell.firstTrackLabel.text = session.firstTrack.title;
    cell.secondTrackLabel.text = session.secondTrack.title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _savedSessions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    playerVC.session = _selectedSession;
    [self.navigationController pushViewController:playerVC animated:YES];
}

#pragma mark Player Delegates

- (void)didSetNewSession:(Session *)session {
    [_savedSessions addObject:session];
}

#pragma mark Actions

- (IBAction)createNewSession:(id)sender {
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (IBAction)saveAllSessions:(id)sender {
    [Session saveSessions:_savedSessions userDefaults:NSUserDefaults.standardUserDefaults];
}

@end
