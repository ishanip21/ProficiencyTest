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
    
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    
    [self getDataFromAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods
-(void)showAlertWithMessage:(NSString *)str {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:str
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Action methods

#pragma mark - API call

- (void)getDataFromAPI {
    SWGETRequest *getFeedRequest    = [[SWGETRequest alloc] init];
    [getFeedRequest startDataTaskWithURL:FEED_URL
                              parameters:nil
                              parentView:self.navigationController.view
                                 success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSError *error                  = nil;
        NSString *string                = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
        NSData *utf8Data                = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *respondObject     = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:&error];
                                     
        feedArray                       = [AboutCanada getFeedList:respondObject];
                                     
        if ([respondObject objectForKey:@"title"]) {
         self.title = [respondObject objectForKey:@"title"];
        }
        
        [self.tableView reloadData];
                                     
        NSLog(@"respond -->%@", uploadTask.swRequest.responseString);
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        [self showAlertWithMessage:ERROR_MESSAGE];
    }];
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutCell" owner:self options:nil] objectAtIndex:0];
    }
    
    AboutCanada *aboutCanada    = [feedArray objectAtIndex:indexPath.row];
    cell.titleLabel.text        = aboutCanada.feedTitle;
    cell.descriptionLabel.text  = aboutCanada.feedDescription;
    
    if (![aboutCanada.feedImageUrl isEqualToString:@""] && aboutCanada.feedImage == nil) {
        [cell.aboutImageView loadWithURLString:aboutCanada.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
            aboutCanada.feedImage = image;
        }];
        
    } else {
        [cell.aboutImageView setImage:aboutCanada.feedImage];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
