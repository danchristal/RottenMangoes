//
//  MapViewController.h
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-27.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
@import MapKit;
@import CoreLocation;

@interface MapViewController : UIViewController <UIWebViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) Movie *movie;

@end
