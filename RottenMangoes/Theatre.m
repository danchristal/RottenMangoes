//
//  Theatre.m
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-27.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import "Theatre.h"

@implementation Theatre


-(instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andCoordinate:(CLLocationCoordinate2D)coordinate{
    
    self = [super init];
    
    if(self){
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
    
    return self;
}
@end
