//
//  EditPictureScreen.h
//  StampLike
//
//  Created by  iOS Developer on 13/10/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "MainBeardCollectionScreen.h"
#import "ItemCollectionViewCell.h"
#define CELL_WIDTH 150.0
@interface EditPictureScreen : UIViewController<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CHTCollectionViewDelegateWaterfallLayout>
@property (strong, nonatomic) IBOutlet UIView *addStampsView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addStampsViewCenterConst;

@property (strong, nonatomic) IBOutlet UIImageView *editableImageView;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UICollectionView *itemCollectionView;

//recieved images and data variables
@property (nonatomic)  float imageRatio;
@property (strong,nonatomic) UIImage *recievedImage;
@property (strong,nonatomic) UIImage *recievedBeardImage;
@property (weak,nonatomic) NSMutableDictionary *viewInformation;

- (IBAction)addBeardScreenAction:(id)sender;
- (IBAction)removeBeardAction:(id)sender;
- (IBAction)discardScreenAction:(id)sender;
@end
