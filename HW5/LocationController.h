//
//  LocationController.h
//  HW5
//
//  Created by Lakshmi Subramanian on 6/27/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdViewController.h"
#import <Mapkit/Mapkit.h>

@interface LocationController : UITableViewController <UISearchResultsUpdating>

@property MKMapView *mapView;

@property id <HandleMapSearch>handleMapSearchDelegate;

@end
