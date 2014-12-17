//
//  SynonymVC.m
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "SynonymVC.h"
#import "SynonymPickerVC.h"
#import "UIColor+Extensions.h"
#import "DataStore.h"

NSString *THESAURUS_URL = @"http://words.bighugelabs.com/api/2/";
NSString *THESAURUS_URL_SUFFIX = @"/json";
NSString *THESAURUS_API_KEY = @"d7150974225ed0ec1fcecef0d3174367/";

@interface SynonymVC () {
    NSURLSession *_session;
    
    BOOL _isSwipe;
    BOOL _attrTextSet;
    BOOL _pickerDisplayed;
    
    NSRange _range;
    CGPoint _pressPt;
    
    NSMutableArray *_favorites;
    Favorite *_favorite;
    
    NSAttributedString *_attrText;
}

@property (nonatomic, retain) IBOutlet UITextView *swipeArea;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) Sentence *sentence;

@property (nonatomic) UIBarButtonItem *fav;
@property (nonatomic) UIBarButtonItem *unfav;

@end

@implementation SynonymVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _pickerDisplayed = NO;
    
    _swipeArea.scrollEnabled = NO;
    
    [_swipeArea setText:_sentence.fullsentence];
    
    if (_attrTextSet) {
        [_swipeArea setAttributedText:_attrText];
    }
    
    UISwipeGestureRecognizer *downswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    downswipe.direction = UISwipeGestureRecognizerDirectionDown;
    downswipe.delegate = self;
    [_swipeArea addGestureRecognizer:downswipe];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [singleTap setNumberOfTapsRequired:1];
    [_swipeArea addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [_swipeArea addGestureRecognizer:longPress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onSelectionNotification:)
                                                 name:@"SelectionNotification"
                                               object:nil];
    
    UIImage *favicon = [UIImage imageNamed:@"HeartIcon"];
    
    _fav = [[UIBarButtonItem alloc] initWithImage:favicon
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(favorite)];
    
    _unfav = [[UIBarButtonItem alloc] initWithImage:favicon
                                              style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(unfavorite)];
    
    _unfav.tintColor = [UIColor alizarinColor];
    
    if (_sentence.isFavorite) {
        self.navigationItem.rightBarButtonItem = _unfav;
    }
    else {
        self.navigationItem.rightBarButtonItem = _fav;
    }
    
    _favorites = [DataStore sharedStore].favorites;
}

// remove this VC from navigation stack
- (void) viewDidDisappear:(BOOL)animated {
    NSMutableArray *temp = [[NSMutableArray alloc]
                            initWithArray:self.navigationController.viewControllers];
    [temp removeLastObject];
    
    self.navigationController.viewControllers = temp;
}

// favorite this combo
- (void) favorite {
    _sentence.isFavorite = YES;
    _favorite = [[Favorite alloc] initWithSentence:_sentence attrText:_swipeArea.attributedText];
    
    [_favorites addObject:_favorite];
    
    self.navigationItem.rightBarButtonItem = _unfav;
}

// unfavorite
- (void) unfavorite {
    [_favorites removeObject:_favorite];
    
    self.navigationItem.rightBarButtonItem = _fav;
}

// reset when synonyms are changed
- (void) resetFav {
    self.navigationItem.rightBarButtonItem = _fav;
}

// set current sentence displayed
- (void) setSentence:(Sentence *)sentence {
    _sentence = sentence;
}

// handle long press by showing picker
- (void) onLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    _isSwipe = NO;
    
    _pressPt = [recognizer locationInView:_swipeArea];
    
    UITextRange *textRange = [self getWordRangeAtPosition:_pressPt inTextView:_swipeArea];
    _range = [self rangeInTextView:_swipeArea textRange:textRange];
    NSString *pressedWord = [self getWordAtRange:textRange];
    _sentence.currentword = pressedWord;
    
    if ([_sentence.origin valueForKey:pressedWord] == nil) {
        [self loadSynonymsOfWord:pressedWord inRange:_range textRange:textRange];
    }
    else {
        _sentence.originalrange = [_sentence.origin valueForKey:pressedWord];
        
        [self showSynonymPicker:_sentence.originalrange textRange:textRange];
    }
}

// on picker selection notification, replace with selection in textview
- (void) onSelectionNotification:(NSNotification *)notification {
    
    NSString *synonym = notification.userInfo[@"selected"];
    NSString *word = [_sentence.rangeToWord valueForKey:_sentence.originalrange];
    NSAttributedString *text = _swipeArea.attributedText;
    
    NSUInteger length = [text length];
    NSRange range = NSMakeRange(0, length);
    NSRange replace_range = NSMakeRange(0, 0);
    
    NSString *currentword = _sentence.currentword;
    NSString *originalrange= _sentence.originalrange;
    
    if (word && currentword && originalrange) {
        while (range.location != NSNotFound) {
            range = [[text string] rangeOfString:currentword options:0 range:range];
            
            if (range.location != NSNotFound) {
                replace_range = NSMakeRange(range.location, [currentword length]);
                range.location = NSNotFound;
                break;
            }
        }
        
        if (synonym) {
            [_sentence.origin setValue:originalrange forKey:synonym];
            
            [self swapWord:word withSyn:synonym range:replace_range];
            _sentence.currentword = synonym;
            
            NSArray *synonyms = [_sentence.synonyms valueForKey:word];
            NSUInteger index = [synonyms indexOfObject:synonym];
            index++;
        
            if (index > synonyms.count - 1) {
                index = 0;
            }
            
            NSNumber *newcount = [NSNumber numberWithInteger:index];
            [_sentence.syncount setValue:newcount forKey:_sentence.originalrange];
        }
    }
}

- (void) showSynonymPicker:(NSString *)originalRange textRange:(UITextRange *)textRange {
    
    NSString *word = [_sentence.rangeToWord valueForKey:originalRange];
    NSMutableArray *synonyms = [_sentence.synonyms valueForKey:word];
    CGRect wordRect = [_swipeArea firstRectForRange:textRange];
    
    if (synonyms != nil && !_pickerDisplayed) {
        _pickerDisplayed = YES;
        
        SynonymPickerVC *pickerVC = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"SynonymPicker"];
        [pickerVC setSynonyms:synonyms];
        
        NSUInteger pickindex = [synonyms indexOfObject:_sentence.currentword];
        [pickerVC setIndex:pickindex];
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:pickerVC];
        self.popover.delegate = self;
        
        [self.popover presentPopoverFromRect:wordRect inView:_swipeArea
                        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    _pickerDisplayed = NO;
}

- (void) onSwipe:(UISwipeGestureRecognizer *)recognizer {
    
    _isSwipe = YES;
    
    CGPoint swipePt = [recognizer locationInView:_swipeArea];
    
    UITextRange *textRange = [self getWordRangeAtPosition:swipePt inTextView:_swipeArea];
    NSRange range = [self rangeInTextView:_swipeArea textRange:textRange];
    NSString *swipedWord = [self getWordAtRange:textRange];
    
    if ([_sentence.origin valueForKey:swipedWord] == nil) {
        [self loadSynonymsOfWord:swipedWord inRange:range textRange:textRange];
    }
    else {
        _sentence.originalrange = [_sentence.origin valueForKey:swipedWord];
        
        NSString *word = [_sentence.rangeToWord valueForKey:_sentence.originalrange];
        NSString *synonym = [self getSynonym:_sentence.originalrange ofWord:word];
        
        [self swapWord:word withSyn:synonym range:range];
        
        _sentence.currentword = synonym;
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

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

- (void) swapWord:(NSString *)word withSyn:(NSString *)syn range:(NSRange)range {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_swipeArea.attributedText];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor grapefruitColor] range:range];
    
    if (syn) {
        
        if (syn == word) {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        }
        
        [string replaceCharactersInRange:range withString:syn];
        [_swipeArea setAttributedText:string];
        
        [self resetFav];
    }
}

- (NSString *) getSynonym:(NSString *)originalRange ofWord:(NSString *)word {
    NSNumber *num = [_sentence.syncount valueForKey:originalRange];
    int count = [num intValue];
    
    NSMutableArray *synonyms = [_sentence.synonyms valueForKey:word];
    NSString *syn = synonyms[count];
    
    if (syn) {
        [_sentence.origin setValue:originalRange forKey:syn];
        
        count++;
        if (count > synonyms.count - 1) {
            count = 0;
        }
        
        NSNumber *newNum = [NSNumber numberWithInt:count];
        [_sentence.syncount setValue:newNum forKey:originalRange];
    }
    
    return syn;
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

- (void) setAttrText:(NSAttributedString *)text {
    _attrText = text;
    _attrTextSet = YES;
}

- (void) setFavorite:(Favorite *)fav {
    _favorite = fav;
}


// loads synonyms of given word by querying API
- (void) loadSynonymsOfWord:(NSString *)word inRange:(NSRange)range textRange:(UITextRange *)textRange {
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
                                                             
                                                             NSMutableArray *newtemp = [NSMutableArray array];
                                                             
                                                             for (NSString *string in temp) {
                                                                 NSRange whiteSpaceRange = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
                                                                 if (whiteSpaceRange.location == NSNotFound) {
                                                                     [newtemp addObject:string];
                                                                 }
                                                             }
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                 
                                                                 [_sentence.synonyms setValue:newtemp forKey:word];
                                                                 
                                                                 if (newtemp.count == 1) {
                                                                     [_sentence.origin setValue:rangeSTR forKey:word];
                                                                 }
                                                                 
                                                                 if (_isSwipe) {
                                                                     [_sentence.syncount setValue:[NSNumber numberWithInt:1] forKey:rangeSTR];
                                                                     
                                                                     NSString *word = [_sentence.rangeToWord valueForKey:rangeSTR];
                                                                     NSString *synonym = [self getSynonym:rangeSTR ofWord:word];
                                                                     
                                                                     [self swapWord:word withSyn:synonym range:range];
                                                                 }
                                                                 else {
                                                                     _sentence.originalrange = rangeSTR;
                                                                     [self showSynonymPicker:rangeSTR textRange:textRange];
                                                                 }
                                                                 
                                                                 _sentence.currentword = word;
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
