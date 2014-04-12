//
//  CompleteViewController.m
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "CompleteViewController.h"
#import "RDActionSheet.h"
#import "NonRotateImagePickerController.h"
#import "ImageHelper.h"
#import "ImageCropper.h"
#import <QuartzCore/QuartzCore.h>

static CompleteViewController *_completeSharedInstance = nil;

@interface CompleteViewController () {
    UIResponder *currentResponder;
}

@property (nonatomic, strong) IBOutlet UIButton *btnImg;
@property (nonatomic, strong) IBOutlet UILabel *lblHint;
@property (nonatomic, strong) IBOutlet UITextView *textNote;
@property (nonatomic, strong) IBOutlet UILabel *lblPlaceholder;

+ (CompleteViewController *) sharedInstance;

@end

@implementation CompleteViewController

+ (CompleteViewController *) sharedInstance
{
    return _completeSharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _completeSharedInstance = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tap];
    
    self.textNote.layer.borderColor = [[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0] CGColor];
    self.textNote.layer.borderWidth = 1.0f;
    self.textNote.layer.cornerRadius = 5.0;
    self.textNote.layer.shadowColor = [UIColor blackColor].CGColor;
    self.textNote.layer.shadowRadius = 5.0;
    self.textNote.layer.shadowOffset = CGSizeMake(2.0, 2.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTakePhotoClicked:(id)sender
{
    
    if (currentResponder)
    {
		[currentResponder resignFirstResponder];
	}
    
    RDActionSheet *actionSheet = [RDActionSheet alloc];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet initWithCancelButtonTitle:@"Cancel"
                            primaryButtonTitle:nil
                            destroyButtonTitle:nil
                             otherButtonTitles:@"Select Photo", @"Take Picture",                        nil];
    }
    else {
        [actionSheet initWithCancelButtonTitle:@"Cancel"
                            primaryButtonTitle:nil
                            destroyButtonTitle:nil
                             otherButtonTitles:@"Select Photo",nil];
    }
    actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex) {
        
        switch (result) {
            case RDActionSheetButtonResultSelected:
            {
                NSLog(@"Pressed %i", buttonIndex);
                
                UIImagePickerController *picker = [[NonRotateImagePickerController alloc] init];
                picker.delegate = [CompleteViewController sharedInstance];
                picker.allowsEditing = YES;
                
                if (buttonIndex == 0)
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                else
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                    //picker.modalInPopover = YES;
                    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
                    popover.delegate = [CompleteViewController sharedInstance];
                    [popover presentPopoverFromRect:CGRectMake(90, 150, 270, 300)
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionLeft
                                           animated:YES];
                    //[popover setPopoverContentSize:CGSizeMake(500, 500)];
                } else {
                    [self presentViewController:picker animated:YES completion:nil];
                }
                break;
            }
            case RDActionSheetResultResultCancelled:
                NSLog(@"Sheet cancelled");
                break;
        }
    };
    [actionSheet showFrom:self.view];
}

///////////////////////////////////////////////////////////////////
#pragma mark - Image Picker Callbacks

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	//GameConfig *config = [Config sharedConfig].gameConfig;
    
    UIImage *srcImage = [info objectForKey:UIImagePickerControllerEditedImage];
	UIImage *orgImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (srcImage == nil)
        srcImage = orgImage;
    
    UIImage *image = [srcImage imageByScalingAndCroppingForSize:CGSizeMake(640, 640)];
    
    if (image != nil)
    {
        //[ResManager SetPlayerImage:config.nId Image:image];
        
        //image = [ResManager GetPlayerImage:config.nId];
        //config.imgPhoto = image;
        //imgPhoto.image = image;
        //bPhoto = YES;
        [self.btnImg setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
	{
		//showAlert(STRING_DATAMANAGER_PHOTOSIZE);
        //[AutoMessageBox AutoMsgInView:self withText:@"Picker Error!" withSuccess:FALSE];
	}
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

#pragma mark - Gesture
- (void)backgroundTap:(UITapGestureRecognizer *)backgroundTap {
    if(currentResponder){
        [currentResponder resignFirstResponder];
    }
}

#pragma mark - view methods for keyboard
- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShowing:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHiding:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Keyboard Methods

- (void)keyboardShowing:(NSNotification *)note
{
    
    NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGRect endFrame = ((NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    CGRect rtNote = self.textNote.frame;
    rtNote.origin.y -= endFrame.size.height;
    CGRect rtPlaceholder = self.lblPlaceholder.frame;
    rtPlaceholder.origin.y -= endFrame.size.height;
    
     [UIView animateWithDuration:duration.floatValue animations:^{
         self.btnImg.alpha = 0.0;
         self.lblHint.alpha = 0.0;
         self.textNote.frame = rtNote;
         self.lblPlaceholder.frame = rtPlaceholder;
     } completion:^(BOOL completed){
         self.btnImg.hidden = YES;
         self.lblHint.hidden = YES;
     }];
}

- (void)keyboardHiding:(NSNotification *)note
{
    NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGRect endFrame = ((NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    CGRect rtNote = self.textNote.frame;
    rtNote.origin.y += endFrame.size.height;
    CGRect rtPlaceholder = self.lblPlaceholder.frame;
    rtPlaceholder.origin.y += endFrame.size.height;

    
    [UIView animateWithDuration:duration.floatValue animations:^{
        self.btnImg.hidden = NO;
        self.lblHint.hidden = NO;
        self.btnImg.alpha = 1.0;
        self.lblHint.alpha = 1.0;
        self.textNote.frame = rtNote;
        self.lblPlaceholder.frame = rtPlaceholder;
    }];
    
}

#pragma mark UITextViewDelegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    currentResponder = textView;
    }
- (void)textViewDidEndEditing:(UITextView *)textView {
    currentResponder = nil;
    if (![textView hasText])
        self.lblPlaceholder.hidden = NO;

}


- (void) textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        self.lblPlaceholder.hidden = NO;
    }
    else{
        self.lblPlaceholder.hidden = YES;
    }
}



@end
