//
//  PTHomeViewController.m
//  ProficiencyTest
//
//  Created by Ishan on 3/12/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "PTHomeViewController.h"
#import <SWNetworking/UIImageView+SWNetworking.h>
#import <SWNetworking/SWRequest.h>
#import "PTConstants.h"
#import "AboutCanada.h"
#import "AboutCell.h"

@interface PTHomeViewController () {
    NSArray *feedArray;
}

@end

@implementation PTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 90.0f;
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    self.tableView.tableFooterView    = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getDataFromAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom methods

-(void)showAlertWithMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Action methods

- (IBAction)tapRefresh:(UIBarButtonItem *)sender {
    
    [self getDataFromAPI];
    feedArray = nil;
    [self.tableView reloadData];
}

#pragma mark - API call

- (void)getDataFromAPI {
    //using SWNetworking call the API.
    SWGETRequest *getFeedRequest    = [[SWGETRequest alloc] init];
    [getFeedRequest startDataTaskWithURL:FEED_URL
                              parameters:nil
                              parentView:self.navigationController.view
                                 success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        //Get response from API call and encording it to UTF8
        NSError *error                  = nil;
        NSString *string                = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
        NSData *utf8Data                = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *respondObject     = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:&error];
        
        //Reading respond and assign the data into array
        feedArray                       = [AboutCanada getFeedList:respondObject];
        
        //set navigation bar title
        if ([respondObject objectForKey:@"title"]) {
         self.title = [respondObject objectForKey:@"title"];
        }
        
        [self.tableView reloadData];
                                             
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        [self showAlertWithMessage:ERROR_MESSAGE];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutCell" owner:self options:nil] objectAtIndex:0];
    }

    AboutCanada *aboutCanada    = [feedArray objectAtIndex:indexPath.row];
    cell.titleLabel.text        = aboutCanada.feedTitle;
    cell.descriptionLabel.text  = aboutCanada.feedDescription;
    
    [cell.aboutImageView setHidden:NO];
    cell.aboutImageView.image                   = nil;
    cell.titleLeadingConstraint.constant        = 12.0f;
    cell.descriptionLeadingConstraint.constant  = 12.0f;
    cell.imageViewWidthConstraint.constant      = 70.0f;
    cell.imageViewHeightConstraint.constant     = 70.0f;
    
    //Set feed image
    if (![aboutCanada.feedImageUrl isEqualToString:@""]) {
        //Feed image object is empty, Download image from Url using SWNetworking library
        if (aboutCanada.feedImage == nil) {
            [cell.aboutImageView loadWithURLString:aboutCanada.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
                aboutCanada.feedImage = image;
            }];
            
        } else {
            //Set image, already download image object
            [cell.aboutImageView setImage:aboutCanada.feedImage];
        }
    } else {
        //Image url is empty, reset the constant and hide the image view
        [cell.aboutImageView setHidden:YES];
        cell.titleLeadingConstraint.constant        = 0.0f;
        cell.descriptionLeadingConstraint.constant  = 0.0f;
        cell.imageViewWidthConstraint.constant      = 0.0f;
        cell.imageViewHeightConstraint.constant     = 0.0f;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
