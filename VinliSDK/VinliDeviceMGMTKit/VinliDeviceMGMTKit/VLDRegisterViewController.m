//
//  VLDRegisterViewController.m
//  VinliDeviceMGMTKit
//
//  Created by Bryan on 2/21/17.
//  Copyright © 2017 vinli. All rights reserved.
//

#import "VLDRegisterViewController.h"

#import "UIFont+VLAdditions.h"
#import "UIColor+VLAdditions.h"
#import "UIViewController+VLStyleAdditions.h"

#import "VLActionButton.h"
#import "VLClearActionButton.h"
#import "VLTextField.h"
#import "VLActivityIndicatorView.h"

#import "VLService+Private.h"

#import "UIFont+VLAdditions.h"
#import "UIColor+VLAdditions.h"

@interface VLDRegisterViewController () <VLTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet VLActionButton *registerDeviceActionButton;
@property (weak, nonatomic) IBOutlet VLClearActionButton *skipRegistrationClearActionButton;

@property (weak, nonatomic) IBOutlet UIView *textFieldsContainerView;
@property (strong, nonatomic) NSArray *textFields;

@property (strong, nonatomic) NSString* caseId;

@property (strong, nonatomic) NSCharacterSet* invalidCharacters;

@property (strong, nonatomic) UITextField *theActiveTextField;

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) VLService *service;

@end

@implementation VLDRegisterViewController

#pragma mark - Getters and Setters

- (NSCharacterSet *)invalidCharacters {
    if (!_invalidCharacters) {
        _invalidCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    }
    return _invalidCharacters;
}

#pragma mark - Class Methods

+ (instancetype)initFromStoryboard
{
    VLDRegisterViewController *instance = [[UIStoryboard storyboardWithName:@"VLDRegisterViewController" bundle:[NSBundle bundleForClass:[VLDRegisterViewController class]]] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDRegisterViewController class])];
    
    return instance;
}

+ (instancetype)initFromStoryboardWithAccessToken:(NSString *)accessToken
{
    VLDRegisterViewController *instance = [[UIStoryboard storyboardWithName:@"VLDRegisterViewController" bundle:[NSBundle bundleForClass:[VLDRegisterViewController class]]] instantiateViewControllerWithIdentifier:NSStringFromClass([VLDRegisterViewController class])];
    
    instance.accessToken = accessToken;
    instance.service = [[VLService alloc] initWithAccessToken:instance.accessToken];
//    instance.service.host = @"-dev.vin.li";
    
    return instance;
}

#pragma mark - View Controllers

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleText:NSLocalizedString(@"REGISTER YOUR DEVICE", @"")];

    // set default text
    [self.titleLabel setFont:[UIFont vl_OpenSans_Bold:22.0f]];
    [self.titleLabel setTextColor:[UIColor vl_ServicesGreyLabelColor]];
    [self.titleLabel setText:NSLocalizedString(@"Register Your Device", @"")];
    [self.detailLabel setFont:[UIFont vl_OpenSans:14.0f]];
    [self.detailLabel setTextColor:[UIColor vl_ServicesGreyLabelColor]];
    [self.detailLabel setText:NSLocalizedString(@"Enter the 7-digit code found on the back of your device.", @"")];
    
    [self.registerDeviceActionButton setTitle:NSLocalizedString(@"REGISTER DEVICE", @"") forState:UIControlStateNormal];
    
    [self.skipRegistrationClearActionButton setTitle:NSLocalizedString(@"Skip Registration", @"") forState:UIControlStateNormal];
    
    // initialize Data Model
    NSMutableArray *mutableTextFieldsArray = [NSMutableArray new];
    for (UIView *aSubview in self.textFieldsContainerView.subviews)
    {
        if ([aSubview isKindOfClass:[UITextField class]])
        {
            UITextField *aTextField = (UITextField *)aSubview;
            [aTextField setDelegate:self];
            [aTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
            if (aTextField) {
                [mutableTextFieldsArray addObject:aTextField];
            }
        }
    }
    self.textFields = [NSArray arrayWithArray:mutableTextFieldsArray];
    
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

#pragma mark - Network Calls

#pragma mark - Actions

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)skipRegistrationAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCancelRegistration)])
    {
        [self.delegate didCancelRegistration];
    }
}

- (IBAction)registerDeviceAction:(id)sender
{
    if ([self caseIdIsValid])
    {
        VLActivityIndicatorView *activityIndicator = [[VLActivityIndicatorView alloc] init];
        [activityIndicator addActivityIndicatorToView:self.view];
        weakify(self)
        NSMutableString *mutableCaseId = [NSMutableString new];
        for (UITextField *aTextField in self.textFields)
        {
            [mutableCaseId appendString:aTextField.text];
        }
        self.caseId = [NSString stringWithString:[mutableCaseId uppercaseString]];
        
        
        [self checkIfDeviceIsClaimed:^(BOOL isClaimed, BOOL isMeinekeSelfServiceFlow, NSError* error) {
            [activityIndicator removeFromSuperview];
            strongify(self)
            if (error)
            {
                if ([self.delegate respondsToSelector:@selector(didFailToRegisterDevice:)])
                {
                    [self.delegate didFailToRegisterDevice:error];
                }
                return;
            }
            
            if (!isClaimed && isMeinekeSelfServiceFlow)
            {
                if ([self.delegate respondsToSelector:@selector(didRegisterDeviceWithCaseId:)])
                {
                    [self.delegate didRegisterDeviceWithCaseId:self.caseId];
                }
                return;
            }
            else if (isClaimed)
            {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey : NSLocalizedString(@"Device Registration Failure", @""),
                                           NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Device is already claimed for another account.", @""),
                                           NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Make sure the user has entered the correct caseId.", @"")
                                           };
                NSError *customError = [NSError errorWithDomain:NSURLErrorDomain code:409 userInfo:userInfo];
                if ([self.delegate respondsToSelector:@selector(didFailToRegisterDevice:)])
                {
                    [self.delegate didFailToRegisterDevice:customError];
                }
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(didFailToRegisterDevice:)])
                {
                    [self.delegate didFailToRegisterDevice:nil];
                }
            }
        }];
    }
}

#pragma mark - Validation Helpers

- (BOOL)caseIdIsValid
{
    for (UITextField *aTextField in self.textFields)
    {
        if (aTextField.text.length == 0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Validation Error", @"") message:NSLocalizedString(@"It seems there has been an error validating your device's case ID. Make sure that you have entered a valid character in each of the text fields.", @"") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"") style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:dismissAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
    }
    
    return YES;
}

- (void)checkIfDeviceIsClaimed:(void(^)(BOOL isClaimed, BOOL isMeinekeSelfServiceFlow, NSError *error))completion
{
    [self.service checkToSeeIfDeviceIsClaimedByCaseId:self.caseId success:^(NSDictionary *claimedDict, NSHTTPURLResponse *response) {
        
        if (completion) {
            BOOL retClaimedBOOL = [claimedDict[@"claimed"] boolValue];
            BOOL retIsMeinekeSelfServicePlan = [claimedDict[@"isMeinekeSelfService"] boolValue];
            
            completion(retClaimedBOOL, retIsMeinekeSelfServicePlan, nil);
        }

        
    } failure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        
        if (error)
        {
            if (completion)
            {
                completion(NO, NO, error);
            }
        }
    }];
}


#pragma mark - TextField Helpers

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

#pragma mark - TextField Delegate Methods

- (BOOL)textIsAlphaNumeric:(NSString *)text {
    return ([text rangeOfCharacterFromSet:self.invalidCharacters].location == NSNotFound);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.theActiveTextField = textField;
    self.theActiveTextField.text = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0)
    {
        if (textField.text.length > 0)
        {
            return NO;
        }
        
        // validate only alphanumeric
        if (![self textIsAlphaNumeric:string]) {
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

- (void)textFieldDidEmptyBackspace:(UITextField *)textField
{
    if ([self getPreviousTextFieldFromCurrentTextField:textField])
    {
        UITextField* previousTextField = [self getPreviousTextFieldFromCurrentTextField:textField];
        previousTextField.text = @"";
        [previousTextField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [self dismissKeyboard];
    }
    
    return YES;
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications
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

- (void)keyboardWillBeShown:(NSNotification *)aNotification
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
