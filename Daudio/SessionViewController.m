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
#import <ChameleonFramework/Chameleon.h>

static NSString *dataService = @"dataService";

@class PlayerViewModel;

@interface SessionViewController () <MPMediaPickerControllerDelegate, UITableViewDelegate, PlayerViewControllerDelegate>

@end

@implementation SessionViewController {
    MPMediaPickerController *_mediaPicker;
    PlayerViewController *playerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDependencies];
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithRandomColorInArray:@[[UIColor flatBlueColor], [UIColor flatRedColor], [UIColor flatPlumColor]]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:self.navigationController.navigationBar.barTintColor isFlat:YES];
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
    self.dataService = [[SessionDataService alloc] initWithDefaults:NSUserDefaults.standardUserDefaults];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataService;
    playerVC = [PlayerViewController controllerWithStoryboard];
    playerVC.delegate = self;
    playerVC.playerVM = [JSObjection.defaultInjector getObject:[PlayerViewModel class]];
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
    [self.navigationController presentViewController:playerVC animated:YES completion:nil];
}

#pragma mark Actions

- (IBAction)createNewSession:(id)sender {
    [self setupPicker];
    [self presentViewController:_mediaPicker animated:YES completion:nil];
    //    [self.navigationController presentViewController:playerVC animated:YES completion:nil];
}

- (IBAction)saveAllSessions:(id)sender {
    [self.dataService saveData];
}

#pragma mark MPMediaPickerController Delgates

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    if (mediaItemCollection.items.count > 1 && mediaItemCollection.items.count < 3) {
        Session *session = [[Session alloc]initWithTrack:mediaItemCollection.items.firstObject track:mediaItemCollection.items[1]];
        playerVC.playerVM.session = session;
        [self.dataService addSession:session];
        _mediaPicker = nil;
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController presentViewController:playerVC animated:YES completion:^{
                [self.tableView reloadData];
            }];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:[UIAlertController alertWithTitle:@"Info" message:@"Please select only 2 songs" actionHandler:nil] animated:YES completion:nil];
    }];
}

@end
