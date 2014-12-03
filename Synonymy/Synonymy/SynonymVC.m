//
//  SynonymVC.m
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "SynonymVC.h"

@interface SynonymVC ()
@property (nonatomic, retain) IBOutlet UITextView *swipeArea;
@property (nonatomic, strong) Sentence *sentence;
@end

@implementation SynonymVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [_swipeArea setText:_sentence.fullsentence];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    
    [singleTap setNumberOfTapsRequired:1];
    [_swipeArea addGestureRecognizer:singleTap];
}

- (void) onSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint tapPt = [recognizer locationInView:_swipeArea];
//    NSLog(@"%.2f %.2f", tapPt.x, tapPt.y);
    
    NSString *tappedWord = [self getWordAtPosition:tapPt inTextView:_swipeArea];
    //NSLog(@"%@", tappedWord);
    
    //NSRange wordRange = [_swipeArea.text rangeOfString:tappedWord];
    
    //[self colorWord:wordRange];
}

- (NSString *) getWordAtPosition:(CGPoint)position inTextView:(UITextView *)textView {
    // get location
    UITextPosition *tapPos = [textView closestPositionToPoint:position];
    
    // get word at position
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPos
                                                    withGranularity:UITextGranularityWord
                                                        inDirection:UITextLayoutDirectionRight];
    
    NSRange range = [self rangeInTextView:_swipeArea textRange:textRange];
    [self colorWord:range];
    
    return [textView textInRange:textRange];
}

- (NSRange) rangeInTextView:(UITextView *)textView textRange:(UITextRange *)txtRange {
    UITextPosition *beginning = textView.beginningOfDocument;
    
    UITextPosition *start = txtRange.start;
    UITextPosition *end = txtRange.end;
    
    const NSInteger location = [textView offsetFromPosition:beginning toPosition:start];
    const NSInteger length = [textView offsetFromPosition:start toPosition:end];
    
    return NSMakeRange(location, length);
}

- (void) colorWord:(NSRange)range {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_swipeArea.attributedText];
    
    UIColor *seaGreen = [UIColor colorWithRed:106.0/255 green:163.0/255 blue:106.0/255 alpha:1];
    [string addAttribute:NSForegroundColorAttributeName value:seaGreen range:range];
    
    [_swipeArea setAttributedText:string];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setSentence:(Sentence *)sentence {
    _sentence = sentence;
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
