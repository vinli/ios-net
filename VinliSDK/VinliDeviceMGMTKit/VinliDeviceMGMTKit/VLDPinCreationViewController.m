//
//  VLDPinCreationViewController.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/28/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDPinCreationViewController.h"

#import "VLTextField.h"
#import "VLActionButton.h"
#import "VLClearActionButton.h"

#import "UIColor+VLAdditions.h"
#import "UIFont+VLAdditions.h"
#import "UIViewController+VLStyleAdditions.h"

#import "VLService+Private.h"

#import "UIFont+VLAdditions.h"
#import "UIColor+VLAdditions.h"

@interface VLDPinCreationViewController () <VLTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *createPINTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createPINDetailLabel;

@property (strong, nonatomic) IBOutletCollection(VLTextField) NSArray *textFields;
@property (strong, nonatomic) UITextField *theActiveTextField;

@property (strong, nonatomic) NSString *pin;
@property (strong, nonatomic) NSString *caseId;

@property (weak, nonatomic) IBOutlet VLActionButton *continueActionButton;
@property (weak, nonatomic) IBOutlet VLClearActionButton *finishSetupLaterClearActionButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) VLService *service;

@end

@implementation VLDPinCreationViewController

#pragma mark - Class Methods

+ (instancetype)initFromStoryboard
{
    VLDPinCreationViewController *instance = [[UIStoryboard storyboardWithName:@"VLDPinCreationViewController" bundle:[NSBundle bundleForClass:[VLDPinCreationViewController class]]] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDPinCreationViewController class])];
    
    return instance;
}

+ (instancetype)initFromStoryboardWithAccessToken:(NSString *)accessToken andCaseId:(NSString *)caseId
{
    VLDPinCreationViewController *instance = [[UIStoryboard storyboardWithName:@"VLDPinCreationViewController" bundle:[NSBundle bundleForClass:[VLDPinCreationViewController class]]] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDPinCreationViewController class])];
    
    instance.caseId = caseId;
    
    instance.accessToken = accessToken;
    instance.service = [[VLService alloc] initWithAccessToken:instance.accessToken];
//    instance.service.host = @"-dev.vin.li";
    
    return instance;
}

- (void)configureTextFields
{
    for (VLTextField *aTextField in self.textFields)
    {
        [aTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [aTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
        [doneBarButtonItem setTintColor:[UIColor vl_BlueColor]];
        [numberToolbar setItems:@[doneBarButtonItem]];
        
        [aTextField setInputAccessoryView:numberToolbar];
        
        [aTextField setDelegate:self];
    }
}

- (BOOL)isPinValid
{
    BOOL retBOOL = YES;
    for (VLTextField *aTextField in self.textFields)
    {
        if (aTextField.text.length == 0 &&
            [aTextField.text isEqualToString:@""])
        {
            retBOOL = NO;
            break;
        }
    }
    
    return retBOOL;
}

- (void)presentErrorAlertController
{
    UIAlertController *replacementErrorAC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ACTIVATION ERROR", @"#bc-ignore!") message:NSLocalizedString(@"There seems to have been an error while trying to activate your device. Make sure that you are properly connected to the internet and try again.", @"#bc-ignore!") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"#bc-ignore!") style:UIAlertActionStyleDefault handler:nil];
    
    [replacementErrorAC addAction:okAction];
    
    [self presentViewController:replacementErrorAC animated:YES completion:nil];
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleText:NSLocalizedString(@"CREATE PIN", @"#bc-ignore!")];
    
    [self configureTextFields];
    
    [self.createPINTitleLabel setFont:[UIFont vl_OpenSans:27.0f]];
    [self.createPINTitleLabel setTextColor:[UIColor colorFromRedVal:31.0f greenVal:51.0f blueVal:64.0f andAlpha:1.0f]];
    [self.createPINTitleLabel setText:NSLocalizedString(@"Create a PIN", @"#bc-ignore!")];
    
    [self.createPINDetailLabel setFont:[UIFont vl_OpenSans:15.0f]];
    [self.createPINDetailLabel setTextColor:[UIColor colorFromRedVal:90.0f greenVal:105.0f blueVal:115.0f andAlpha:1.0f]];
    [self.createPINDetailLabel setText:NSLocalizedString(@"Select a 4 digit PIN for your device activation. This will be used for managing your network service.", @"#bc-ignore!")];
    
    [self.continueActionButton setTitle:NSLocalizedString(@"Continue", @"#bc-ignore!") forState:UIControlStateNormal];
    [self.finishSetupLaterClearActionButton setTitle:NSLocalizedString(@"Finish Setup Later", @"#bc-ignore!") forState:UIControlStateNormal];
    
    // add gesture reconginzer to dismiss the keyboard
    UITapGestureRecognizer *dismissKeyboardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboardGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self dismissKeyboard];
}

#pragma mark - Actions

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)continueAction:(id)sender
{
    if (![self isPinValid])
    {
        // Error
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey : NSLocalizedString(@"Pin Creation Failure", @""),
                                   NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Pin did not meet the criteria for a validation.", @""),
                                   NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Make sure pin has numeric values only and that is at least has four digits.", @"")
                                   };
        NSError *customError = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:userInfo];
        
        if ([self.delegate respondsToSelector:@selector(pinEntryDidFail:)])
        {
            [self.delegate pinEntryDidFail:customError];
        }
        
        UIAlertController *replacementErrorAC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ACTIVATION ERROR", @"#bc-ignore!") message:NSLocalizedString(@"You have not entered a valid PIN. Make sure you have entered a four digit pin and hit continue.", @"#bc-ignore!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"#bc-ignore!") style:UIAlertActionStyleDefault handler:nil];
        
        [replacementErrorAC addAction:okAction];
        
        [self presentViewController:replacementErrorAC animated:YES completion:nil];
        return;
    }
    
    NSMutableString *mutablePin = [NSMutableString new];
    for (VLTextField *aTextField in self.textFields)
    {
        [mutablePin appendString:aTextField.text];
    }
    
    self.pin = [NSString stringWithString:mutablePin];
    
    if ([self.delegate respondsToSelector:@selector(pinEntryWasSuccessfulWithPin:andCaseId:)])
    {
        [self.delegate pinEntryWasSuccessfulWithPin:self.pin andCaseId:self.caseId];
    }
}

- (IBAction)finishSetupLaterAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCancelPinEntry)])
    {
        [self.delegate didCancelPinEntry];
    }
}

- (void)handleFinishLaterForAddDeviceFlow {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SETUP ERROR", @"#bc-ignore!") message:NSLocalizedString(@"Your device will not be available until you finish the activation process on the T-Mobile ConnectMe website.", @"#bc-ignore!") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", @"#bc-ignore!") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"#bc-ignore!") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createActivationURL:(void(^)(NSURL *activationURL, NSError *error))completion
{
    if (self.pin.length == 0 || self.caseId.length == 0)
    {
        if (completion)
        {
            completion(nil, nil);
        }
        return;
    }
    
    [self.service activateDeviceWithCaseId:self.caseId pin:self.pin success:^(NSDictionary *activationDict, NSHTTPURLResponse *response) {
        NSURL* activationURL;
        NSError* error;
        if ([activationDict[@"externalLink"][@"link"] isKindOfClass:[NSString class]])
        {
            activationURL = [NSURL URLWithString:activationDict[@"externalLink"][@"link"]];
        }
        else
        {
            error = [NSError errorWithDomain:@"VinliUnexpectedResult" code:-101 userInfo:@{@"message" : @"No external link was returned"}];
        }
        
        if (completion) { completion(activationURL, error); }
    } failure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        if (completion) { completion(nil, error); }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0)
    {
        if (textField.text.length > 0)
        {
            return NO;
        }
        
        // go to next text field
        
        if ([self getNextTextFieldThatIsEmpty:textField])
        {
            UITextField *nextTextField = [self getNextTextFieldThatIsEmpty:textField];
            textField.text = string;
            [nextTextField becomeFirstResponder];
            return NO;
        }
        else
        {
            textField.text = string;
            [self.view endEditing:YES];
            return NO;
        }
    }
    else
    {
        // go to previous text field
        if (textField.text.length > 0)
        {
            textField.text = string;
            return NO;
        }
        else
        {
            UITextField *previousTextField = [self getPreviousTextFieldFromCurrentTextField:textField];
            textField.text = string;
            [previousTextField becomeFirstResponder];
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.theActiveTextField = textField;
    self.theActiveTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [self dismissKeyboard];
    }
    
    return YES;
}

#pragma mark - VLTextFieldDelegate

- (void)textFieldDidEmptyBackspace:(UITextField *)textField
{
    if ([self getPreviousTextFieldFromCurrentTextField:textField])
    {
        UITextField* previousTextField = [self getPreviousTextFieldFromCurrentTextField:textField];
        previousTextField.text = @"";
        [previousTextField becomeFirstResponder];
    }
}

#pragma mark - Text Field Helpers

- (UITextField *)getNextTextFieldFromCurrentTextField:(UITextField *)currentTextField
{
    if ([self.textFields containsObject:currentTextField])
    {
        NSInteger indexOfLastTextField = self.textFields.count - 1;
        NSInteger indexOfCurrentTextField = [self.textFields indexOfObject:currentTextField];
        if (indexOfCurrentTextField < indexOfLastTextField)
        {
            // get next text field
            return [self.textFields objectAtIndex:indexOfCurrentTextField + 1];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

- (UITextField *)getPreviousTextFieldFromCurrentTextField:(UITextField *)currentTextField
{
    if ([self.textFields containsObject:currentTextField])
    {
        NSInteger indexOfFirstTextField = 0;
        NSInteger indexOfCurrentTextField = [self.textFields indexOfObject:currentTextField];
        if (indexOfFirstTextField != indexOfCurrentTextField)
        {
            // get next text field
            return [self.textFields objectAtIndex:indexOfCurrentTextField - 1];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

- (UITextField *)getNextTextFieldThatIsEmpty:(UITextField *)currentTextField
{
    if (!currentTextField)
    {
        return nil;
    }
    
    UITextField *nextTextField = [self getNextTextFieldFromCurrentTextField:currentTextField];
    if (!nextTextField)
    {
        return nil;
    }
    else if (nextTextField && nextTextField.text.length == 0)
    {
        return nextTextField;
    }
    else
    {
        return [self getNextTextFieldThatIsEmpty:nextTextField];
    }
}

#pragma mark - Keyboard

-(void)registerForKeyboardNotifications
{
    // Custom handling of keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    self.scrollView.contentOffset         = CGPointZero;
    self.scrollView.contentInset          = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)keyboardWillBeShown:(NSNotification *)aNotification
{
    UIScrollView *theTablesScrollView = (UIScrollView *)self.scrollView;
    CGRect scrollViewRect = [self.view convertRect:theTablesScrollView.frame fromView:theTablesScrollView.superview];
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGRect hiddenScrollViewRect = CGRectIntersection(scrollViewRect, keyboardRect);
    if (!CGRectIsNull(hiddenScrollViewRect))
    {
        UIEdgeInsets contentInsets       = UIEdgeInsetsMake(0.0,  0.0, hiddenScrollViewRect.size.height,  0.0);
        theTablesScrollView.contentInset          = contentInsets;
        theTablesScrollView.scrollIndicatorInsets = contentInsets;
    }
    
    [self scrollToActiveTextField];
}

- (void)scrollToActiveTextField
{
    if (self.theActiveTextField.isFirstResponder)
    {
        UITextField *activeTextObject = self.theActiveTextField;
        CGRect visibleRect = activeTextObject.frame;
        visibleRect        = [self.scrollView convertRect:visibleRect fromView:activeTextObject.superview];
        visibleRect        = CGRectInset(visibleRect, 0.0f, 0.0f);
        
        [self.scrollView scrollRectToVisible:visibleRect animated:YES];
    }
}

@end
