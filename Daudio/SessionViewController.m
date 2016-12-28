//
//  SessionViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

@import MediaPlayer;
#import "SessionViewController.h"
#import "PlayerViewController.h"
#import "SessionDataService.h"
#import "UIViewController+Storyboard.h"
#import <Objection/Objection.h>
#import "UIAlertController+Utils.h"

static NSString *dataService = @"dataService";

@interface SessionViewController () <MPMediaPickerControllerDelegate, UITableViewDelegate, PlayerViewControllerDelegate>

@end

@implementation SessionViewController {
    MPMediaPickerController *_mediaPicker;
    PlayerViewController *playerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDependencies];
    [self setupPicker];
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)refreshData {
    [self.tableView reloadData];
    [self.tableView.refreshControl endRefreshing];
}

#pragma mark Setups

- (void)setupPicker {
    _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    _mediaPicker.delegate = self;
    _mediaPicker.allowsPickingMultipleItems = YES;
}

- (void)setupDependencies {
    self.dataService = [[SessionDataService alloc]initWithDefaults:NSUserDefaults.standardUserDefaults];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataService;
    playerVC = [PlayerViewController controllerWithStoryboard];
    playerVC.delegate = self;
}

- (void)setupRefreshControl {
    self.tableView.refreshControl = [UIRefreshControl new];
    self.tableView.refreshControl.tintColor = [UIColor grayColor];
    self.tableView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

#pragma mark TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    playerVC.playerVM.session = [self.dataService.savedSessions objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:playerVC animated:YES];
}

#pragma mark Player Delegates

- (void)didSetNewSession:(Session *)session {
    [self.dataService addSession:session];
}

#pragma mark Actions

- (IBAction)createNewSession:(id)sender {
    //TODO: user picks 2(limit) songs
    [self presentViewController:_mediaPicker animated:YES completion:nil];
}

- (IBAction)saveAllSessions:(id)sender {
    [self.dataService saveData];
}

#pragma mark MPMediaPickerController Delgates

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    if (mediaItemCollection.items.firstObject) {
        [playerVC.playerVM setAudioPlayer:PlayerOne media: (MPMediaItem *)mediaItemCollection.items.firstObject];
    }
    if (mediaItemCollection.items[1]) {
        [playerVC.playerVM setAudioPlayer:PlayerTwo media: (MPMediaItem *)mediaItemCollection.items[1]];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController pushViewController:playerVC animated:YES];
    }];
}

@end
