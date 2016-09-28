//
//  MapViewController.m
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-27.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import "MapViewController.h"
#import "Theatre.h"


@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) NSMutableArray<Theatre *> *theatreList;
@end

@implementation MapViewController

-(NSString *)urlString{
    if(!_urlString){
        _urlString = [[NSString alloc] init];
    }
    return _urlString;
}

-(CLGeocoder *)geocoder{
    if(!_geocoder){
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    [self startStandardUpdates];

}

-(NSMutableArray<Theatre *> *)theatreList{
    if(!_theatreList){
        _theatreList = [[NSMutableArray alloc] init];
    }
    
    return _theatreList;
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Try to dequeue an existing pin view first.
    MKAnnotationView * pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"TheatrePin"];
    
    if (!pinView){
        // If an existing pin view was not available, create one.
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:@"TheatrePin"];
        pinView.tintColor = [UIColor purpleColor];
        pinView.canShowCallout = YES;
    }
    else
        pinView.annotation = annotation;
    
    NSLog(@"Pin View location, %f, %f", pinView.annotation.coordinate.latitude, pinView.annotation.coordinate.longitude);
    return pinView;
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    [self.locationManager requestWhenInUseAuthorization];
//    [self.locationManager startUpdatingLocation];
    
}

-(void)fetchData{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:self.urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error){
            
            NSError *jsonError;
            NSDictionary *moviesJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *theatres = moviesJson[@"theatres"];
            
            for (NSDictionary *theatre in theatres) {
                
                Theatre *newTheater = [[Theatre alloc] initWithTitle:theatre[@"name"] andSubtitle:theatre[@"address"] andCoordinate:CLLocationCoordinate2DMake([theatre[@"lat"] doubleValue], [theatre[@"lng"] doubleValue])];
                
                [self.theatreList addObject:newTheater];
                NSLog(@"%@", newTheater.title);
            }
            
            
            NSMutableArray<MKPointAnnotation *> *anotationList = [[NSMutableArray alloc] init];
            for (Theatre *theatre in self.theatreList) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = theatre.title;
                annotation.subtitle = theatre.subtitle;
                annotation.coordinate = theatre.coordinate;
                
                [anotationList addObject:annotation];
            }
            
            //get main queue and add map pins
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotations:anotationList];
            });
        }
    }];
    
    [dataTask resume];

}

#pragma mark - Location Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations firstObject];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        self.urlString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", placemarks[0].postalCode, self.movie.title];
        self.urlString = [self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        [self fetchData];
    }];

}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager requestLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error: %@", error);
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
