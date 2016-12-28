//
//  SessionTableViewCell.m
//  Daudio
//
//  Created by Claudius Mbemba on 12/24/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

#import "SessionTableViewCell.h"

@interface SessionTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *bar1;
@property (weak, nonatomic) IBOutlet UIView *bar2;

@end

@implementation SessionTableViewCell

//https://stackoverflow.com/questions/6745919/uitableviewcell-subview-disappears-when-cell-is-selected
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.bar1.backgroundColor = [UIColor darkGrayColor];
        self.bar2.backgroundColor = [UIColor darkGrayColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted){
        self.bar1.backgroundColor = [UIColor darkGrayColor];
        self.bar2.backgroundColor = [UIColor darkGrayColor];
    }
}

@end
