//
//  SynonymPickerVC.m
//  Synonymy
//
//  Created by Student on 12/14/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "SynonymPickerVC.h"

@interface SynonymPickerVC ()
@property (nonatomic, strong) NSMutableArray *synonyms;
@end

@implementation SynonymPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self setPreferredContentSize:CGSizeMake(220, 210)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setSynonyms:(NSMutableArray *)synonyms {
    _synonyms = synonyms;
}

- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _synonyms.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _synonyms[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSDictionary *userInfo = @{@"selected" : _synonyms[row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectionNotification" object:nil userInfo:userInfo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
