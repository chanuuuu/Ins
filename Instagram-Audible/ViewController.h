//
//  ViewController.h
//  Instagram-Audible
//
//  Created by Chanikya on 27/07/2015.
//  Copyright (c) 2015 Chanikya Mandapathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClient.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, WebServiceClientDelegate>
{
    NSMutableArray *imgArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

