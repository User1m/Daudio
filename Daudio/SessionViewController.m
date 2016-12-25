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

static NSString *reuseID = @"sessionCell";

@interface SessionViewController () <UITableViewDelegate, UITableViewDataSource, PlayerViewControllerDelegate>

@end

@implementation SessionViewController {
    PlayerViewController *playerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    playerVC = [PlayerViewController controllerWithStoryboard];
    playerVC.delegate = self;
    self.savedSessions = [Session loadSessionsFromUserDefaults:NSUserDefaults.standardUserDefaults];
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setupRefreshControl {
    self.tableView.refreshControl = [UIRefreshControl new];
    self.tableView.refreshControl.tintColor = [UIColor grayColor];
    self.tableView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

-(void)refreshData {
    [self.tableView reloadData];
    [self.tableView.refreshControl endRefreshing];
}

#pragma mark TableView Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    Session *session = [_savedSessions objectAtIndex:indexPath.row];
    UIImage *art1 = [session.firstTrack.artwork imageWithSize:cell.firstTrackArtImageView.bounds.size];
    UIImage *art2 = [session.secondTrack.artwork imageWithSize:cell.secondTrackArtImageView.bounds.size];
    cell.firstTrackLabel.text = session.firstTrack.title;
    cell.secondTrackLabel.text = session.secondTrack.title;
    cell.firstTrackArtImageView.image = (art1) ? art1 : [UIImage imageNamed:@"music"];
    cell.secondTrackArtImageView.image = (art2) ? art2 : [UIImage imageNamed:@"music"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _savedSessions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    playerVC.session = [self.savedSessions objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.savedSessions removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark Player Delegates

- (void)didSetNewSession:(Session *)session {
    [self.savedSessions addObject:session];
}

#pragma mark Actions

- (IBAction)createNewSession:(id)sender {
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (IBAction)saveAllSessions:(id)sender {
    [Session saveSessions:[self.savedSessions copy] userDefaults:NSUserDefaults.standardUserDefaults];
}

@end
