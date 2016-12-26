//
//  PlayerViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/23/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//
@import MediaPlayer;
#import "UIColor+Utils.h"
#import "PlayerViewController.h"
#import "Session.h"
#import "PlayerView.h"
#import "NSString+Utils.h"
#import <Objection/Objection.h>
#import <AVFoundation/AVAudioPlayer.h>

typedef NS_ENUM(NSUInteger, SongChoice) {
    firstChoice,
    secondChoice,
    zeroChoice
};

static NSString *choiceOne = @"Choose first song";
static NSString *choiceTwo = @"Choose second song";

@interface PlayerViewController () <PlayerViewDelegate, MPMediaPickerControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chooseButton1;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton2;
@property (weak, nonatomic) IBOutlet UIView *firstTrackBckground;
@property (weak, nonatomic) IBOutlet UIView *secondTrackBackground;

@end


@implementation PlayerViewController {
    MPMediaPickerController *_mediaPicker;
    SongChoice _selectedAudioChoice;
    BOOL _isHorizontalPan;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player.delegate = self;
    [self setupDragGesture];
    [self setupPicker];
    [self setupInitialViewState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark Setups

- (void)setupInitialViewState {
    NSString *song1Title = ([self.player.session.firstTrack.title isNotEmpty]) ?  self.player.session.firstTrack.title : choiceOne;
    NSString *song2Title = ([self.player.session.secondTrack.title isNotEmpty]) ? self.player.session.secondTrack.title : choiceTwo;
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
    if (_isHorizontalPan && [self.player playersAreSet]) {
        CGPoint translation = [gesture translationInView:self.view];
        self.dragBar.transform = CGAffineTransformMakeTranslation(translation.x, 0);
        
        [self updateView];
        [self updatePlayers];
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            if ([self isCloseToCenter:self.dragBar.frame]) {
                [self resetView];
                [self.player stopPlayers];
                [self setupInitialViewState];
            }
        }
    }
}

- (void)resetView {
    self.dragBar.transform = CGAffineTransformMakeTranslation(0,0);
    self.dragBar.center = self.dragBar.center;
    [self setupInitialViewState];
}

- (BOOL)isCloseToCenter:(CGRect)rect {
    return rect.origin.x >= (self.view.bounds.size.width/2)-50 && rect.origin.x <= (self.view.bounds.size.width/2)+50;
}

- (void)updateView {
    if (self.dragBar.frame.origin.x < self.view.bounds.size.width/2) {
        NSString *song1Title = ([self.player.session.firstTrack.title isNotEmpty]) ?  self.player.session.firstTrack.title : choiceOne;
        [self.chooseButton1 setTitle:@"" forState:UIControlStateNormal];
        [self.chooseButton2 setTitle:song1Title forState:UIControlStateNormal];
        self.firstTrackBckground.backgroundColor = [UIColor funRed];
        self.secondTrackBackground.backgroundColor = [UIColor funRed];
    } else if (self.dragBar.frame.origin.x > self.view.bounds.size.width/2) {
        NSString *song2Title = ([self.player.session.secondTrack.title isNotEmpty]) ? self.player.session.secondTrack.title : choiceTwo;
        [self.chooseButton1 setTitle:song2Title forState:UIControlStateNormal];
        [self.chooseButton2 setTitle:@"" forState:UIControlStateNormal];
        self.firstTrackBckground.backgroundColor = [UIColor funYellow];
        self.secondTrackBackground.backgroundColor = [UIColor funYellow];
    }
}

- (void)updatePlayers {
    if (self.dragBar.frame.origin.x < self.view.bounds.size.width/2) {
        [self.player player1Active];
    } else if (self.dragBar.frame.origin.x > self.view.bounds.size.width/2) {
        [self.player player2Active];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    _isHorizontalPan = fabs(translation.x) > fabs(translation.y);
    return YES;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent){
        [self.player clearPlayerSession];
    }
}

#pragma mark PlayerView Delegates
- (BOOL)playersDidFinishPlaying {
    [self resetView];
    return YES;
}

- (void)playerDidFinishPlaying:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark MPMediaPickerController Delgates

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    MPMediaItem *media = (MPMediaItem *)mediaItemCollection.items.firstObject;
    
    if (_selectedAudioChoice == firstChoice) {
        self.player.session.firstTrack = media;
        [self.chooseButton1 setTitle:media.title forState:UIControlStateNormal];
        [self.player setAudioPlayer1: [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil]];
    } else if (_selectedAudioChoice == secondChoice) {
        self.player.session.secondTrack = media;
        [self.chooseButton2 setTitle:media.title forState:UIControlStateNormal];
        [self.player setAudioPlayer2:[[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil]];
    }
    
    if ([self.player playersAreSet] && self.player.isNewSession) {
        if ([self.delegate respondsToSelector:@selector(didSetNewSession:)]) {
            [self.delegate didSetNewSession:self.player.session];
        }
        [self.player startPlayers];
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
