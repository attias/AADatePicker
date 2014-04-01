//
//  AADatePicker.m
//  CustomDatePicker
//
//  Created by Amit Attias on 3/26/14.
//  Copyright (c) 2014 I'm IT. All rights reserved.
//

#import "AADatePicker.h"

@interface AADatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int nDays;
    int startDayIndex;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

@end

@implementation AADatePicker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    assert((((minDate) && (maxDate)) && ([minDate compare:maxDate] != NSOrderedDescending)));
        
    self.minDate = minDate;
    self.maxDate = maxDate;
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    [self setBackgroundColor:[UIColor grayColor]];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    self.date = [NSDate date];
    
    
    [self initDays];

    
    NSDateComponents *components = [self.calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    [self.picker selectRow:hour inComponent:1 animated:NO];
    [self.picker selectRow:minute inComponent:2 animated:NO];
    [self.picker selectRow:startDayIndex inComponent:0 animated:NO];
    [self addSubview:self.picker];
}

-(void)initDays
{
    if ((self.minDate) && (self.maxDate)) {
        NSDateComponents *components = [self.calendar components:NSDayCalendarUnit
                                                        fromDate:self.minDate
                                                          toDate:self.maxDate
                                                         options:0];
    
        nDays = components.day + 1;
        
        if ([self.minDate compare:[NSDate date]] == NSOrderedDescending) {
            startDayIndex = 0;
        } else if ([self.maxDate compare:[NSDate date]] == NSOrderedAscending) {
            startDayIndex = nDays - 1;
        } else {
            NSDateComponents *todaysComponents = [self.calendar components:NSDayCalendarUnit
                                                            fromDate:self.minDate
                                                              toDate:[NSDate date]
                                                             options:0];
            
            startDayIndex = todaysComponents.day;
        }
    } else {
        nDays = INT16_MAX;
        startDayIndex = nDays / 2;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return nDays;
    }
    else if (component == 1)
    {
        return INT16_MAX;
    }
    else
    {
        return INT16_MAX;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 150;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 60;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:25.0]];
    [lblDate setTextColor:[UIColor blueColor]];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    if (component == 0) // Date
    {
        NSDate *aDate;
        if (self.minDate) {
            aDate = [NSDate dateWithTimeInterval:row*24*60*60 sinceDate:self.minDate];
        } else {
            int n = -nDays / 2 + row;
            aDate = [NSDate dateWithTimeIntervalSinceNow:n*24*60*60];
        }

        NSDateComponents *components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
        NSDate *today = [self.calendar dateFromComponents:components];
        components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
        NSDate *otherDate = [self.calendar dateFromComponents:components];
        
        if ([today isEqualToDate:otherDate]) {
            [lblDate setText:@"Today"];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.dateFormat = @"EEE, MMM d";
            
            [lblDate setText:[formatter stringFromDate:aDate]];
        }
        lblDate.textAlignment = NSTextAlignmentRight;
    }
    else if (component == 1) // Hour
    {
        int max = (int)[self.calendar maximumRangeOfUnit:NSHourCalendarUnit].length;
        [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]]; // 02d = pad with leading zeros to 2 digits
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 2) // Minutes
    {
        int max = (int)[self.calendar maximumRangeOfUnit:NSMinuteCalendarUnit].length;
        [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]];
        lblDate.textAlignment = NSTextAlignmentLeft;
    }
    
    return lblDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int daysFromStart;
    NSDate *chosenDate;
    
    if (self.minDate) {
        daysFromStart = [pickerView selectedRowInComponent:0];
        chosenDate = [NSDate dateWithTimeInterval:daysFromStart*24*60*60 sinceDate:self.minDate];
    } else {
        daysFromStart = -nDays / 2 + [pickerView selectedRowInComponent:0];
        chosenDate = [NSDate dateWithTimeIntervalSinceNow:daysFromStart*24*60*60];
    }
    
    NSInteger hour = [pickerView selectedRowInComponent:1];
    NSInteger minute = [pickerView selectedRowInComponent:2];
    
    // Build date out of the components we got
    NSDateComponents *components = [self.calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:chosenDate];
    
    components.hour = hour;
    components.minute = minute;
    
    self.date = [self.calendar dateFromComponents:components];
    
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(dateChanged:)])) {
        [self.delegate dateChanged:self];
    }
}
@end
