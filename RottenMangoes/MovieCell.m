//
//  MovieCell.m
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-26.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

-(void)prepareForReuse{
    [super prepareForReuse];
    [self.downloadTask suspend];
    self.imageView.image = nil;
}

@end
