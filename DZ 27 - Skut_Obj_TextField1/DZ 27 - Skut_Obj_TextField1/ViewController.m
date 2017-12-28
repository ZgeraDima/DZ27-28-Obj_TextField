//
//  ViewController.m
//  DZ 27 - Skut_Obj_TextField1
//
//  Created by mac on 26.12.17.
//  Copyright © 2017 Dima Zgera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UITextField *field in self.allFields) {
        field.delegate = self;
        
        if (field.tag == DZTextFieldFirstName) {
            [field becomeFirstResponder];
        }
        self.atSymbolIsPossible = TRUE;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    //Allow to insert @ symbol to the Email textField after clear button called
    if (textField.tag == DZTextFieldEmail) {
        self.atSymbolIsPossible = TRUE;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger currentFieldIndex = [self.allFields indexOfObject:textField];
    NSInteger lastFieldIndex = [self.allFields indexOfObject:[self.allFields lastObject]];
    
    if (currentFieldIndex != lastFieldIndex) {
        UITextField *nextField = [self.allFields objectAtIndex:++currentFieldIndex];
        [nextField becomeFirstResponder];
        
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL changeOrNo = YES;
    
    if (textField.tag == DZTextFieldPhoneNumber) {
        
        changeOrNo = [self checkPhoneTextField:textField inRange:range replacementString:string];
        
    } else if (textField.tag == DZTextFieldAge) {
        
        changeOrNo = [self checkAgeTextField:textField inRange:range replacementString:string];
        
    } else if (textField.tag == DZTextFieldEmail) {
        
        changeOrNo = [self checkEmailTextField:textField inRange:range replacementString:string];
    }
    
    return changeOrNo;
}

#pragma mark - Actions

- (IBAction)actionEditingChange:(UITextField *)sender {
    
    UILabel * currentLabel = [self.allLabels objectAtIndex:[self.allFields indexOfObject:sender]];
    currentLabel.text = sender.text;
    
}

- (IBAction)acitonClearAllButton:(UIButton *)sender {
    
    for (UITextField *field in self.allFields) {
        
        field.text = @"";
        
        //Allow to insert "@" symbol to the EmailField after clear button called
        if (field.tag == DZTextFieldEmail) {
            self.atSymbolIsPossible = TRUE;
        } else if (field.tag == DZTextFieldFirstName) {
            [field becomeFirstResponder];
        }
    }
    
    for (UILabel *label in self.allLabels) {
        label.text = @"";
    }
}

#pragma mark - Methods for UITextFieldDelegate

- (BOOL) checkPhoneTextField:(UITextField*) textField inRange:(NSRange)range replacementString:(NSString*)string {
    
    NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return NO;
    }
    
    NSMutableString *resultString = [NSMutableString string];
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberMaxLength > 0) {
        
        NSString *number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN([newString length] - localNumberMaxLength, areaCodeMaxLength);
        NSRange areaRange = NSMakeRange([newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        NSString *area = [newString substringWithRange:areaRange];
        area = [NSString stringWithFormat:@"(%@)",area];
        [resultString insertString:area atIndex:0];
    }
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        NSInteger countryCodeLength = MIN([newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        NSRange countryRange = NSMakeRange(0, countryCodeLength);
        NSString *countryCode = [newString substringWithRange:countryRange];
        countryCode = [NSString stringWithFormat:@"+%@", countryCode];
        [resultString insertString:countryCode atIndex:0];
        
    }
    
    textField.text = resultString;
    UILabel *currentLabel = [self.allLabels objectAtIndex:[self.allFields indexOfObject:textField]];
    currentLabel.text = resultString;
    
    return NO;
}

- (BOOL) checkAgeTextField:(UITextField*)textField inRange:(NSRange)range replacementString:(NSString*)string {
    
    NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return [resultString length] <= 3;
}

- (BOOL) checkEmailTextField: (UITextField*) textField inRange:(NSRange)range replacementString:(NSString*)string {
    
    NSMutableString *badSymbols = [[NSMutableString alloc]initWithString:@"|!#=][}{$%^&*()+,/\?~`;:"];
    NSCharacterSet *validationSet = [NSCharacterSet characterSetWithCharactersInString:badSymbols];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
        
    } else if (textField.text.length == 0 && [string isEqualToString:@"@"]) {
        return NO;
        
    } else if ([string isEqualToString:@"@"] && self.atSymbolIsPossible) {
        self.atSymbolIsPossible = FALSE;
        
    } else if ([string isEqualToString:@"@"] && !self.atSymbolIsPossible) {
        return NO;
    }
    
    return  YES;
}


@end
