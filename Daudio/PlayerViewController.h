//
//  PlayerViewController.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/23/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewModel.h"

@class Session;

@protocol PlayerViewControllerDelegate <NSObject>
- (void)didSetNewSession:(Session *)session;
@end

typedef NS_ENUM(NSUInteger, SongChoice) {
    firstChoice,
    secondChoice,
    zeroChoice
};

@interface PlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *dragBar;
@property (nonatomic, weak) id<PlayerViewControllerDelegate> delegate;
@property (nonatomic, strong) PlayerViewModel *player;

@end

