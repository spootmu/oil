//
//  CellView.m
//  oil
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//

#import "CellView.h"
#import "CommonTools.h"
#import "OilData.h"
@interface CellView()
@property (weak, nonatomic) IBOutlet UILabel *lblOil;
@property (weak, nonatomic) IBOutlet UILabel *lblKM;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgStat;


@end
@implementation CellView

-(void)setData:(OilData *)data
{
    if(data!=nil)
    {
        if([data.l floatValue]<=10.0)
        {
            self.lblOil.textColor=[UIColor redColor];
        }
        else{
            self.lblOil.textColor=[UIColor blackColor];
        }
        if([data.km floatValue]<=80)
        {
            self.lblKM.textColor=[UIColor redColor];
        }
        else{
            self.lblKM.textColor=[UIColor blackColor];
        }
        
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"HH"];
        float hh=[[format stringFromDate:data.datetime] floatValue];
        NSLog(@"%f",hh);
        
        if(hh>17)
        {
            self.imgStat.image=[UIImage imageNamed:@"moon"];
        }
        else
        {
            self.imgStat.image=[UIImage imageNamed:@"sun"];
        }
        
        self.lblOil.text=[NSString stringWithFormat:@"%@L",[data.l stringValue]];
        self.lblKM.text=[NSString stringWithFormat:@"%@KM",[data.km stringValue]];
        self.lblDate.text=[CommonTools getFormatDate:data.datetime];
    }
}

@end
