//
//  HistoryTableVC.m
//  Synonymy
//
//  Created by Student on 12/12/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "HistoryTableVC.h"
#import "DataStore.h"
#import "History.h"
#import "UIColor+Extensions.h"
#import "SynonymVC.h"

NSString *PLACEHOLDER = @"No sentences have been added yet.";

@interface HistoryTableVC ()
@property (nonatomic, strong) NSMutableArray *history;
@end

@implementation HistoryTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _history = [DataStore sharedStore].history;
    
    if (_history.count == 0) {
        NSMutableArray *temp = [NSMutableArray array];
        
        [temp addObject:[[History alloc] initWithSentence:PLACEHOLDER]];
        _history = temp;
    }
    
    self.tableView.rowHeight = 110.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return [_history count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Plain" forIndexPath:indexPath];
    
    // Configure the cell...
    History *hist = self.history[indexPath.row];
    cell.textLabel.text = hist.sentence;
    cell.textLabel.numberOfLines = 2;
    
    UIFont *myFont = [UIFont fontWithName: @"Avenir" size: 25.0];
    cell.textLabel.font  = myFont;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor grapefruitColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    History *hist = self.history[indexPath.row];
    
    if (![hist.sentence isEqual:PLACEHOLDER]) {
        Sentence *sentence = [[Sentence alloc] initWithSentence:hist.sentence];
        
        SynonymVC *synVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Synonymize"];
        [synVC setSentence:sentence];
        
        [self.navigationController pushViewController:synVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    History *hist = self.history[indexPath.row];
    if ([hist.sentence isEqual:PLACEHOLDER]) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_history removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
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
