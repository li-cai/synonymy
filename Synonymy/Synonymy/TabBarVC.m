//
//  TabBarVC.m
//  Synonymy
//
//  Created by Student on 12/12/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "TabBarVC.h"

@interface TabBarVC ()
@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews {
    CGFloat tabBarHeight = 60.0;
    CGRect frame = self.view.frame;
    self.tabBar.frame = CGRectMake(0, frame.size.height - tabBarHeight, frame.size.width, tabBarHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
