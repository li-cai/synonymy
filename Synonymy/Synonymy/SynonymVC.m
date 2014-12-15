//
//  SynonymVC.m
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "SynonymVC.h"
#import "UIColor+Extensions.h"

NSString *THESAURUS_URL = @"http://words.bighugelabs.com/api/2/";
NSString *THESAURUS_URL_SUFFIX = @"/json";
NSString *THESAURUS_API_KEY = @"d7150974225ed0ec1fcecef0d3174367/";

@interface SynonymVC () {
    NSURLSession *_session;
}

@property (nonatomic, retain) IBOutlet UITextView *swipeArea;
@property (nonatomic, strong) Sentence *sentence;

@end

@implementation SynonymVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    _swipeArea.scrollEnabled = NO;
    [_swipeArea setText:_sentence.fullsentence];
    
    UISwipeGestureRecognizer *downswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    downswipe.direction = UISwipeGestureRecognizerDirectionDown;
    downswipe.delegate = self;
    [_swipeArea addGestureRecognizer:downswipe];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [singleTap setNumberOfTapsRequired:1];
    [_swipeArea addGestureRecognizer:singleTap];
}

// set current sentence displayed
- (void) setSentence:(Sentence *)sentence {
    _sentence = sentence;
}

- (void) onSwipe:(UISwipeGestureRecognizer *)recognizer {
    CGPoint swipePt = [recognizer locationInView:_swipeArea];
    
    UITextRange *textRange = [self getWordRangeAtPosition:swipePt inTextView:_swipeArea];
    NSRange range = [self rangeInTextView:_swipeArea textRange:textRange];
    NSString *swipedWord = [self getWordAtRange:textRange];
    
    if ([_sentence.origin valueForKey:swipedWord] == nil) {
        NSLog(@"hue");
        [self loadSynonymsOfWord:swipedWord inRange:range];
    }
    else {
        NSString *originalRange = [_sentence.origin valueForKey:swipedWord];
        
        [self swapWithSynonym:(NSString *)originalRange textRange:range];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//- (void) onSingleTap:(UITapGestureRecognizer *)recognizer {
//    CGPoint tapPt = [recognizer locationInView:_swipeArea];
//    
//    NSString *tappedWord = [self getWordAtPosition:tapPt inTextView:_swipeArea];
//    
//    [self loadSynonymsOfWord:tappedWord];

//}


// get range of the word at the given position in the given textview
- (UITextRange *) getWordRangeAtPosition:(CGPoint)position inTextView:(UITextView *)textView {
    // get location
    UITextPosition *tapPos = [textView closestPositionToPoint:position];\
    
    // get word at position
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPos
                                                        withGranularity:UITextGranularityWord
                                                            inDirection:UITextLayoutDirectionRight];
    return textRange;
}

// return the word at the given range
- (NSString *) getWordAtRange:(UITextRange *)textRange {
    return [_swipeArea textInRange:textRange];
}

- (void) swapWithSynonym:(NSString *)originalRange textRange:(NSRange)range {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_swipeArea.attributedText];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor grapefruitColor] range:range];
    
    NSNumber *num = [_sentence.syncount valueForKey:originalRange];
    int count = [num intValue];
    
    NSString *word = [_sentence.rangeToWord valueForKey:originalRange];
    NSMutableArray *synonyms = [_sentence.synonyms valueForKey:word];
    NSString *syn = synonyms[count];
    
    if (syn) {
        [_sentence.origin setValue:originalRange forKey:syn];
        
        if (syn == word) {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        }
        
        [string replaceCharactersInRange:range withString:syn];
        [_swipeArea setAttributedText:string];
        
        count++;
        if (count > synonyms.count - 1) {
            count = 0;
        }
        
        NSNumber *newNum = [NSNumber numberWithInt:count];
        [_sentence.syncount setValue:newNum forKey:originalRange];
    }
}

// helper method for converting UITextRange to NSRange
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
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor alizarinColor] range:range];
    
    [_swipeArea setAttributedText:string];
}


// loads synonyms of given word by querying API
- (void) loadSynonymsOfWord:(NSString *)word inRange:(NSRange)range {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableString *searchString = [NSMutableString string];
    [searchString appendString: THESAURUS_URL];
    [searchString appendString: THESAURUS_API_KEY];
    [searchString appendString: word];
    [searchString appendString: THESAURUS_URL_SUFFIX];
    
    NSURL *url = [NSURL URLWithString: searchString];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url
                                             completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error) {
                                                 //NSLog(@"data=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                 
                                                 if (!error) {
                                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                                                     
                                                     NSString *rangeSTR = NSStringFromRange(range);
                                                     [_sentence.rangeToWord setValue:word forKey:rangeSTR];
                                                     
                                                     if (httpResp.statusCode == 200) {
                                                         NSError *jsonError;
                                                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:NSJSONReadingMutableLeaves
                                                                                                                error:&jsonError];
                                                         if (!jsonError) {
                                                             NSMutableArray *temp = [NSMutableArray array];
                                                             [temp addObject:word];
                                                             for (id key in json) {
                                                                 [temp addObjectsFromArray:json[key][@"syn"]];
                                                                 [temp addObjectsFromArray:json[key][@"sim"]];
                                                             }
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                 
                                                                 [_sentence.synonyms setValue:temp forKey:word];
                                                                 [_sentence.syncount setValue:[NSNumber numberWithInt:1] forKey:rangeSTR];
                                                                 
                                                                 
                                                                 if (temp.count == 1) {
                                                                     [_sentence.origin setValue:rangeSTR forKey:word];
                                                                 }
                                                                 
                                                                 [self swapWithSynonym:rangeSTR textRange:range];
                                                             });
                                                         }
                                                     }
                                                     else {
                                                         [_sentence.origin setValue:rangeSTR forKey:word];
                                                         
                                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     }
                                                 }
                                             }];
    [dataTask resume];
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
