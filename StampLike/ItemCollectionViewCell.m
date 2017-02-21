//
//  ItemCollectionViewCell.m
//  StampLike
//
//  Created by  iOS Developer on 13/10/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@implementation ItemCollectionViewCell

@synthesize photoView = _photoView;

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x, self.contentView.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height )];
        _photoView.contentMode = UIViewContentModeScaleToFill;
        _photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _photoView.backgroundColor = [UIColor whiteColor];
        
    }
    return _photoView;
}

#pragma mark - Life Cycle

#if !__has_feature(objc_arc)
- (void)dealloc {
    [_photoView removeFromSuperview];
    _photoView = nil;

    
    [super dealloc];
}
#endif

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 20;
        self.contentView.clipsToBounds = true;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.photoView];
    }
    return self;
}

@end
