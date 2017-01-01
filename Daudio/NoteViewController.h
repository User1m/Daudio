//
//  NoteViewController.h
//  Daudio
//
//  Created by Claudius Mbemba on 1/1/17.
//  Copyright © 2017 Claudius Mbemba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol NoteViewControllerDelegate <NSObject>
- (void)didRequestAnnotationUpdate;
- (void)didFinishNote;
@end

@interface NoteViewController : UIViewController

@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) NSString *noteKey;
@property (nonatomic, strong) NSString *noteAnnotation;
@property (nonatomic, weak) id<NoteViewControllerDelegate> delegate;

@end
