//
//  FavoritesTableVC.m
//  Synonymy
//
//  Created by Student on 12/16/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "FavoritesTableVC.h"
#import "DataStore.h"
#import "Sentence.h"
#import "Favorite.h"
#import "UIColor+Extensions.h"
#import "SynonymVC.h"

NSString *FILLER = @"No favorites have been added.";

@interface FavoritesTableVC () {
    NSMutableArray *_favorites;
}

@end

@implementation FavoritesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    _favorites = [DataStore sharedStore].favorites;
//    
//    if (_favorites.count == 0) {
//        NSMutableArray *temp = [NSMutableArray array];
//        NSAttributedString *tempstr = [[NSAttributedString alloc]initWithString:FILLER];
//        Sentence *tempsent = [[Sentence alloc] initWithSentence:FILLER];
//        
//        [temp addObject:[[Favorite alloc] initWithSentence:tempsent attrText:tempstr]];
//
//        _favorites = temp;
//    }
    
    self.tableView.rowHeight = 110.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSLog(@"favVC %@", _favorites);
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"appear %@", _favorites);
    _favorites = [DataStore sharedStore].favorites;
    
    if (_favorites.count == 0) {
        NSMutableArray *temp = [NSMutableArray array];
        NSAttributedString *tempstr = [[NSAttributedString alloc]initWithString:FILLER];
        Sentence *tempsent = [[Sentence alloc] initWithSentence:FILLER];
        
        [temp addObject:[[Favorite alloc] initWithSentence:tempsent attrText:tempstr]];
        
        _favorites = temp;
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_favorites count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Plain" forIndexPath:indexPath];
    
    // Configure the cell...

    Favorite *favorite = _favorites[indexPath.row];
    
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel setAttributedText:favorite.highlighted];
    
    UIFont *myFont = [UIFont fontWithName: @"Avenir" size: 25.0];
    cell.textLabel.font  = myFont;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor mintColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorite *favorite = _favorites[indexPath.row];
    Sentence *sent = favorite.sentence;
    
    if (![sent.fullsentence isEqual:FILLER]) {
        
        SynonymVC *synVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Synonymize"];
        [synVC setSentence:sent];
        [synVC setAttrText:favorite.highlighted];
        
        [self.navigationController pushViewController:synVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorite *fav = _favorites[indexPath.row];
    Sentence *sent = fav.sentence;
    
    if ([sent.fullsentence isEqual:FILLER]) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_favorites removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

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
