//
//  ThirdViewController.h
//  HW5
//
//  Created by Lakshmi Subramanian on 6/26/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
//@import MapKit;

@protocol HandleMapSearch <NSObject>
//function to to give placemark when a dropbox is clicked
- (void)reverseGeocoding:(MKPlacemark *)placemark;
@end

@interface ThirdViewController : UIViewController <CLLocationManagerDelegate, HandleMapSearch, MKMapViewDelegate>

@end
