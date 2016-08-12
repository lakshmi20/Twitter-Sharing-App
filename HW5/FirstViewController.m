//
//  FirstViewController.m
//  HW5
//
//  Created by Lakshmi Subramanian on 6/25/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import "FirstViewController.h"
#import "Social/Social.h"
#import "Accounts/Accounts.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.title = @"PVGP";
    //self.title = @"Event Planner";

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSString *localDate = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateformatter setLocale:locale];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    NSDate *date = [NSDate date];
    NSString *formatteddate = [dateformatter stringFromDate:date];
    NSString *model = [[UIDevice currentDevice] model];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *modelversion = [model stringByAppendingString:version];
    NSString *andrew = @"lakshmis";
    
    _str = [NSString stringWithFormat: @"%@ %@ %@ %@", @"MobileApp4 ", andrew, formatteddate,modelversion];
    
    //int myLength = [_str length];
    
    //NSLog(@"length = %@",myLength);
    
    self.Datetime.text = formatteddate;
    
    self.Devicemodel.text = modelversion;
}

- (IBAction)tweet:(id)sender {
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 
                 NSDictionary *message = @ {@"status": _str };
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:message];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      NSLog(@"Twitter HTTP response: %i",
                            [urlResponse statusCode]);
                      
                      int response = [urlResponse statusCode];
                    
                      if(response == 200){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Posted"
                                                message:@"Your tweet has been posted successfully"
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      
                      if(response == 401){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Not authorized"
                                                message:@"Incorrect or missing credentials"
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      
                      
                      if(response == 403){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Forbidden"
                                                message:@"Access Denied "
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      if(response == 500){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Server Error"
                                                message:@"There seems to a issue posting your information.Please check your network connection and try again "
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      
                      if(response == 502){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Bad Gateway"
                                                message:@"Twitter server is down.Please try again later "
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }

                      
                  }];
                 
             }
             
             else{
                 UIAlertView *alert = [[UIAlertView alloc]
                                       initWithTitle :@"No account"
                                       message:@"You do not have a valid twitter account.Please setup up your account details in the Setting option and try again"
                                       delegate:self
                                       cancelButtonTitle:@"ok"
                                       otherButtonTitles:nil];
                 
                 [alert performSelectorOnMainThread:@selector
                  (show) withObject:nil waitUntilDone:YES];

             }
         }
         else{
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle :@"Permission Denied"
                                   message:@"Access to the twitter account is denied"
                                   delegate:self
                                   cancelButtonTitle:@"ok"
                                   otherButtonTitles:nil];
             
             [alert performSelectorOnMainThread:@selector
              (show) withObject:nil waitUntilDone:YES];

         }
     }];

}


 /*   if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        self.checkinString = [@"@MobileApp4" stringByAppendingFormat:
                              @" %@ ", self.str];
        
        [tweetSheet setInitialText: self.checkinString];
        //[tweetSheet setInitialText:@"%@",self.str];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }*/
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)postToTwitter:(id)sender {
 NSLog(@"helo");
 
 if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
 {
 
 SLComposeViewController *tweetSheet = [SLComposeViewController
 composeViewControllerForServiceType:SLServiceTypeTwitter];
 self.checkinString = [@"Check In:" stringByAppendingFormat:
 @" %@ ", self.str];
 
 [tweetSheet setInitialText: self.checkinString];
 //[tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
 [self presentViewController:tweetSheet animated:YES completion:nil];
 }
 else
 {
 UIAlertView *alertView = [[UIAlertView alloc]
 initWithTitle:@"Sorry"
 message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 [alertView show];
 }
 
 
 }*/


@end
