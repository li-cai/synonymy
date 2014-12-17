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
#import "DataStore.h"
#import "History.h"

@interface ViewController()
@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) IBOutlet UIButton *enterArrow;
@property (nonatomic, strong) NSMutableArray *history;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.

    _textView.delegate = self;
    
    _history = [DataStore sharedStore].history;
    
    [_textView setClearsOnInsertion:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"synonymize"] && ![_textView.text isEqual: @""]
        && _textView.text != nil) {
        
        Sentence *sentence = [[Sentence alloc] initWithSentence:_textView.text];
        History *hist = [[History alloc] initWithSentence:sentence.fullsentence];
        History *last = [_history lastObject];
        
        if (![last.sentence isEqual:_textView.text]) {
            [_history addObject:hist];
        }
        
        SynonymVC *controller = (SynonymVC *) segue.destinationViewController;
        [controller setSentence:sentence];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return textView.text.length + (text.length - range.length) <= 120;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
