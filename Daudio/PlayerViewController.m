//
//  PlayerViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/23/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//
@import AVFoundation;
#import "UIColor+Utils.h"
#import "PlayerViewController.h"
#import "Session.h"
#import "NSString+Utils.h"
#import <Objection/Objection.h>
#import <ChameleonFramework/Chameleon.h>

static NSString *choiceOne = @"Choose first song";
static NSString *choiceTwo = @"Choose second song";
static NSString *playerVM = @"playerVM";

@interface PlayerViewController () <PlayerViewModelDelegate, UIGestureRecognizerDelegate>

//controls
@property (strong, nonatomic) IBOutlet UIToolbar *playerControlBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rewindButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fastFoward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButton;

//view
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackArtistLabel;

@end


@implementation PlayerViewController {
    BOOL _isHorizontalPan;
}

objection_requires(playerVM)

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [JSObjection.defaultInjector injectDependencies:self];
    self.playerVM.delegate = self;
    self.collectionView.dataSource = self.playerVM;
    self.collectionView.delegate = self.playerVM;
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark Setups

- (void)setupView {
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleRadial withFrame:self.view.bounds andColors:@[[UIColor flatBlueColor], [UIColor flatGreenColor]]];

}

- (BOOL)isCloseToCenter:(CGRect)rect {
    return rect.origin.x >= (self.view.bounds.size.width/2)-50 && rect.origin.x <= (self.view.bounds.size.width/2)+50;
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [self.playerVM clearPlayerSession];
    }
    if (!self.playerVM.session) {
        self.playerVM.session = [JSObjection.defaultInjector getObject:[Session class]];
    }
    [self setupView];
}

#pragma mark PlayerView Delegates
- (BOOL)playersDidFinishPlaying {
    [self setupView];
    return YES;
}

- (void)playerDidFinishPlaying:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

@end
