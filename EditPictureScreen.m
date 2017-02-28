//
//  EditPictureScreen.m
//  StampLike
//
//  Created by  iOS Developer on 13/10/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

#import "EditPictureScreen.h"

@interface EditPictureScreen (){
    CGFloat lastRotation;
    int selectedStampTag ;
    NSMutableArray *imagesTitleArray;
    CGRect fr;
    CGFloat cellWidth;
    NSMutableArray *cellHeights;
    NSMutableArray *cellWidths;
    NSMutableArray *aspectRatioArray;
    CGFloat selectedRatio;
    UIImage *shareResultImage;
    BOOL initialStampAdded;
    UIView *stampBackgroundView;
    NSMutableArray *stampsAddedArray;
    NSMutableArray *stampsAddedArrayCenterPosition;
    UIPanGestureRecognizer *dragStampGesture;
    UIImageView *mainSelectedStamp;
    UITapGestureRecognizer *tapStampGesture;
    int tagSaved;
    UIPinchGestureRecognizer *zoomStampGesture;
    UIRotationGestureRecognizer *rotationRecognizer;
    CGFloat selectedStampRatio;
    CGFloat selectedStampWidth;
    NSMutableDictionary *stampsViewDefaultMaxRatio;
    IBOutlet UIImageView *removeStampImage;
    IBOutlet UIButton *removeStampButton;
    CGFloat lastScale;
}

@end

@implementation EditPictureScreen

- (void)viewDidLoad {
     [super viewDidLoad];
    stampsViewDefaultMaxRatio = [[NSMutableDictionary alloc]init];
    stampsAddedArray = [[NSMutableArray alloc]init];
    mainSelectedStamp = [[UIImageView alloc]init];
    shareResultImage = [[UIImage alloc] init];
    initialStampAdded = false;
    //set collection view delagte and datasource
    _itemCollectionView.delegate = self;
    _itemCollectionView.dataSource = self;
    
    selectedStampTag =0;
    _addStampsViewCenterConst.constant = - self.view.frame.size.height;
    //set image for editing
    _editableImageView.image = _recievedImage;

    //getsure used for stamps
    //gesture for dragging stamps
    dragStampGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragStampGestureAction:)];
    [dragStampGesture setDelegate:self];
    [mainSelectedStamp addGestureRecognizer:dragStampGesture];
    
    //zoom gesture for enlarging stamps
    zoomStampGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomStampGesture:)];
    [mainSelectedStamp addGestureRecognizer:zoomStampGesture];
    [zoomStampGesture setDelegate:self];
    
    //gesture for slecting stamp
    tapStampGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStampGesture:)];
    [tapStampGesture setDelegate:self];
    [mainSelectedStamp addGestureRecognizer:tapStampGesture];

    //getsure for deselecting stamp
    UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unselectStampGesture:)];
    [_editableImageView addGestureRecognizer:tapViewGesture];
    [tapViewGesture setDelegate:self];

    //rotation gesture for stamps
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateStampGesture:)];
        [rotationRecognizer setDelegate:self];
        lastRotation = 0.0;
        [rotationRecognizer setDelegate:self];
        [mainSelectedStamp addGestureRecognizer:rotationRecognizer];

    
    //collection view coding
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
    selectedStampRatio = (float)self.view.frame.size.width *1.1/mainSelectedStamp.frame.size.width;
    fr = [self frameForImage:_recievedImage inImageViewAspectFit:_editableImageView];
    //add stamp only once on load
    if (initialStampAdded == false) {
        [self addMoreStamps];
        initialStampAdded = true;
    }
}

#pragma mark #################################
//method for adding stamps
#pragma mark #################################
-(void)addMoreStamps{
    mainSelectedStamp.layer.borderWidth = 0.0;;
    [mainSelectedStamp setBackgroundColor:[UIColor clearColor]];
    mainSelectedStamp.layer.borderWidth = 0.0f;
    [mainSelectedStamp removeGestureRecognizer:dragStampGesture];
    [mainSelectedStamp removeGestureRecognizer:zoomStampGesture];
    
    //check how many stamps added already
    if ([stampsAddedArray count] != 6) {
        selectedStampTag++;
        [mainSelectedStamp setBackgroundColor:[UIColor clearColor]];
        _imageRatio = _recievedBeardImage.size.height/_recievedBeardImage.size.width;
        
        tagSaved = selectedStampTag;
       // UIView *anotherStampBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100,100 * _imageRatio)];
        UIImageView *anotherStamp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140,140 * _imageRatio)];
        [anotherStamp setImage:_recievedBeardImage];
        
        CGFloat frameSize;
        CGRect stampFrame = anotherStamp.frame;
        if (stampFrame.size.width > stampFrame.size.height) {
            frameSize = stampFrame.size.width + 70;
            if (frameSize > self.view.frame.size.width) {
                frameSize = self.view.frame.size.width;
            }
        }
        frameSize = stampFrame.size.height + 70;
        if (frameSize > self.view.frame.size.width) {
            frameSize = self.view.frame.size.width;
        }
        anotherStamp.center = CGPointMake(_editableImageView.center.x,_editableImageView.center.y);

        anotherStamp.tag = selectedStampTag;
        [anotherStamp setUserInteractionEnabled:true];
        [anotherStamp addGestureRecognizer:dragStampGesture];
        [anotherStamp addGestureRecognizer:rotationRecognizer];
        [anotherStamp addGestureRecognizer:zoomStampGesture];
        [anotherStamp setUserInteractionEnabled:true];
        mainSelectedStamp = anotherStamp;
        
        [mainSelectedStamp setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.1]];
        mainSelectedStamp.layer.borderWidth = 1.0f;
        mainSelectedStamp.layer.borderColor = [UIColor whiteColor].CGColor;
        mainSelectedStamp.layer.cornerRadius = 6.0;
        [self.backgroundView addSubview: mainSelectedStamp];
        [stampsAddedArray addObject:mainSelectedStamp];
        selectedStampWidth = mainSelectedStamp.frame.size.width;
        
        UITapGestureRecognizer * tapStampGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStampGesture:)];
        //[beardImage addGestureRecognizer:tapStampGesture];
        [tapStampGesture2 setDelegate:self];
        [mainSelectedStamp addGestureRecognizer:tapStampGesture2];
        
        selectedStampRatio = (float)self.view.frame.size.width *1.1/mainSelectedStamp.frame.size.width;
        [stampsViewDefaultMaxRatio setObject:[NSString stringWithFormat:@"%f",selectedStampRatio]forKey:[NSString stringWithFormat:@"%ld",(long)anotherStamp.tag]];
    }else{
        //show alert if user has already added 6 stamps
        [self showBasicAlert:@"You have added 6 Stamps already." Message:@"You can add only 6 stamps per Image."];
    }
}

#pragma mark #################################
//capture uiview and convert it to view
#pragma mark #################################
- (UIImage *)captureViewAsImage {
    CGRect cr = [self frameForImage:_recievedImage inImageViewAspectFit:_editableImageView];
    CGRect cropRectFromImage = CGRectMake(cr.origin.x * 4,cr.origin.y * 4 ,cr.size.width * 4 ,cr.size.height  *4);
    //Begin Graphics
    UIGraphicsBeginImageContextWithOptions(_backgroundView.frame.size, YES , 4.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.backgroundView.layer renderInContext:context];
    
    UIImage *fullImageScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect([fullImageScreenShot CGImage], cropRectFromImage);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef  scale:4.0F orientation:UIImageOrientationUp];
    //end grphics
    UIGraphicsEndImageContext();
    return croppedImage;
}

#pragma mark #################################
//get image's real frame from imageview
#pragma mark #################################
-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView{
    float imageRatio = image.size.width / image.size.height;
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio){
        float scale = imageView.frame.size.height / image.size.height;
        float width = scale * image.size.width;
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else{
        float scale = imageView.frame.size.width / image.size.width;
        float height = scale * image.size.height;
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

#pragma mark #################################
//Gesture delegates and methods
#pragma mark #################################
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    return  YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

#pragma mark #################################
//getsure actions
#pragma mark #################################

//
- (IBAction)unselectStampGesture:(UITapGestureRecognizer *)recognizer {
    [mainSelectedStamp setBackgroundColor:[UIColor clearColor]];
    mainSelectedStamp.layer.borderWidth = 0.0f;
    [mainSelectedStamp removeGestureRecognizer:dragStampGesture];
    [mainSelectedStamp removeGestureRecognizer:zoomStampGesture];
    [mainSelectedStamp removeGestureRecognizer:rotationRecognizer];
    removeStampImage.alpha = 0.7;
    removeStampButton.enabled = false;
}

//tap gesture for stamp
- (IBAction)tapStampGesture:(UITapGestureRecognizer *)recognizer {
    removeStampImage.alpha = 1.0;
    removeStampButton.enabled = true;
    [mainSelectedStamp setBackgroundColor:[UIColor clearColor]];
    mainSelectedStamp.layer.borderWidth = 0.0f;
    mainSelectedStamp.layer.borderColor = [UIColor whiteColor].CGColor;
    mainSelectedStamp.layer.cornerRadius = 6.0f;
    
    UIView *view = recognizer.view;
    mainSelectedStamp = (UIImageView *)view;
    selectedStampRatio = (float)self.view.frame.size.width /selectedStampWidth;
    [view setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.1]];
    view.layer.borderWidth = 1.0;;
    [view addGestureRecognizer:dragStampGesture];
    [view addGestureRecognizer:rotationRecognizer];
    [view addGestureRecognizer:zoomStampGesture];
    [_backgroundView bringSubviewToFront:mainSelectedStamp ];
    tagSaved = (int)recognizer.view.tag;
    selectedStampRatio = [[stampsViewDefaultMaxRatio valueForKey:[NSString stringWithFormat:@"%d",(int)recognizer.view.tag]] floatValue ];
}

//drag stamp gesture
- (IBAction)dragStampGestureAction:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:_backgroundView];
    //Restrict stamp if Stamp is dragging out of view
    if ((mainSelectedStamp.center.x + translation.x) <= 0 || (mainSelectedStamp.center.y + translation.y) <= (_editableImageView.frame.size.height - _backgroundView.frame.size.height )/2 || (mainSelectedStamp.center.x + translation.x) >= self.view.frame.size.width || (mainSelectedStamp.center.y + translation.y) >= (_backgroundView.frame.size.height  + _editableImageView.frame.size.height)/2) {
        
    }
    else{
        mainSelectedStamp.center =  CGPointMake(mainSelectedStamp.center.x + (translation.x * 0.9),mainSelectedStamp.center.y + (translation.y * 0.9));
    }
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
}

//rotate stamp gesture
-(void)rotateStampGesture:(UIRotationGestureRecognizer *)gesture {
    if([(UIRotationGestureRecognizer*)gesture state] == UIGestureRecognizerStateEnded) {
        lastRotation = 0.0;
        return;
    }
    CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)gesture rotation]);
    CGAffineTransform currentTransform = gesture.view.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [gesture.view setTransform:newTransform];
    lastRotation = [(UIRotationGestureRecognizer*)gesture rotation];
}

//zoom stamp gesture
- (IBAction)zoomStampGesture:(UIPinchGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale = [gestureRecognizer scale];
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [[[gestureRecognizer view].layer     valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = [[stampsViewDefaultMaxRatio valueForKey:[NSString stringWithFormat:@"%d",(int)gestureRecognizer.view.tag]] floatValue ];
        const CGFloat kMinScale = 0.30;
        CGFloat newScale = 1 -  (lastScale - [gestureRecognizer scale]); // new scale is in the range (0-1)
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
        [gestureRecognizer view].transform = transform;
        
        lastScale = [gestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }}


#pragma mark #################################
#pragma 'all 4 bottom button actions'
#pragma mark #################################

//share result image with/without stamps attached
- (IBAction)shareResultImageButtonAction:(id)sender {
    //set current stamp background color
        [mainSelectedStamp setBackgroundColor:[UIColor clearColor]];
        mainSelectedStamp.layer.borderWidth = 0.0f;
    shareResultImage = [self captureViewAsImage];
    NSArray *objectsToShare = @[shareResultImage];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[];
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:^{}];
}

//Add beard button - action
- (IBAction)addBeardScreenAction:(id)sender {
    _addStampsView.hidden = false;
    [_itemCollectionView setContentOffset:CGPointZero animated:YES];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _addStampsView.frame;
        frame.origin.y = 0;
        _addStampsView.frame = frame;
    } completion:^(BOOL finished) {}];
}

//remove button action
- (IBAction)removeBeardAction:(id)sender {
    UIView *view = (UIView *)[self.view viewWithTag:tagSaved];

    if ([stampsAddedArray containsObject:view]) {
        [view removeFromSuperview];
        [stampsAddedArray removeObject:view];
        [stampsViewDefaultMaxRatio removeObjectForKey:[NSString stringWithFormat:@"%d",tagSaved]];
        if (stampsAddedArray.count == 0) {
            removeStampImage.alpha = 0.7;
            removeStampButton.enabled = false;
        }
        
    }else{
        removeStampImage.alpha = 0.7;
        removeStampButton.enabled = false;
    }
    view = nil;
}

//Take user back to main screen
- (IBAction)discardScreenAction:(id)sender {
}

//A basic alert showing method
-(void)showBasicAlert:(NSString*)title Message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//Cancel button on add stamps view- action
- (IBAction)cancelAddStampsView:(id)sender {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _addStampsView.frame;
        frame.origin.y = -self.view.frame.size.height;
        _addStampsView.frame = frame;
    } completion:^(BOOL finished) {_addStampsView.hidden = true;}];
}


//collection view datasource and delgate methods
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
        UIImage *beardImage2 = [UIImage imageNamed:imageString];
        if (beardImage2) {
            CGFloat width = beardImage2.size.width;
            CGFloat height = beardImage2.size.height;
            CGFloat value = height/width * CELL_WIDTH;
            [self.cellHeights addObject:[NSNumber numberWithFloat:value]];
        }
    }
    [self.itemCollectionView reloadData];
}

//Calculate Width
-(void)fillWidthArray{
    for (NSString *imageString in imagesTitleArray){
        UIImage *beardImage2 = [UIImage imageNamed:imageString];
        if (beardImage2) {
            CGFloat width = beardImage2.size.width;
            
            [self.cellWidths addObject:[NSNumber numberWithFloat:width]];
        }
    }
    [self.itemCollectionView reloadData];
}

//Calculate Aspect Ratio
-(void)fillAspectRatioArray{
    for (NSString *imageString in imagesTitleArray){
        UIImage *beardImage2 = [UIImage imageNamed:imageString];
        if (beardImage2) {
            CGFloat width = beardImage2.size.width;
            CGFloat height = beardImage2.size.height;
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
        cell.photoView.image = [UIImage imageNamed:[imagesTitleArray objectAtIndex:indexPath.row]];
    }
    else{
        [cell.photoView setImage:[UIImage imageNamed:@"no-image.png"]];
    }
    [cell.photoView setTag:indexPath.row];
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
    _recievedBeardImage = [UIImage imageNamed:[imagesTitleArray objectAtIndex:indexPath.row]];
    selectedRatio = [[aspectRatioArray objectAtIndex:indexPath.row] floatValue ];
    //set remove button enabled
    removeStampImage.alpha = 1.0;
    removeStampButton.enabled = true;
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _addStampsView.frame;
        frame.origin.y = -self.view.frame.size.height;
        _addStampsView.frame = frame;
    } completion:^(BOOL finished) {
    _addStampsView.hidden= true;}];
    
    //Add selected stamp
    [self addMoreStamps];
}
@end
