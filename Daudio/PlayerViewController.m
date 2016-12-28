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
static NSString *currentTrack = @"Local  ";
static NSString *allTracks = @"Global";

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
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

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
    //    [UIColor colorWithGradientStyle:UIGradientStyleRadial withFrame:self.view.bounds andColors:@[[UIColor flatBlueColor], [UIColor flatGreenColor]]
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentType = AllTracks;
    [self updateAppTypeLabel];
    [self updateViewColors];
    [self updateViewLabels];
    [self.playerVM startPlayers:_currentTrack];
    [self.collectionView reloadData];
}

- (void)updateViewColors {
    self.view.backgroundColor = [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight];
    self.trackArtistLabel.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn: self.view.backgroundColor isFlat:YES];
    self.trackTitleLabel.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn: self.view.backgroundColor isFlat:YES];
    [self.doneButton setTitleColor:[UIColor colorWithContrastingBlackOrWhiteColorOn: self.view.backgroundColor isFlat:YES] forState:UIControlStateNormal];
}

- (void)updateViewLabels {
    self.trackTitleLabel.text = [self.playerVM titleForTrack:_currentTrack];
    self.trackArtistLabel.text = [self.playerVM artistForTrack:_currentTrack];
}

#pragma mark PlayerViewModel Delegates

- (void)playerDidFinishPlaying:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Actions
- (IBAction)doneButton:(id)sender {
    [self.playerVM clearPlayerSession];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleAppTypeSwitch:(id)sender {
    _currentType = (_currentType == AllTracks) ? CurrentTrack : AllTracks;
    [self updateAppTypeLabel];
}

- (IBAction)handleRewindButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM rewindPlayers];
    } else {
        [self.playerVM rewindPlayerForTrack:_currentTrack];
    }
}
- (IBAction)handlePauseButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM pausePlayers];
    } else {
        [self.playerVM pausePlayerForTrack:_currentTrack];
    }
}

- (IBAction)handlePlayButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM startPlayers:_currentTrack];
    } else {
        [self.playerVM startPlayerForTrack:_currentTrack];
    }
}

- (IBAction)handleFastForwardButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM fastFwdPlayers];
    } else {
        [self.playerVM fastFwdPlayerForTrack:_currentTrack];
    }
}

- (IBAction)handleResetButton:(id)sender {
    if (_currentType == AllTracks) {
        [self.playerVM resetPlayersWithTrack: _currentTrack];
    } else {
        [self.playerVM resetPlayerForTrack:_currentTrack];
    }
}

- (void)updateAppTypeLabel {
    self.appTypeButton.title = (_currentType == AllTracks) ? allTracks : currentTrack;
}

- (void)collectionViewDidSwitch {
    _currentTrack = (_currentTrack == TrackOne) ? TrackTwo : TrackOne;
    [self updateViewLabels];
    [self.playerVM setVolumeToTrack:_currentTrack];
}

@end
