//
//  FirstViewController.h
//  HW5
//
//  Created by Lakshmi Subramanian on 6/25/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *Datetime;

@property (weak, nonatomic) IBOutlet UILabel *Devicemodel;

@property (weak, nonatomic) IBOutlet UIButton *tweet;

@property (strong, nonatomic) NSString *str;

@property (strong, nonatomic) NSString *checkinString;

@end

