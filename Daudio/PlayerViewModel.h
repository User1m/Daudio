//
//  PlayerView.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@class AVAudioPlayer, MPMediaItem;

@protocol PlayerViewModelDelegate <NSObject>

- (void)playerDidFinishPlaying:(UIAlertController *)alert;
- (void)collectionViewDidSwitch;

@end

@interface PlayerViewModel : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) Session *session;
@property (nonatomic, strong) id<PlayerViewModelDelegate>delegate;
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer1;
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer2;

- (instancetype)initWithSession:(Session *)session;
- (void)setAudioPlayerForTrack:(TrackNumber)track media:(MPMediaItem *)media;
- (NSString *)titleForTrack:(TrackNumber)track;
- (NSString *)artistForTrack:(TrackNumber)track;

//single player
- (void)startPlayerForTrack:(TrackNumber)track;
- (void)stopPlayerForTrack:(TrackNumber)track;
- (void)pausePlayerForTrack:(TrackNumber)track;
- (void)resetPlayerForTrack:(TrackNumber)track;
- (void)rewindPlayerForTrack:(TrackNumber)track;
- (void)fastFwdPlayerForTrack:(TrackNumber)track;
- (void)setVolumeToTrack:(TrackNumber)track;

//all players
- (void)startPlayers:(TrackNumber)track;
- (void)stopPlayers;
- (void)pausePlayers;
- (void)resetPlayersWithTrack:(TrackNumber)track;
- (void)rewindPlayers;
- (void)fastFwdPlayers;

- (void)clearPlayerSession;

@end
