//
//  Movies.m
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-26.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initWithTitle:(NSString *)title andSynopsys:(NSString *)synopsis andImage:(NSString *)imageURL andID:(NSNumber *)movieId;
{
    
    self = [super init];
    
    if(self){
        _title = title;
        _synopsis = synopsis;
        _imageURL = imageURL;
        _movieId = movieId;
    }
    
    return self;
}


@end
