//
//  MainBeardCollectionScreen.h
//  StampLike
//
//  Created by  iOS Developer on 13/10/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EditPictureScreen.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ItemCollectionViewCell.h"
#define ITEM_CELL_IDENTIFIER @"itemCell"
#define CELL_WIDTH 150.0
@interface MainBeardCollectionScreen : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@end
