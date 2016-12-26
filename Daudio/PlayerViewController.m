//
//  PlayerViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/23/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

@import AVFoundation;
@import MediaPlayer;
#import "UIColor+Utils.h"
#import "PlayerViewController.h"
#import "Session.h"
#import "UIAlertController+Utils.h"
#import "NSString+Utils.h"

typedef NS_ENUM(NSUInteger, SongChoice) {
    firstChoice,
    secondChoice,
    zeroChoice
};

static NSString *choiceOne = @"Choose first song";
static NSString *choiceTwo = @"Choose second song";

@interface PlayerViewController () <MPMediaPickerControllerDelegate, UIGestureRecognizerDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *dragBar;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton1;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton2;
@property (weak, nonatomic) IBOutlet UIView *firstTrackBckground;
@property (weak, nonatomic) IBOutlet UIView *secondTrackBackground;

@end

@implementation PlayerViewController {
    AVAudioPlayer *_audioPlayer1, *_audioPlayer2;
    MPMediaPickerController *_mediaPicker;
    SongChoice _selectedAudioChoice;
    BOOL _isHorizontalPan, _isPlaying, _isNewSession;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDragGesture];
    [self setupPicker];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.session == nil) {
        _isNewSession = YES;
        self.session = [Session new];
    }
    [self setupViewState];
}

#pragma mark Setups

- (void)setupViewState {
    NSString *song1Title = ([self.session.firstTrack.title isNotEmpty]) ?  self.session.firstTrack.title : choiceOne;
    NSString *song2Title = ([self.session.secondTrack.title isNotEmpty]) ? self.session.secondTrack.title : choiceTwo;
    self.firstTrackBckground.backgroundColor = [UIColor funRed];
    self.secondTrackBackground.backgroundColor = [UIColor funYellow];
    [self.chooseButton1 setTitle:song1Title forState:UIControlStateNormal];
    [self.chooseButton2 setTitle:song2Title forState:UIControlStateNormal];
}

- (void)setupPicker {
    _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    _mediaPicker.delegate = self;
    _mediaPicker.allowsPickingMultipleItems = NO;
}

- (void)setupDragGesture {
    UIPanGestureRecognizer *drag = [UIPanGestureRecognizer new];
    [drag addTarget:self action:@selector(didDragBar:)];
    drag.delegate = self;
    [self.dragBar addGestureRecognizer:drag];
}

- (void)didDragBar:(UIPanGestureRecognizer *)gesture {
    if (_isHorizontalPan && _audioPlayer1 && _audioPlayer2) {
        CGPoint translation = [gesture translationInView:self.view];
//        CGPoint displacement = (_isHorizontalPan) ? CGPointMake(translation.x, 0) : CGPointMake(0, translation.y);
        
        self.dragBar.transform = CGAffineTransformMakeTranslation(translation.x, 0);
        
        [self updateView];
        [self updatePlayers];
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            if ([self isCloseToCenter:self.dragBar.frame]) {
                [self resetView];
                [self stopPlayers];
            }
        }
    }
}

- (void)resetView {
    self.dragBar.transform = CGAffineTransformMakeTranslation(0,0);
    self.dragBar.center = self.dragBar.center;
    [self setupViewState];
}

#pragma mark Player

- (void)startPlayers {
    _isPlaying = YES;
    [_audioPlayer1 play];
    _audioPlayer1.volume = 1.0;
    [_audioPlayer2 play];
    _audioPlayer2.volume = 0.0;
}

- (void)stopPlayers {
    _isPlaying = NO;
    [_audioPlayer1 stop];
    [_audioPlayer2 stop];
    [self setupViewState];
}

- (BOOL)isCloseToCenter:(CGRect)rect {
    return rect.origin.x >= (self.view.bounds.size.width/2)-50 && rect.origin.x <= (self.view.bounds.size.width/2)+50;
}

- (void)updateView {
    if (self.dragBar.frame.origin.x < self.view.bounds.size.width/2) {
        NSString *song1Title = ([self.session.firstTrack.title isNotEmpty]) ?  self.session.firstTrack.title : choiceOne;
        [self.chooseButton1 setTitle:@"" forState:UIControlStateNormal];
        [self.chooseButton2 setTitle:song1Title forState:UIControlStateNormal];
        self.firstTrackBckground.backgroundColor = [UIColor funRed];
        self.secondTrackBackground.backgroundColor = [UIColor funRed];
    } else if (self.dragBar.frame.origin.x > self.view.bounds.size.width/2) {
        NSString *song2Title = ([self.session.secondTrack.title isNotEmpty]) ? self.session.secondTrack.title : choiceTwo;
        [self.chooseButton1 setTitle:song2Title forState:UIControlStateNormal];
        [self.chooseButton2 setTitle:@"" forState:UIControlStateNormal];
        self.firstTrackBckground.backgroundColor = [UIColor funYellow];
        self.secondTrackBackground.backgroundColor = [UIColor funYellow];
    }
}

- (void)updatePlayers {
    if (!_isPlaying) {
        [self startPlayers];
    }
    if (self.dragBar.frame.origin.x < self.view.bounds.size.width/2) {
        _audioPlayer1.volume = 1.0;
        _audioPlayer2.volume = 0.0;
    } else if (self.dragBar.frame.origin.x > self.view.bounds.size.width/2) {
        _audioPlayer1.volume = 0.0;
        _audioPlayer2.volume = 1.0;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    _isHorizontalPan = fabs(translation.x) > fabs(translation.y);
    return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([player isEqual:_audioPlayer1]) {
        [self presentViewController:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.firstTrack.title] actionHandler:nil] animated:YES completion:nil];
    } else {
        [self presentViewController:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.secondTrack.title] actionHandler:nil] animated:YES completion:nil];
    }
    if (!_audioPlayer1.isPlaying && !_audioPlayer2.isPlaying) {
        [self resetView];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent){
        [self clearSession];
    }
}

- (void)clearSession {
    self.session = nil;
    _audioPlayer1 = nil;
    _audioPlayer2 = nil;
    _isNewSession = _isPlaying = NO;
}

#pragma mark MPMediaPickerController Delgates

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    MPMediaItem *media = (MPMediaItem *)mediaItemCollection.items.firstObject;
    
    if (_selectedAudioChoice == firstChoice) {
        self.session.firstTrack = media;
        [self.chooseButton1 setTitle:media.title forState:UIControlStateNormal];
        _audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
        _audioPlayer1.delegate = self;
    } else if (_selectedAudioChoice == secondChoice) {
        self.session.secondTrack = media;
        [self.chooseButton2 setTitle:media.title forState:UIControlStateNormal];
        _audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
        _audioPlayer2.delegate = self;
    }
    
    if (_audioPlayer1 && _audioPlayer2) {
        if (_isNewSession) {
            if ([self.delegate respondsToSelector:@selector(didSetNewSession:)]) {
                [self.delegate didSetNewSession:self.session];
            }
            _isNewSession = NO;
        }
        [self startPlayers];
    }
    _selectedAudioChoice = zeroChoice;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Actions

- (IBAction)selectFirstSong:(id)sender {
    _selectedAudioChoice = firstChoice;
    [self presentViewController:_mediaPicker animated:YES completion:nil];
}

- (IBAction)selectSecondSong:(id)sender {
    _selectedAudioChoice = secondChoice;
    [self presentViewController:_mediaPicker animated:YES completion:nil];
}

@end
