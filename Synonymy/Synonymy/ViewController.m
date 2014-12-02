//
//  ViewController.m
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) IBOutlet UIButton *enterArrow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_enterArrow addTarget:self action:@selector(onArrowTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void) onArrowTap {
    NSLog(@"merp tapped!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
