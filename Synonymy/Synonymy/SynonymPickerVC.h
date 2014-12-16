//
//  SynonymPickerVC.h
//  Synonymy
//
//  Created by Student on 12/14/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SynonymPickerVC : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) IBOutlet UIPickerView *pickerView;

- (void) setSynonyms:(NSMutableArray *)synonyms;

@end
