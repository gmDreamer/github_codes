//
//  NSLeftSessionViewController.m
//  zhixin
//
//  Created by linyi on 17/7/14.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "NSLeftSessionViewController.h"
#import "ZXSessionCell.h"

@interface NSLeftSessionViewController ()<NSTabViewDelegate,NSTableViewDataSource>
{
    ZXSessionCell *cell;
}
@end

@implementation NSLeftSessionViewController

- (void)viewDidLoad {
   // [super viewDidLoad];
    // Do view setup here.
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 10;
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 70;
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return  nil;
}
//-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//{
//
//
//    
//       return nil;
//
//    
//}
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *t_name = [tableColumn identifier];
    if([t_name isEqualToString:@"abc"]){
        [cell  setTitle:@"123456" ];
    }
}
@end
