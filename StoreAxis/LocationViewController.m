//
//  LocationViewController.m
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "LocationViewController.h"
#import "TabViewController.h"

@interface LocationViewController () {
    UIResponder *currentResponder;
    NSMutableArray *arrayImages;
}

@property (nonatomic, strong) PageControl *pageCtrl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@end

@implementation LocationViewController

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
    
    arrayImages = [[NSMutableArray alloc] initWithObjects:
                   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locations_lowes"]]
                   , [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locations_target"]]
                   , [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locations_walmart"]]
    , nil];
    
    
    for (int i = 0; i < [arrayImages count]; i++) {
        UIImageView *imgView = [arrayImages objectAtIndex:i];
        CGRect rtImg = imgView.frame;
        [self.scrollView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        singleTap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:singleTap];
        
        if (i == 0)
        {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left);
                make.top.equalTo(self.scrollView.top);
                make.bottom.equalTo(self.scrollView.bottom);
                make.width.equalTo(@(rtImg.size.width));
                make.height.equalTo(@(rtImg.size.height));
            }];
        }
        else if (i == [arrayImages count] - 1)
        {
            UIImageView *prevView = [arrayImages objectAtIndex: i - 1];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(prevView.right);
                make.top.equalTo(self.scrollView.top);
                make.right.equalTo(self.scrollView.right);
                make.bottom.equalTo(self.scrollView.bottom);
                make.width.equalTo(@(rtImg.size.width));
            }];
        }
        else
        {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                UIImageView *prevView = [arrayImages objectAtIndex: i - 1];
                make.left.equalTo(prevView.right);
                make.top.equalTo(self.scrollView.top);
                make.bottom.equalTo(self.scrollView.bottom);
                make.width.equalTo(@(rtImg.size.width));
            }];
        }
    }
    
    self.pageCtrl = [[PageControl alloc] init];
	[self.pageCtrl setDotColorCurrentPage:[UIColor purpleColor]];
	[self.pageCtrl setDotColorOtherPage:[UIColor whiteColor]];
	[self.pageCtrl setDelegate:self];
	[self.pageCtrl setNumberOfPages:3];
	[self.pageCtrl setCurrentPage:0];
	[self.view addSubview:self.pageCtrl];
    
    [self.pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.scrollView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PageCtrl delegate

- (void)pageControlPageDidChange:(PageControl *)pageControl
{
	if (self.pageCtrl.currentPage == [self visibleRect2CurPage])
		return;
	
    [self gotoPage:self.pageCtrl.currentPage];
    
}

#pragma mark - Scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ([self visibleRect2CurPage] == self.pageCtrl.currentPage)
		return;
	
	if ([self visibleRect2CurPage] != -1)
		[self.pageCtrl setCurrentPage : [self visibleRect2CurPage]];
}

- (CGRect) visibleRect
{
	CGRect visibleRect;
	visibleRect.origin = self.scrollView.contentOffset;
	visibleRect.size = self.scrollView.bounds.size;
    
	float theScale = 1;
	visibleRect.origin.x *= theScale;
	visibleRect.origin.y *= theScale;
	visibleRect.size.width *= theScale;
	visibleRect.size.height *= theScale;
    
	return visibleRect;
}

- (int) visibleRect2CurPage
{
    for (int i = 0; i < [arrayImages count]; i++) {
        UIImageView *imgView = [arrayImages objectAtIndex:i];
        if ([self visibleRect].origin.x == imgView.frame.origin.x)
            return i;
    }
    return -1;
}

- (void) gotoPage:(int)nIndex
{
    CGRect rtframe = CGRectMake(nIndex * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.scrollView scrollRectToVisible:rtframe animated:YES];
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
    /*
    NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    //CGRect endFrame = ((NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    _loginGroupTopConstraint.with.offset(60.0);
    
    
    [UIView animateWithDuration:duration.floatValue animations:^{
        self.logo.alpha = 0.0;
        [self.view layoutIfNeeded];
    }];
     */
}

- (void)keyboardHiding:(NSNotification *)note
{
    /*
    NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    _loginGroupTopConstraint.with.offset(loginState == LoginStateLoggingIn ? textFieldsLowerPos : textFieldsUpperPos);
    
    [UIView animateWithDuration:duration.floatValue animations:^{
        self.logo.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
     */
    
}

#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    currentResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    currentResponder = nil;
}

#pragma mark - Image tap

-(void)tapDetected{
    if (currentResponder) {
        [currentResponder resignFirstResponder];
    }
    
    int index = self.pageCtrl.currentPage;
    
    // goto options view controller
    [[TabViewController sharedInstance] selectItem:1];
}


@end
