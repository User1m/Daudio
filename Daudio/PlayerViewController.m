//
//  PlayerViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/23/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "UIColor+Utils.h"
#import "PlayerViewController.h"
#import "Session.h"
@import AVFoundation;
@import MediaPlayer;

typedef enum : NSUInteger {
    firstChoice,
    secondChoice,
    zeroChoice
} SongChoice;

@interface PlayerViewController () <MPMediaPickerControllerDelegate, UIGestureRecognizerDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *dragBar;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton1;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton2;

@end

@implementation PlayerViewController {
    AVAudioPlayer *_audioPlayer1, *_audioPlayer2;
    MPMediaPickerController *_mediaPicker;
    SongChoice _selectedAudioChoice;
    BOOL _isHorizontalPan, _isPlaying, _isNewSession;
    NSString *_song1Title, *_song2Title;
}

- (void)viewDidLoad {
    _isNewSession = (self.session != nil);
    _song1Title = @"Choose first song";
    _song2Title = @"Choose second song";
    [super viewDidLoad];
    [self setupNavBar];
    [self setupDragGesture];
    [self setupPicker];
    [self setupViewState];
}

- (void)setupNavBar {
    //    self.navigationController.navigationItem.rightBarButtonItem
}

- (void)setupViewState {
    self.chooseButton1.backgroundColor = [UIColor funRed];
    self.chooseButton2.backgroundColor = [UIColor funYellow];
    [self.chooseButton1 setTitle:_song1Title forState:UIControlStateNormal];
    [self.chooseButton2 setTitle:_song2Title forState:UIControlStateNormal];
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
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint displacement = (_isHorizontalPan) ? CGPointMake(translation.x, 0) : CGPointMake(0, translation.y);
    
    self.dragBar.transform = CGAffineTransformMakeTranslation(displacement.x, displacement.y);
    
    [self updateView];
    [self updatePlayers];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self isCloseToCenter:self.dragBar.frame]) {
            self.dragBar.transform = CGAffineTransformMakeTranslation(0,0);
            self.dragBar.center = self.dragBar.center;
            self.chooseButton1.hidden = NO;
            self.chooseButton2.hidden = NO;
            [self stopPlayers];
        }
    }
}

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
        [self.chooseButton1 setTitle:@"" forState:UIControlStateNormal];
        [self.chooseButton2 setTitle:_song1Title forState:UIControlStateNormal];
        self.chooseButton1.backgroundColor = [UIColor funRed];
        self.chooseButton2.backgroundColor = [UIColor funRed];
    } else if (self.dragBar.frame.origin.x > self.view.bounds.size.width/2) {
        [self.chooseButton1 setTitle:_song2Title forState:UIControlStateNormal];
        [self.chooseButton2 setTitle:@"" forState:UIControlStateNormal];
        self.chooseButton1.backgroundColor = [UIColor funYellow];
        self.chooseButton2.backgroundColor = [UIColor funYellow];
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
    [self alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", [[player.url absoluteString] lastPathComponent]] actionHandler:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.session = nil;
    [super viewDidDisappear:animated];
}

#pragma mark MPMediaPickerController Delgates
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    MPMediaItem *media = (MPMediaItem *)mediaItemCollection.items.firstObject;
    if (_selectedAudioChoice == firstChoice) {
        _song1Title = media.title;
        _session.firstTrack = media;
        [self.chooseButton1 setTitle:_song1Title forState:UIControlStateNormal];
        _audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
        _audioPlayer1.delegate = self;
    } else if (_selectedAudioChoice == secondChoice) {
        _song2Title = media.title;
        _session.secondTrack = media;
        [self.chooseButton2 setTitle:_song2Title forState:UIControlStateNormal];
        _audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
        _audioPlayer2.delegate = self;
    }
    if (_audioPlayer1 && _audioPlayer2) {
        if (_isNewSession){
            _isNewSession = NO;
            [self.delegate didSetNewSession:_session];
        }
        [self startPlayers];
        //        [self presentViewController:[self alertWithTitle:@"Start" message:@"Slide bar to start referencing" actionHandler:nil] animated:YES completion:nil];
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

- (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message actionHandler:(nullable void(^)())handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:ok];
    return alert;
}


@end
