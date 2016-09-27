//
//  DetailViewController.m
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-26.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *review1Label;
@property (weak, nonatomic) IBOutlet UILabel *review2Label;
@property (weak, nonatomic) IBOutlet UILabel *review3Label;

@property (strong, nonatomic) NSURLSessionDataTask *reviewTask;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation DetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(!self.movie.reviews){
        
        NSString *reviewURL = @"http://api.rottentomatoes.com/api/public/v1.0/movies/770672122/reviews.json?apikey=h8ym7ry7kkur36j7ku482y9z";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        self.reviewTask = [session dataTaskWithURL:[NSURL URLWithString:reviewURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error){
                
                NSError *jsonError;
                NSDictionary *reviewsJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if(!jsonError) {
                    NSArray *reviews = reviewsJson[@"reviews"];
                    
                    NSMutableArray *tempReviews = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *review in reviews) {
                        [tempReviews addObject:review[@"quote"]];
                    }
                    
                    self.movie.reviews = tempReviews;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.review1Label.text = self.movie.reviews[0];
                        self.review2Label.text = self.movie.reviews[1];
                        self.review3Label.text = self.movie.reviews[2];
                    });
                    
                }else{
                    NSLog(@"error: %@", error);
                }
            }
        }];
    } else{
        self.review1Label.text = self.movie.reviews[0];
        self.review2Label.text = self.movie.reviews[1];
        self.review3Label.text = self.movie.reviews[3];
    }
    
    [self.reviewTask resume];
    
    self.imageView.image = [UIImage imageWithData:
                            [NSData dataWithContentsOfURL:self.movie.local]];
    
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.reviewTask suspend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
