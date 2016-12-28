//
//  PlayViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/28/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "PlayViewController.h"
@import AVFoundation;
@import MediaPlayer;

@interface PlayViewController () <MPMediaPickerControllerDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) MPMediaPickerController *picker;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    self.picker.delegate = self;
    self.picker.allowsPickingMultipleItems = NO;
    [self configureAVAudioSession];
}

- (IBAction)choose:(id)sender {
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (IBAction)play:(id)sender {
    @try {
        self.player.volume = 1.0;
        [self.player play];
        NSLog(@"\n==========================================\n\n\n Claudius Logging:\n @file: \(%s)\n @func: \(%s)\n @line: \(%d)\n @PLAYING: \%d %f   \n\n\n==========================================\n",__FILE__,__PRETTY_FUNCTION__,__LINE__,[self.player isPlaying], self.player.currentTime);
        
    } @catch (NSException *exception) {
        //ObjC
        NSLog(@"\n==========================================\n\n\n Claudius Logging:\n @file: \(%s)\n @func: \(%s)\n @line: \(%d)\n @data: \%@   \n\n\n==========================================\n",__FILE__,__PRETTY_FUNCTION__,__LINE__,@"ERROR");
    }
}

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
    }
    else {
        NSLog(@"AudioSession active");
    }
}

#pragma mark MPMediaPickerController Delgates

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    self.player = nil;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[mediaItemCollection.items.firstObject valueForProperty: MPMediaItemPropertyAssetURL] error:&error];
    if (error) {
        NSLog(@"\n==========================================\n\n\n Claudius Logging:\n @file: \(%s)\n @func: \(%s)\n @line: \(%d)\n @data: \%@   \n\n\n==========================================\n",__FILE__,__PRETTY_FUNCTION__,__LINE__,[error localizedDescription]);
    } else {
        self.player.delegate = self;
        [self.player prepareToPlay];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
