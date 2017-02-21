//
//  MainBeardCollectionScreen.m
//  StampLike
//
//  Created by  iOS Developer on 13/10/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

#import "MainBeardCollectionScreen.h"

@interface MainBeardCollectionScreen (){
    UICollectionView *_collectionView;
    NSMutableArray *imagesTitleArray;
    UIAlertController *chooseImageAlert;
    UIImage *chosenImage;
    UIImage *selectedBeardImage;
    
    CGFloat cellWidth;
    NSMutableArray *cellHeights;
    NSMutableArray *cellWidths;
    NSMutableArray *aspectRatioArray;
    CGFloat selectedRatio;
    NSMutableDictionary * viewInfo;
}
@end

@implementation MainBeardCollectionScreen
- (void)viewDidLoad{
    [super viewDidLoad];
    //set delegate
    _itemCollectionView.delegate = self;
    _itemCollectionView.dataSource = self;
    
    //SET Title Settings
    UILabel *label = (UILabel *)[self.view viewWithTag:2];
    label.adjustsFontSizeToFitWidth = YES;
    [label sizeToFit];
    
    //Beard Images Array
    imagesTitleArray = [[NSMutableArray alloc]initWithObjects:@"sunglass.png",@"ukulele green.png",@"WH-GV-UKULELE-BROWN.png",@"WH-GV-GLITTER-knockout.png",@"pink ukulele-2.png",@"pet-2.png",@"lips and glass.png",@"jar mask.png",@"GVA-GVL-HAIR-PINK-41-OPACITY.png",@"5.png",@"4-2.png",@"3-2.png",@"2.png", nil];
    
    //Calculate height, Width and Aspect Ratio of each Beard Image
    [self fillHeightArray];
    [self fillWidthArray];
    [self fillAspectRatioArray];
    
    
    cellWidth = CELL_WIDTH;
    CHTCollectionViewWaterfallLayout *layoutForItem = [[CHTCollectionViewWaterfallLayout alloc] init];
    layoutForItem.sectionInset = UIEdgeInsetsMake(0.0, 10, 10, 10);
    layoutForItem.headerHeight = 10;
    layoutForItem.footerHeight = 10;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        layoutForItem.minimumColumnSpacing = 30;
        layoutForItem.minimumInteritemSpacing = 30;
    }
    else{
        layoutForItem.minimumColumnSpacing = 10;
        layoutForItem.minimumInteritemSpacing = 10;
    }
    self.itemCollectionView.collectionViewLayout = layoutForItem;
    self.itemCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.itemCollectionView.backgroundColor = [UIColor whiteColor];
    [self.itemCollectionView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER];
}
-(void)viewDidAppear:(BOOL)animated{
    
    viewInfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithFloat:self.view.frame.size.width],@"viewWidth",[NSNumber numberWithFloat:self.view.frame.size.height],@"viewHeight", nil];
    
}

#pragma mark #################################
#pragma  Calculate Beard 'Adjust Orientation Issues'
#pragma mark #################################

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}
//set Column Count
- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation{
    CHTCollectionViewWaterfallLayout *layoutForItem = (CHTCollectionViewWaterfallLayout *)self.itemCollectionView.collectionViewLayout;
    layoutForItem.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}


#pragma mark #################################
#pragma  Calculate Beard 'Images Orginal height and Width and AspectRatio'
#pragma mark #################################

- (NSMutableArray *)cellHeights{
    if (!cellHeights){
        cellHeights = [[NSMutableArray alloc] init];
    }
    return cellHeights;
}

- (NSMutableArray *)cellWidths{
    if (!cellWidths){
        cellWidths = [[NSMutableArray alloc] init];
    }
    return cellWidths;
}

- (NSMutableArray *)aspectRatio{
    if (!aspectRatioArray){
        aspectRatioArray = [[NSMutableArray alloc] init];
    }
    return aspectRatioArray;
}


//Calculate Height
-(void)fillHeightArray{
    for (NSString *imageString in imagesTitleArray){
        UIImage *beardImage = [UIImage imageNamed:imageString];
        if (beardImage) {
            CGFloat width = beardImage.size.width;
            CGFloat height = beardImage.size.height;
            CGFloat value = height/width * CELL_WIDTH;
            [self.cellHeights addObject:[NSNumber numberWithFloat:value]];
        }
    }
    [self.itemCollectionView reloadData];
}

//Calculate Width
-(void)fillWidthArray{
    for (NSString *imageString in imagesTitleArray){
        UIImage *beardImage = [UIImage imageNamed:imageString];
        if (beardImage) {
            CGFloat width = beardImage.size.width;
            
            [self.cellWidths addObject:[NSNumber numberWithFloat:width]];
        }
    }
    [self.itemCollectionView reloadData];
}

//Calculate Aspect Ratio
-(void)fillAspectRatioArray{
    for (NSString *imageString in imagesTitleArray){
        UIImage *beardImage = [UIImage imageNamed:imageString];
        if (beardImage) {
            CGFloat width = beardImage.size.width;
            CGFloat height = beardImage.size.height;
            CGFloat value = (float)height/(float)width;
            [self.aspectRatio addObject:[NSNumber numberWithFloat:value]];
        }
    }
    [self.itemCollectionView reloadData];
}


#pragma mark #################################
#pragma  UICollectionView 'Datasource Methods'
#pragma mark #################################

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [imagesTitleArray count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//set cell display
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ItemCollectionViewCell *cell = (ItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER  forIndexPath:indexPath];
    NSString *urlString = [imagesTitleArray objectAtIndex:indexPath.row];
    if (urlString){
        cell.photoView.image = [UIImage imageNamed:urlString];
    }
    else{
        [cell.photoView setImage:[UIImage imageNamed:@"no-image.png"]];
    }
    [cell.photoView setTag:indexPath.row];
    //    cell.layer.shadowOpacity = 0.5;
    //    cell.layer.shadowRadius = 5.0;
    //     cell.layer.shadowOffset = CGSizeMake(0, 10);
    return cell;
}


#pragma mark #################################
#pragma mark CHTCollectionViewDelegateWaterfallLayout Delegtae Methods
#pragma mark #################################
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [[self.cellHeights objectAtIndex:indexPath.row] floatValue];
    CGSize size = CGSizeMake(cellWidth, height);
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self showAlertForPickingPicture];
    //save selected beard image
    selectedBeardImage = [UIImage imageNamed:[imagesTitleArray objectAtIndex:indexPath.row]];
    selectedRatio = [[aspectRatioArray objectAtIndex:indexPath.row] floatValue ];
    
}


#pragma mark #################################
#pragma  Camera 'Delegate Methods'
#pragma mark #################################

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //save image picked
    chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //dismiss camera and open editable screen
    [picker dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"addBeardSegue" sender:self];
    }];
}

//Alert for chossing Camera or Library
-(void)showAlertForPickingPicture{
    UIAlertController *pickOptionAlert = [UIAlertController alertControllerWithTitle:@"Select where to get photo from" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //Camera action
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    [pickOptionAlert addAction:takePhoto];
    
    //Photo library action
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    [pickOptionAlert addAction:photoLibrary];
    
    //Cancel Picking Image
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [pickOptionAlert addAction:cancel];
    
    //show alert
    [self presentViewController:pickOptionAlert animated:true completion:nil];
}

#pragma ################################
#pragma  'Segue methods'
#pragma ################################

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditPictureScreen *vc = (EditPictureScreen*)segue.destinationViewController;
    vc.recievedImage = chosenImage;
    vc.recievedBeardImage = selectedBeardImage;
    vc.imageRatio = selectedRatio;
    vc.viewInformation = viewInfo;
}

-(IBAction)unwindToMainScreen :(UIStoryboardSegue*)segue{}

@end
