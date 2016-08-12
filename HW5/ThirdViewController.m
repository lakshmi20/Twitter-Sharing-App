//
//  ThirdViewController.m
//  HW5
//
//  Created by Lakshmi Subramanian on 06/25/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//
// References : http://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/

#import "ThirdViewController.h"
#import "LocationController.h"


@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ThirdViewController

CLLocationManager *manager;

UISearchController *search;

MKPlacemark *pin;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [[CLLocationManager alloc] init];
    
    manager.delegate = self;
    
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [manager requestLocation];
    
    [manager requestWhenInUseAuthorization];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    LocationController *locationSearchTable = [storyboard instantiateViewControllerWithIdentifier:@"LocationSearchTable"];
    
    search = [[UISearchController alloc] initWithSearchResultsController:locationSearchTable];
    
    search.searchResultsUpdater = locationSearchTable;
    
    // create a UI search bar
    
    UISearchBar *searchBar = search.searchBar;
    
    [searchBar sizeToFit];
    
    // enter a placemark for it
    searchBar.placeholder = @"Enter place to search";
    
    self.navigationItem.titleView = search.searchBar;
    
    search.hidesNavigationBarDuringPresentation = NO;
    
    search.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    
    locationSearchTable.mapView = _mapView;
    
    locationSearchTable.handleMapSearchDelegate = self;
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region animated:true];
}

- (void)reverseGeocoding:(MKPlacemark *)placemark
{
    // save a local copy of the pin
    
    pin = placemark;
    
    // clear data of existing pins
    
    [_mapView removeAnnotations:(_mapView.annotations)];
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    
    annotation.coordinate = placemark.coordinate;
    
    annotation.title = placemark.name;
    
    annotation.subtitle = [NSString stringWithFormat:@"%@ %@",
                           (placemark.locality == nil ? @"" : placemark.locality),
                           (placemark.administrativeArea == nil ? @"" : placemark.administrativeArea)
                           ];
    
    [_mapView addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(placemark.coordinate, span);
    
    [_mapView setRegion:region animated:true];
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
                return nil;
    }
    
    static NSString *reuseId = @"pin";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    if (pinView == nil) {
        
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
        pinView.enabled = YES;
        
        pinView.canShowCallout = YES;
        
        pinView.tintColor = [UIColor orangeColor];
        
    } else {
        
        pinView.annotation = annotation;
    }
    
    
    return pinView;
}



@end
