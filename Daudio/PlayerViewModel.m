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
        [self configureAVAudioSession];
    }
    return self;
}

- (instancetype)initWithSession:(Session *)session {
    self = [self init];
    if (self) {
        self.session = session;
    }
    return self;
}

#pragma mark Player Controls

- (void)startPlayers:(TrackNumber)track {
    [self startPlayerForTrack:TrackOne];
    [self startPlayerForTrack:TrackTwo];
    [self setVolumeToTrack:track];
}

- (void)stopPlayers {
    [self stopPlayerForTrack:TrackOne];
    [self stopPlayerForTrack:TrackTwo];
}

- (void)pausePlayers {
    [self pausePlayerForTrack:TrackOne];
    [self pausePlayerForTrack:TrackTwo];
}

- (void)resetPlayersWithTrack:(TrackNumber)track {
    [self resetPlayerForTrack:TrackOne];
    [self resetPlayerForTrack:TrackTwo];
    [self startPlayers:track];
}

- (void)rewindPlayers {
    [self rewindPlayerForTrack:TrackOne];
    [self rewindPlayerForTrack:TrackTwo];
}

- (void)fastFwdPlayers {
    [self fastFwdPlayerForTrack:TrackOne];
    [self fastFwdPlayerForTrack:TrackTwo];
}

- (void)startPlayerForTrack:(TrackNumber)track {
    (track == TrackOne) ? [self.audioPlayer1 play] : [self.audioPlayer2 play];
    [self setVolumeToTrack:track];
}

- (void)stopPlayerForTrack:(TrackNumber)track {
    if ([self isPlaying:track]) {
        (track == TrackOne) ? [self.audioPlayer1 stop] : [self.audioPlayer2 stop];
    }
}

- (void)pausePlayerForTrack:(TrackNumber)track {
    if ([self isPlaying:track]) {
        (track == TrackOne) ? [self.audioPlayer1 pause] : [self.audioPlayer2 pause];
    }
}

- (void)resetPlayerForTrack:(TrackNumber)track {
    [self stopPlayerForTrack:track];
    if (track == TrackOne) {
        self.audioPlayer1.currentTime = 0.0;
    } else {
        self.audioPlayer2.currentTime = 0.0;
    }
    [self startPlayerForTrack:track];
}

- (void)fastFwdPlayerForTrack:(TrackNumber)track {
    if ([self isPlaying:track]) {
        if (track == TrackOne) {
            NSTimeInterval time = self.audioPlayer1.currentTime + skipTime;
            self.audioPlayer1.currentTime = (time >= self.audioPlayer1.duration) ? self.audioPlayer1.duration : time;
        } else {
            NSTimeInterval time = self.audioPlayer2.currentTime + skipTime;
            self.audioPlayer2.currentTime = (time >= self.audioPlayer2.duration) ? self.audioPlayer2.duration : time;
        }
    }
}

- (void)rewindPlayerForTrack:(TrackNumber)track {
    if ([self isPlaying:track]) {
        if (track == TrackOne) {
            NSTimeInterval time = self.audioPlayer1.currentTime - skipTime;
            self.audioPlayer1.currentTime = (time <= 0.0) ? 0.0 : time;
        } else {
            NSTimeInterval time = self.audioPlayer2.currentTime - skipTime;
            self.audioPlayer2.currentTime =  (time <= 0.0) ? 0.0 : time;
        }
    }
}

#pragma mark Helpers

- (void)clearPlayerSession {
    self.session = nil;
    self.audioPlayer1 = nil;
    self.audioPlayer2 = nil;
}

- (BOOL)isPlaying:(TrackNumber)track {
    return (track == TrackOne) ? self.audioPlayer1.isPlaying : self.audioPlayer2.isPlaying;
}

- (void)setVolumeToTrack:(TrackNumber)track {
    if (track == TrackOne) {
        if (self.audioPlayer1.isPlaying) {
            self.audioPlayer1.volume = 1.0;
            self.audioPlayer2.volume = 0.0;
        } else if (self.audioPlayer2.isPlaying) {
            self.audioPlayer1.volume = 0.0;
            self.audioPlayer2.volume = 1.0;
        }
    } else {
        if (self.audioPlayer2.isPlaying) {
            self.audioPlayer1.volume = 0.0;
            self.audioPlayer2.volume = 1.0;
        } else if (self.audioPlayer1.isPlaying) {
            self.audioPlayer1.volume = 1.0;
            self.audioPlayer2.volume = 0.0;
        }
    }
}

- (void)setSession:(Session *)session {
    _session = session;
    if (session.firstTrack && session.secondTrack) {
        [self setAudioPlayerForTrack:TrackOne media:session.firstTrack];
        [self setAudioPlayerForTrack:TrackTwo media:session.secondTrack];
    }
}

- (void)setAudioPlayerForTrack:(TrackNumber)track media:(MPMediaItem *)media {
    switch (track) {
        case TrackOne:
            self.audioPlayer1 = nil;
            self.audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
            self.audioPlayer1.delegate = self;
            break;
        case TrackTwo:
            self.audioPlayer2 = nil;
            self.audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[media valueForProperty: MPMediaItemPropertyAssetURL] error:nil];
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
    UIImage *image = [self.session getArt:indexPath.row size:cell.bounds.size];
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

#pragma mark AVSession Setup
//https://stackoverflow.com/questions/18807157/how-do-i-route-audio-to-speaker-without-using-audiosessionsetproperty/18808124#18808124
- (void)configureAVAudioSession {
    // Get your app's audioSession singleton object
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // Error handling
    BOOL success;
    NSError *error;
    
    // set the audioSession category.
    // Needs to be Record or PlayAndRecord to use audioRouteOverride:
    
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                             error:&error];
    
    if (!success) {
        NSLog(@"\n==========================================\n\n\n Claudius Logging:\n @file: \(%s)\n @func: \(%s)\n @line: \(%d)\n @data: \%@   \n\n\n==========================================\n",__FILE__,__PRETTY_FUNCTION__,__LINE__,[error localizedDescription]);
    }
    
    // Set the audioSession override
    success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                         error:&error];
    if (!success) {
        NSLog(@"\n==========================================\n\n\n Claudius Logging:\n @file: \(%s)\n @func: \(%s)\n @line: \(%d)\n @data: \%@   \n\n\n==========================================\n",__FILE__,__PRETTY_FUNCTION__,__LINE__,[error localizedDescription]);
    }
    
    // Activate the audio session
    success = [session setActive:YES error:&error];
    if (!success) {
        NSLog(@"\n==========================================\n\n\n Claudius Logging:\n @file: \(%s)\n @func: \(%s)\n @line: \(%d)\n @data: \%@   \n\n\n==========================================\n",__FILE__,__PRETTY_FUNCTION__,__LINE__,[error localizedDescription]);
    } else {
        NSLog(@"AudioSession active");
    }
}

@end
