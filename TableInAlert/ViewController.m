//
//  ViewController.m
//  TableInAlert
//
//  Created by Line_Hu on 14-2-20.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "ViewController.h"
#import "AlertTable.h"
@interface ViewController ()<AlertTableDelegate>
{
    NSArray *arr;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr = [NSArray arrayWithObjects:@"111",@"222",@"333",@"444",@"555",@"666",@"777", nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showAlert:(id)sender
{
    AlertTable *alert = [[AlertTable alloc] initWithParentView:self.view];
    alert.translatesAutoresizingMaskIntoConstraints = NO;
    alert.delegate = self;
    alert.dataSources = [NSMutableArray arrayWithArray:arr];
    [alert showWithTitle:@"Choose an Item"];
    
}

- (void)cancelButtonClicked:(AlertTable *)alertTable
{
    NSLog(@"click Cancel");
}

- (void)confirmButtonClicked:(AlertTable *)alertTable
{
    NSLog(@"click confirm");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
