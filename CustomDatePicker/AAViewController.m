//
//  AAViewController.m
//  CustomDatePicker
//
//  Created by Amit Attias on 3/26/14.
//  Copyright (c) 2014 I'm IT. All rights reserved.
//

#import "AAViewController.h"

@interface AAViewController () <AADatePickerDelegate>

@property (strong, nonatomic) UILabel *dateLabel;
@end

@implementation AAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AADatePicker *datePicker = [[AADatePicker alloc] initWithFrame:CGRectMake(0, 20, 320, 264) maxDate:[NSDate dateWithTimeIntervalSinceNow:7*24*60*60] minDate:[NSDate date] showValidDatesOnly:NO];

    datePicker.delegate = self;
    [self.view addSubview:datePicker];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(datePicker.frame), self.view.frame.size.width, 40)];
    [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.dateLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dateChanged:(AADatePicker *)sender
{
    NSString *dateString = [NSDateFormatter localizedStringFromDate:sender.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterMediumStyle];
    NSLog(@"%@",dateString);
    
    [self.dateLabel setText:dateString];
}

@end
