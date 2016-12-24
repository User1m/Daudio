//
//  UIAlertController+Utils.h
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Utils)

+ (nonnull UIAlertController *)alertWithTitle:(nonnull NSString *)title message:(nonnull NSString *)message actionHandler:(nullable void(^)())handler;

@end
