//
//  PlayerViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/23/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//
@import AVFoundation;
@import UIKit;
#import "UIColor+Utils.h"
#import "PlayerViewController.h"
#import "Session.h"
#import "NSString+Utils.h"
#import <Objection/Objection.h>
#import <ChameleonFramework/Chameleon.h>

static NSString *choiceOne = @"Choose first song";
static NSString *choiceTwo = @"Choose second song";
static NSString *playerVM = @"playerVM";
static NSString *currentTrack = @"This";
static NSString *allTracks = @"All  ";

@interface PlayerViewController () <PlayerViewModelDelegate, UIGestureRecognizerDelegate>

//controls
@property (strong, nonatomic) IBOutlet UIToolbar *playerControlBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rewindButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fastFoward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *appTypeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseButton;

//view
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackArtistLabel;

@end


@implementation PlayerViewController {
    AppType _currentType;
    TrackNumber _currentTrack;
}

objection_requires(playerVM)

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerVM.delegate = self;
    self.collectionView.dataSource = self.playerVM;
    self.collectionView.delegate = self.playerVM;
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleRadial withFrame:self.view.bounds andColors:@[[UIColor flatBlueColor], [UIColor flatGreenColor]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateView];
    [self.playerVM startPlayers:_currentTrack];
}

#pragma mark Setups

- (void)updateView {
    self.trackTitleLabel.text = [self.playerVM titleForTrack:_currentTrack];
    self.trackArtistLabel.text = [self.playerVM artistForTrack:_currentTrack];
}

#pragma mark PlayerViewModel Delegates

- (void)playerDidFinishPlaying:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Actions
- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleAppTypeSwitch:(id)sender {
    _currentType = (_currentType == AllTracks) ? CurrentTrack : AllTracks;
    self.appTypeButton.title = (_currentType == AllTracks) ? allTracks : currentTrack;
}

- (IBAction)handleRewindButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM rewindPlayers];
    } else {
        [self.playerVM rewindPlayer:(NSUInteger)_currentTrack];
    }
}
- (IBAction)handlePauseButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM pausePlayers];
    } else {
        [self.playerVM pausePlayer:(NSUInteger)_currentTrack];
    }
}

- (IBAction)handlePlayButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM startPlayers:_currentTrack];
    } else {
        [self.playerVM startPlayer:(NSUInteger)_currentTrack];
    }
}

- (IBAction)handleFastForwardButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM fastFwdPlayers];
    } else {
        [self.playerVM fastFwdPlayer:(NSUInteger)_currentTrack];
    }
}

- (IBAction)handleResetButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM resetPlayers];
    } else {
        [self.playerVM resetPlayer:(NSUInteger)_currentTrack];
    }
}

- (void)collectionViewDidSwitch { 
    _currentTrack = (_currentTrack == TrackOne) ? TrackTwo : TrackOne;
    [self updateView];
    [self.playerVM switchToTrack:_currentTrack];
}

@end
