//
//  ViewController.m
//  Instagram-Audible
//
//  Created by Chanikya on 27/07/2015.
//  Copyright (c) 2015 Chanikya Mandapathi. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

WebServiceClient *wClient;


@implementation ViewController


NSDictionary *instagramJSONDic;
UIView *fullScreenImageView;
int columnCount = 0;


#pragma mark collectionView code

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSArray *tempArray =[instagramJSONDic objectForKey:@"data"];
    return [tempArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    
    __weak UICollectionViewCell *weakCell = cell;
    
    
    
    NSString *imageURL = [[[[[instagramJSONDic objectForKey: @"data" ] objectAtIndex:indexPath.row] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.tag = indexPath.row;
    
    [cell addSubview:imageView];
    
    NSURL *url = [NSURL URLWithString:imageURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"A.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [imageView setImageWithURLRequest:request
                     placeholderImage:placeholderImage
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  
                                  
                                  [imageView setImage:image];
                                  
                                  [weakCell setNeedsLayout];
                                  
                                  
                              } failure:nil];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 2;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //This is called when you tap on an image in the collection view.
    
    fullScreenImageView = [[UIView alloc] initWithFrame: CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-20 )];
    
    fullScreenImageView.backgroundColor = [UIColor blackColor];

    UIImageView *fullImageView = (UIImageView *)[collectionView viewWithTag: indexPath.row];
    
    UIImageView *pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 200, 300, 300)];
    pictureView.image =  fullImageView.image;
    
    [fullScreenImageView addSubview:pictureView];
    [self.view addSubview:fullScreenImageView];
    
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector( onTap: )];
    [fullScreenImageView addGestureRecognizer: tgr];
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize frameSize;
    switch(columnCount){
        case 0  :
            frameSize = CGSizeMake(125, 125);
            columnCount =  columnCount + 1;
            break;
        case 1  :
            frameSize = CGSizeMake(100, 100);
            columnCount = columnCount + 1;
            break;
        case 2 :
            frameSize = CGSizeMake(75, 75);
            columnCount = 0;
        default :
            frameSize = CGSizeMake(75, 75);
            
    }
    [collectionView reloadData];
    return frameSize;
    
}

// Delegate function that gets triggered when photos are updated
- (void)webServiceClient:(WebServiceClient *)client didUpdateWithPics:(id)pics
{
    instagramJSONDic = pics;
    [_collectionView reloadData];
    
    [self.activityIndicatorView stopAnimating];
    
}

// Delegate function that gets triggered when there was a problem in retrieving the photos

- (void)webServiceClient:(WebServiceClient *)client didFailWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                        message:[NSString stringWithFormat:@"%There was a problem in connecting to the service.. Please check your internet connection"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(IBAction)onTap:(id)sender{
    //called from the full screen imageView.
    [fullScreenImageView removeFromSuperview];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    instagramJSONDic = [NSDictionary new];
    fullScreenImageView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    columnCount = 0;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _activityIndicatorView.center=self.view.center;
    [_activityIndicatorView startAnimating];
    [self.view addSubview:_activityIndicatorView];
    
    wClient = [WebServiceClient sharedWebServiceClient];
    wClient.delegate = self;
    [wClient retrievePhotos];
    
}


@end
