//
//  ViewController.h
//  DZ 27 - Skut_Obj_TextField1
//
//  Created by mac on 26.12.17.
//  Copyright © 2017 Dima Zgera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    DZTextFieldFirstName,
    DZTextFieldLastName,
    DZTextFieldUserName,
    DZTextFieldPassword,
    DZTextFieldAge,
    DZTextFieldEmail,
    DZTextFieldPhoneNumber
    
}DZTextField;



@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allFields;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *allLabels;
@property (assign, nonatomic) BOOL atSymbolIsPossible;

- (IBAction)actionEditingChange:(UITextField *)sender;
- (IBAction)acitonClearAllButton:(UIButton *)sender;

@end

