//
//  PlayerViewModel.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

@import AVFoundation;
@import MediaPlayer;
#import "PlayerViewModel.h"
#import "PlayerCollectionViewCell.h"
#import <Objection/Objection.h>
#import "UIAlertController+Utils.h"

static NSString *musicImage = @"music";
static NSString *cellID = @"collectionCell";
static NSString *session = @"session";
static NSString *delegate = @"delegate";
static NSString *audioPlayer1 = @"audioPlayer1";
static NSString *audioPlayer2 = @"audioPlayer2";
const NSUInteger skipTime = 5;

@interface PlayerViewModel() <AVAudioPlayerDelegate>

@property (nonatomic, strong, readwrite) AVAudioPlayer *audioPlayer1;
@property (nonatomic, strong, readwrite) AVAudioPlayer *audioPlayer2;

@end

@implementation PlayerViewModel

objection_requires(session)

- (instancetype)init {
    self = [super init];
    if (self) {
        [JSObjection.defaultInjector injectDependencies:self];
    }
    return self;
}

- (instancetype)initWithSession:(Session *)session {
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

#pragma mark Player Controls

- (void)startPlayers:(TrackNumber)track {
    [self startPlayer:PlayerOne];
    [self startPlayer:PlayerTwo];
    [self switchToTrack:track];
}

- (void)stopPlayers {
    [self stopPlayer:PlayerOne];
    [self stopPlayer:PlayerTwo];
}

- (void)pausePlayers {
    [self pausePlayer:PlayerOne];
    [self pausePlayer:PlayerTwo];
}

- (void)resetPlayers {
    [self resetPlayer:PlayerOne];
    [self resetPlayer:PlayerTwo];
}

- (void)rewindPlayers {
    [self rewindPlayer:PlayerOne];
    [self rewindPlayer:PlayerTwo];
}

- (void)fastFwdPlayers {
    [self fastFwdPlayer:PlayerOne];
    [self fastFwdPlayer:PlayerTwo];
}

- (void)startPlayer:(AudioPlayers)player {
    (player == PlayerOne) ? [self.audioPlayer1 play] : [self.audioPlayer2 play];
}

- (void)stopPlayer:(AudioPlayers)player {
    (player == PlayerOne) ? [self.audioPlayer1 stop] : [self.audioPlayer2 stop];
}

- (void)pausePlayer:(AudioPlayers)player {
    (player == PlayerOne) ? [self.audioPlayer1 pause] : [self.audioPlayer2 pause];
}

- (void)resetPlayer:(AudioPlayers)player {
    [self setAudioPlayer:player media:(player == PlayerOne) ? self.session.firstTrack : self.session.secondTrack];
}

- (void)fastFwdPlayer:(AudioPlayers)player {
    (player == PlayerOne) ?
    [self.audioPlayer1 playAtTime:self.audioPlayer1.currentTime + skipTime] :
    [self.audioPlayer2 playAtTime:self.audioPlayer1.currentTime + skipTime];
}

- (void)rewindPlayer:(AudioPlayers)player {
    (player == PlayerOne) ?
    [self.audioPlayer1 playAtTime:self.audioPlayer1.currentTime - skipTime] :
    [self.audioPlayer2 playAtTime:self.audioPlayer1.currentTime - skipTime];
}

- (BOOL)sessionIsNew {
    return self.session.isNewSession;
}

- (void)switchToTrack:(TrackNumber)track {
    if (track == TrackOne) {
        self.audioPlayer1.volume = 1.0;
        self.audioPlayer2.volume = 0.0;
    } else {
        self.audioPlayer2.volume = 1.0;
        self.audioPlayer1.volume = 0.0;
    }
}

- (BOOL)playersAreSet {
    return self.audioPlayer1 && self.audioPlayer2;
}

- (void)setSession:(Session *)session {
    _session = session;
    if (session.firstTrack && session.secondTrack) {
        [self setAudioPlayer:PlayerOne media:session.firstTrack];
        [self setAudioPlayer:PlayerTwo media:session.secondTrack];
    }
}

- (void)setAudioPlayer:(AudioPlayers)player media:(MPMediaItem *)media {
    switch (player) {
        case PlayerOne:
            self.audioPlayer1 = nil;
            self.audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
            self.audioPlayer1.volume = 1.0;
            self.audioPlayer1.delegate = self;
            break;
        case PlayerTwo:
            self.audioPlayer2 = nil;
            self.audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
            self.audioPlayer2.volume = 1.0;
            self.audioPlayer2.delegate = self;
            break;
    }
}

- (NSString *)titleForTrack:(TrackNumber)track {
    return (track == TrackOne) ? self.session.firstTrack.title : self.session.secondTrack.title;
}

- (NSString *)artistForTrack:(TrackNumber)track {
    return (track == TrackOne) ? self.session.firstTrack.artist : self.session.secondTrack.artist;
}

#pragma mark AVAudioPlayer Delegates

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([player isEqual:self.audioPlayer1]) {
        [self.delegate playerDidFinishPlaying:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.firstTrack.title] actionHandler:nil]];
    } else {
        [self.delegate playerDidFinishPlaying:[UIAlertController alertWithTitle:@"Song Finished" message:[NSString stringWithFormat:@"%@ has finished playing", self.session.secondTrack.title] actionHandler:nil]];
    }
}

#pragma mark UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UIImage *image = (indexPath.row == 0) ? [self.session getArt:TrackOne size:cell.bounds.size] :  [self.session getArt:TrackTwo size:cell.bounds.size];
    if (!image) {
        image = [UIImage imageNamed:musicImage];
    }
    cell.playerImageView.image = image;
    return cell;
}

#pragma mark UIScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.delegate collectionViewDidSwitch];
}

@end
