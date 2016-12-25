//
//  SessionTableViewCell.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *firstTrackLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTrackLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstTrackArtImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondTrackArtImageView;

@end
