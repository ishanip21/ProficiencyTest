//
//  AboutCell.h
//  ProficiencyTest
//
//  Created by Ishan on 3/12/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aboutImageView;

@end
