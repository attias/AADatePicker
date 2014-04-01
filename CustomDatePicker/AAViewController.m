//
//  AAViewController.m
//  CustomDatePicker
//
//  Created by Amit Attias on 3/26/14.
//  Copyright (c) 2014 I'm IT. All rights reserved.
//

#import "AAViewController.h"

@interface AAViewController ()

@end

@implementation AAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    AADatePicker *datePicker = [[AADatePicker alloc] initWithFrame:CGRectMake(0, 20, 320, 264)];
    AADatePicker *datePicker = [[AADatePicker alloc] initWithFrame:CGRectMake(0, 20, 320, 264) maxDate:[NSDate dateWithTimeIntervalSinceNow:30*24*60*60] minDate:[NSDate dateWithTimeIntervalSince1970:0]];
    
    [self.view addSubview:datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
