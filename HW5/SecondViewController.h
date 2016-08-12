//
//  SecondViewController.h
//  HW5
//
//  Created by Lakshmi Subramanian on 6/25/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) NSDictionary *dictionary;

@property (strong, nonatomic) NSArray *feed;



@end
