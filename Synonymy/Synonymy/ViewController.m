//
//  ViewController.m
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "ViewController.h"
#import "Sentence.h"
#import "SynonymVC.h"

@interface ViewController()
@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) IBOutlet UIButton *enterArrow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    [_enterArrow addTarget:self action:@selector(onArrowTap) forControlEvents:UIControlEventTouchUpInside];
    [_textView becomeFirstResponder];
}

- (void) onArrowTap {
//    NSLog(@"merp tapped!");
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"synonymize"]) {
        Sentence *sentence = [[Sentence alloc] initWithSentence:_textView.text];
        
        SynonymVC *controller = (SynonymVC *) segue.destinationViewController;
        [controller setSentence:sentence];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
