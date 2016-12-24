//
//  SessionViewController.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface SessionViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<Session *> *savedSessions;

@end
