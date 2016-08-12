//
//  LocationController.m
//  HW5
//
//  Created by Lakshmi Subramanian on 6/27/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.

//References : http://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/

#import "LocationController.h"

@interface LocationController ()

@property NSArray<MKMapItem *> *items;

@end

@implementation LocationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    NSString *searchBarText = searchController.searchBar.text;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchBarText;
    
    request.region = _mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        self.items = response.mapItems;
        
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}
// function to control the way the address is given
- (NSString *)parseAddress:(MKPlacemark *)selectedItem {
    
    
    NSString *space = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? @" " : @"";
    
    
    NSString *comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? @", " : @"";
    
    NSString *secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? @" " : @"";
    
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             (selectedItem.subThoroughfare == nil ? @"" : selectedItem.subThoroughfare),
                             space,
                             (selectedItem.thoroughfare == nil ? @"" : selectedItem.thoroughfare),
                             comma,
                             (selectedItem.locality == nil ? @"" : selectedItem.locality),
                             secondSpace,
                             (selectedItem.administrativeArea == nil ? @"" : selectedItem.administrativeArea)
                             ];
    return addressLine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    MKPlacemark *selectedItem = _items[indexPath.row].placemark;
    
    cell.textLabel.text = selectedItem.name;
    
    cell.detailTextLabel.text = [self parseAddress:selectedItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKPlacemark *selectedItem = _items[indexPath.row].placemark;
    
    [_handleMapSearchDelegate reverseGeocoding:(selectedItem)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
