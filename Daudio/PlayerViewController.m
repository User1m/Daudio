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
#import "UIAlertController+Utils.h"
#import "NoteViewController.h"
#import "UIViewController+Storyboard.h"

static NSString *choiceOne = @"Choose first song";
static NSString *choiceTwo = @"Choose second song";
static NSString *playerVM = @"playerVM";
static NSString *currentTrack = @"Local  ";
static NSString *allTracks = @"Global";

@interface PlayerViewController () <PlayerViewModelDelegate, UIGestureRecognizerDelegate, NoteViewControllerDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel *trackTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@property (weak, nonatomic) IBOutlet UISlider *trackTimeSlider;

@end


@implementation PlayerViewController {
    AppType _currentType;
    TrackNumber _currentTrack;
    NSTimer *_timer;
    NoteViewController *_noteVC;
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
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSliderView) userInfo:nil repeats:YES];
    [self updateAppTypeLabel];
    [self updateViewColors];
    [self updateViewLabels];
    [self.collectionView reloadData];
}

- (void)updateViewColors {
    self.view.backgroundColor = [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleLight];
    self.trackArtistLabel.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn: self.view.backgroundColor isFlat:YES];
    self.trackTitleLabel.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn: self.view.backgroundColor isFlat:YES];
    self.trackTimeLabel.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn: self.view.backgroundColor isFlat:YES];
    [self.doneButton setTitleColor: [UIColor colorWithContrastingBlackOrWhiteColorOn: self.view.backgroundColor isFlat:YES] forState:UIControlStateNormal];
    self.trackTimeSlider.tintColor = [UIColor colorWithRandomFlatColorExcludingColorsInArray:@[self.view.backgroundColor]];
}

- (void)updateViewLabels {
    self.trackTitleLabel.text = [self.playerVM titleForTrack:_currentTrack];
    self.trackArtistLabel.text = [self.playerVM artistForTrack:_currentTrack];
}

- (void)updateSliderView {
    self.trackTimeSlider.maximumValue = (float)[self.playerVM durationForTrack:_currentTrack];
    self.trackTimeSlider.value = (float)[self.playerVM currentTimeForTrack:_currentTrack];
    self.trackTimeLabel.text = [self formatTimeToString:[self.playerVM currentTimeForTrack:_currentTrack]];
}

#pragma mark PlayerViewModel Delegates

- (void)playerDidFinishPlaying:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark NoteVC Delegates

- (void)didRequestAnnotationUpdate {
    _noteVC.noteAnnotation = [self noteAnnotationFormat];
}

- (void)didFinishNote {
    _noteVC = nil;
}

#pragma mark Actions

- (IBAction)doneButton:(id)sender {
    [self.playerVM clearPlayerSession];
    [self resetView];
    [_timer invalidate];
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

- (IBAction)handleSliderMoved:(id)sender {
    [self.playerVM updateCurrentTimeForTrack:_currentTrack time:self.trackTimeSlider.value];
    [self updateSliderView];
}

- (IBAction)handleNoteButton:(id)sender {
    _noteVC = [NoteViewController controllerWithStoryboard];
    _noteVC.delegate = self;
    _noteVC.noteKey = [self.playerVM noteKeyForTrack:_currentTrack];
    _noteVC.noteAnnotation = [self noteAnnotationFormat];
    [self presentViewController:_noteVC animated:YES completion:nil];
}

#pragma mark Helpers

- (void)resetView {
    self.trackTimeSlider.value = 0.0;
    self.trackTimeLabel.text = @"00:00";
}

- (void)updateAppTypeLabel {
    self.appTypeButton.title = (_currentType == AllTracks) ? allTracks : currentTrack;
}

- (NSString *)formatTimeToString:(NSTimeInterval)time {
    NSInteger ti = (NSInteger)time;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

- (NSString *)noteAnnotationFormat {
    return [NSString stringWithFormat:@"---------- %@ vs %@ ----------\n", [self formatTimeToString:[self.playerVM currentTimeForTrack:_currentTrack]],[self.playerVM titleForTrack:(_currentTrack == TrackOne) ? TrackTwo : TrackOne]];
}

- (void)collectionViewDidSwitch {
    //https://stackoverflow.com/questions/13176333/ios6-uicollectionview-and-uipagecontrol-how-to-get-visible-cell
    CGFloat pageWidth = self.collectionView.frame.size.width;
    CGFloat idx = ceilf(self.collectionView.contentOffset.x / pageWidth);
    _currentTrack = (NSUInteger)idx;
    self.playerVM.currentTrack = _currentTrack;
    [self updateViewLabels];
}

@end
