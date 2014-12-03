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
    
    NSLog(@"%@", tappedWord);
}

//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    NSString *wordTapped = [self getWordAtPosition:point inTextView:_swipeArea];
//    NSLog(@"%@", wordTapped);
//}

- (NSString *) getWordAtPosition:(CGPoint)position inTextView:(UITextView *)textView {
    // eliminate scroll offset
    //position.y = textView.contentOffset.y;
    
    // get location
    UITextPosition *tapPos = [textView closestPositionToPoint:position];
    
    // get word at position
    UITextRange *range = [textView.tokenizer rangeEnclosingPosition:tapPos
                                                    withGranularity:UITextGranularityWord
                                                        inDirection:UITextLayoutDirectionRight];
    return [textView textInRange:range];
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
