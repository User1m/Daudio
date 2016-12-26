//
//  SessionViewController.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SessionDataService;

@interface SessionViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveAllButton;

@property (nonatomic, strong) SessionDataService *dataService;

@end
