//
//  SecondViewController.m
//  HW5
//
//  Created by Lakshmi Subramanian on 6/25/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.


//References : techtopia.com

#import "SecondViewController.h"
#import "Social/Social.h"
#import "Accounts/Accounts.h"

@interface SecondViewController ()

@property NSEnumerator *emulate;


@end

@implementation SecondViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getTimeLine];
    
    /*UINib *cellNib = [UINib nibWithNibName:@"Cell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];
    
    //-(void) testTwitter {
    {
        ACAccountStore *accountStore = [[ACAccountStore alloc]init];
        
        if (accountStore != nil)
        {
            ACAccountType *accountType = [accountStore     accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            if (accountType != nil)
            {
                [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
                 {
                     if (granted)
                     {
                         
                         //Succesful Access
                         NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
                         if (twitterAccounts != nil)
                         {
                             ACAccount *currentAccount = [twitterAccounts objectAtIndex:0];
                             if (currentAccount != nil)
                             {
                                 NSString *paraString = [NSString stringWithFormat:@"qlx_corp"];
                                 NSDictionary *parameters = [NSDictionary dictionaryWithObject:paraString forKey:@"MobileApp4"];
                                 
                                 NSString *requestString = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
                                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:requestString] parameters:parameters];
                                 [request setAccount:currentAccount];
                                 
                                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                                  {
                                      if ((error == nil) && ([urlResponse statusCode] == 200))
                                      {
                                          _feed = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                                          _dictionary = [_feed objectAtIndex:0];
                                          
                                          //[self.tableView reloadData];
                                          
                                          NSLog(@"firstPost = %@", [_dictionary description]);
                                          
                                          _emulate = [_dictionary keyEnumerator];
                                          
                                          
                                      }
                                      else {
                                          NSLog(@"error: %@",error);
                                      }
                                  }];
                             }
                         }
                     }
                     else
                     {
                         //Access Denied
                         NSLog(@"access denied");
                     }
                 }];
            }
        }
        
    }*/

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getTimeLine {
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:
                                      @"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 NSDictionary *parameters =
                 @{@"screen_name" : @"@MobileApp4",
                   
                   @"include_rts" : @"0",
                   
                   @"trim_user" : @"1",
                   
                   @"count" : @"200"};
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      self.dataSource = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                      
                      if (self.dataSource.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tweetTableView reloadData];
                          });
                      }
                  }];
             }
             
             else {
                 
                 UIAlertView *alert = [[UIAlertView alloc]
                                       initWithTitle :@"No account"
                                       message:@"You do not have a valid twitter account.Please setup up your account details in the Setting option and try again"
                                       delegate:self
                                       cancelButtonTitle:@"ok"
                                       otherButtonTitles:nil];
                 
                 [alert performSelectorOnMainThread:@selector
                  (show) withObject:nil waitUntilDone:YES];

             }
         } else {
             
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle :@"Not authorized"
                                   message:@"You are not allowed to access the account"
                                   delegate:self
                                   cancelButtonTitle:@"ok"
                                   otherButtonTitles:nil];
             
             [alert performSelectorOnMainThread:@selector
              (show) withObject:nil waitUntilDone:YES];

         }
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tweetTableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tweetTableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tweet = _dataSource[[indexPath row]];
    
    cell.textLabel.text = tweet[@"text"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tweet = _dataSource[[indexPath row]];

    NSString *cellText = tweet[@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:cellText
     attributes:@
     {
     NSFontAttributeName: cellFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size.height + 20;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
