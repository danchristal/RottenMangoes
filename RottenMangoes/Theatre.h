//
//  Theatre.h
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-27.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import MapKit;

@interface Theatre : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andCoordinate:(CLLocationCoordinate2D)coordinate;

@end
