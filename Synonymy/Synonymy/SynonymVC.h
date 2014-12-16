//
//  SynonymVC.h
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sentence.h"

@interface SynonymVC : UIViewController<UIGestureRecognizerDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate>

- (void) setSentence:(Sentence *)sentence;
- (void) setAttrText:(NSAttributedString *)text;

@end
