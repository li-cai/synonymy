//
//  SynonymVC.m
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "SynonymVC.h"

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
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    swipe.delegate = self;
    
    [_swipeArea addGestureRecognizer:swipe];
    
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    
    //[singleTap setNumberOfTapsRequired:1];
    //[_swipeArea addGestureRecognizer:singleTap];
}

- (void) onSwipe:(UISwipeGestureRecognizer *)recognizer {
    CGPoint swipePt = [recognizer locationInView:_swipeArea];
    NSString *swipedWord = [self getWordAtPosition:swipePt inTextView:_swipeArea];
    //NSLog(@"%@", swipedWord);
    
    if ([_sentence.synonyms valueForKey:swipedWord] == nil) {
        [self loadSynonymsOfWord:swipedWord];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

- (void) onSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint tapPt = [recognizer locationInView:_swipeArea];
    
    NSString *tappedWord = [self getWordAtPosition:tapPt inTextView:_swipeArea];
    
    [self loadSynonymsOfWord:tappedWord];
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

- (void) loadSynonymsOfWord:(NSString *)word {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableString *searchString = [NSMutableString string];
    [searchString appendString: THESAURUS_URL];
    [searchString appendString: THESAURUS_API_KEY];
    [searchString appendString: word];
    [searchString appendString: THESAURUS_URL_SUFFIX];
    
    //NSLog(@"%@", searchString);
    
    NSURL *url = [NSURL URLWithString: searchString];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url
                                             completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error) {
                                                 //NSLog(@"data=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                 
                                                 if (!error) {
                                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
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
                                                                 
                                                                 [_sentence addSynonyms:temp ofWord:word];
                                                                 
                                                                 NSLog(@"%@", _sentence.synonyms[@"pale"]);
                                                             });
                                                         }
                                                     }
                                                 }
                                             }];
    [dataTask resume];
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
