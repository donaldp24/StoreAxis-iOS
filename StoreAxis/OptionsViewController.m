//
//  OptionsViewController.m
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "OptionsViewController.h"
#import "BeaconViewController.h"
#import "STData.h"

@interface OptionsViewController () {
    NSMutableArray *arrayDatas;
}

@property (nonatomic, strong) IBOutlet UITableView *tblMain;
@property (nonatomic, strong) IBOutlet UILabel *lblRetailer;

@end

@implementation OptionsViewController

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
    
    [self.tblMain mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    arrayDatas = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initializeData];
    
    [self.tblMain reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if ((indexPath.row % 2) == 0)
        cell = [self.tblMain dequeueReusableCellWithIdentifier:@"evenrowidentifier"];
    else
        cell = [self.tblMain dequeueReusableCellWithIdentifier:@"oddrowidentifier"];
    if (cell == nil)
        return nil;
    
    UIView *viewLabels = [cell.contentView viewWithTag:80];
    UIImageView *imgOption = (UIImageView *)[cell.contentView viewWithTag:90];
    UILabel *lblDisplay = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lblStoreNumber = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *lblTrackingNumber = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *lblParams = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *lblNumberOfPieces = (UILabel *)[cell.contentView viewWithTag:104];
    UILabel *lblStatus = (UILabel *)[cell.contentView viewWithTag:105];
    UILabel *lblStatusDetail = (UILabel *)[cell.contentView viewWithTag:106];
    
    STOptionData *data = [arrayDatas objectAtIndex:indexPath.row];
    
    [imgOption setImage:[UIImage imageNamed:data.imgPath]];
    [lblDisplay setText:data.display];
    [lblStoreNumber setText:data.storeNumber];
    [lblTrackingNumber setText:data.trackingNumber];
    [lblParams setText:[NSString stringWithFormat:@"Height %d Width %d Length %d Actual Weight %d", data.height, data.width, data.length, data.actualWeight]];
    [lblNumberOfPieces setText:[NSString stringWithFormat:@"%d", data.pieces]];
    [lblStatus setText:data.status];
    
    CGRect rtStatusDetail = lblStatusDetail.frame;
    CGSize maximumSize = CGSizeMake(203, 35);
    //NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:lblStatusDetail.font, NSFontAttributeName, nil];
    //CGFloat width = [[[NSAttributedString alloc] initWithString:data.statusDetail attributes:attributes] size].width;
    
    CGSize dateStringSize = [data.statusDetail sizeWithFont:[lblStatusDetail font]
                                   constrainedToSize:maximumSize
                                       lineBreakMode:lblStatusDetail.lineBreakMode];
    
    CGRect dateFrame = CGRectMake(rtStatusDetail.origin.x, rtStatusDetail.origin.y, maximumSize.width, dateStringSize.height);
    lblStatusDetail.frame = dateFrame;
    
    lblStatusDetail.numberOfLines = 0;
    [lblStatusDetail setText:data.statusDetail];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arrayDatas count] <= indexPath.row)
        return;
    
    STOptionData *info = [arrayDatas objectAtIndex:indexPath.row];
    BeaconViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"BeaconViewController"];
    ctrl.curData = info;
    [[self navigationController] pushViewController:ctrl animated:YES];
}

#pragma mark - Initialize data
- (void)initializeData
{
    [arrayDatas removeAllObjects];
    
    STOptionData *data;
    data = [[STOptionData alloc] init];
    data.imgPath = @"choose_img_good1";
    data.display = @"SonicCare";
    data.storeNumber = @"6117";
    data.trackingNumber = @"482634892145";
    data.height = 8;
    data.width = 12;
    data.length = 7;
    data.actualWeight = 4;
    data.pieces = 2;
    data.status = @"Delivered";
    data.statusDetail = @"Delivered: 02/27/2014 10:35 AM;Alexandria, KY;\nDelivered to door 21. Signature service not requested";
    [arrayDatas addObject:data];
    
    data = [[STOptionData alloc] init];
    data.imgPath = @"choose_img_good2";
    data.display = @"Amazon Kindle";
    data.storeNumber = @"6117";
    data.trackingNumber = @"3728904647392";
    data.height = 10;
    data.width = 24;
    data.length = 24;
    data.actualWeight = 6;
    data.pieces = 8;
    data.status = @"In Transmit";
    data.statusDetail = @"";
    [arrayDatas addObject:data];

    data = [[STOptionData alloc] init];
    data.imgPath = @"choose_img_good3";
    data.display = @"Hasbro FunFinder";
    data.storeNumber = @"6117";
    data.trackingNumber = @"43829563820";
    data.height = 17;
    data.width = 10;
    data.length = 18;
    data.actualWeight = 8;
    data.pieces = 1;
    data.status = @"In Transmit";
    data.statusDetail = @"";
    [arrayDatas addObject:data];
    
    data = [[STOptionData alloc] init];
    data.imgPath = @"choose_img_good4";
    data.display = @"Bigfoot";
    data.storeNumber = @"6117";
    data.trackingNumber = @"492876201246";
    data.height = 12;
    data.width = 18;
    data.length = 13;
    data.actualWeight = 3;
    data.pieces = 1;
    data.status = @"Delivered";
    data.statusDetail = @"Delivered: 02/27/2014 10:23 AM;Alexandria, KY;\nDelivered to door 21. Signature service not requested.";
    [arrayDatas addObject:data];
    
    data = [[STOptionData alloc] init];
    data.imgPath = @"choose_img_good5";
    data.display = @"NERF REBELLE REFRESH";
    data.storeNumber = @"6117";
    data.trackingNumber = @"576105368394";
    data.height = 10;
    data.width = 10;
    data.length = 20;
    data.actualWeight = 5;
    data.pieces = 4;
    data.status = @"In Transmit";
    data.statusDetail = @"";
    [arrayDatas addObject:data];
}

@end
