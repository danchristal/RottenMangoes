//
//  MoviesCollectionViewController.m
//  RottenMangoes
//
//  Created by Dan Christal on 2016-09-26.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

#import "MoviesCollectionViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "DetailViewController.h"

@interface MoviesCollectionViewController ()

@property (nonatomic, strong) NSMutableArray<Movie *> *movieList;
@property (assign) int pageCount;
@property (nonatomic, strong, readonly) NSString *urlString;


@end

@implementation MoviesCollectionViewController

-(NSString *)urlString{
    return [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=h8ym7ry7kkur36j7ku482y9z&page_limit=50&page=%d", self.pageCount];
}

-(NSArray<Movie *> *)movieList{
    if(!_movieList){
        _movieList = [[NSMutableArray alloc] init];
    }
    return _movieList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCount = 1;
    [self fetchData];
    
    self.collectionView.delegate = self;
    //[session invalidateAndCancel];
    
    
}

-(void)fetchData{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:self.urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error){
            
            NSError *jsonError;
            
            NSDictionary *moviesJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *movies = moviesJson[@"movies"];
            
            for (NSDictionary *movie in movies) {
                
                Movie *newMovie = [[Movie alloc] initWithTitle:movie[@"title"] andSynopsys:movie[@"synopsis"] andImage:movie[@"posters"][@"original"] andID:movie[@"id"]];
                [self.movieList addObject:newMovie];
            }

            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }else{
            NSLog(@"Error: %@", error);
        }
        
    }];
    
    [dataTask resume];
    self.pageCount += 1;
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movieList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    
    // Configure the cell
    NSURL *url = [NSURL URLWithString:self.movieList[indexPath.item].imageURL];
    cell.downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        self.movieList[indexPath.item].local = location;
        UIImage *downloadedImage = [UIImage imageWithData:
                                    [NSData dataWithContentsOfURL:location]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = downloadedImage;
        });
        
    }];
    
    [cell.downloadTask resume];
    
    return cell;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showDetailSegue"]){
        
        DetailViewController *DVC = segue.destinationViewController;
        
        MovieCell *cell = (MovieCell *)sender;
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        DVC.movie = self.movieList[indexPath.item];
        
    }
    
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.item == [self.movieList count] - 1){
        [self fetchData];
    }
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */



@end
