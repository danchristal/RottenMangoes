//
//  Movies.h
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-26.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) NSURL *local;
@property (nonatomic, strong) NSNumber *movieId;


-(instancetype)initWithTitle:(NSString *)title andSynopsys:(NSString *)synopsis andImage:(NSString *)imageURL andID:(NSNumber *)movieId;

@end
