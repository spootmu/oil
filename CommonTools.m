//
//  CommonTools.m
//  oil
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools
/**
 *  获取格式化时间
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)getFormatDate:(NSDate*)date
{
//    NSDateFormatter *format=[[NSDateFormatter alloc]init];
//    [format setDateFormat:@"HH:mm"];
//    NSString *finaldate=[format stringFromDate:date];
    
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateStyle:NSDateFormatterFullStyle];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *datestr=[format stringFromDate:date];
    
    
    return datestr;
}

/**
 *  获取本地时间
 *
 *  @return <#return value description#>
 */
+(NSDate*)getLocalDate
{
    NSDate *date = [NSDate date];
    return date;
}
@end
