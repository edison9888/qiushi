//
//  SetViewController.h
//  NetDemo
//
//  Created by xyxd mac on 12-8-20.
//
//

#import <UIKit/UIKit.h>



@interface SetViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
UIActionSheetDelegate>
{
    UITableView *_mTable;
    NSMutableArray *_items;
    NSMutableArray *_subItems;

}

@property (nonatomic, retain) UITableView *mTable;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *subItems;


@end

