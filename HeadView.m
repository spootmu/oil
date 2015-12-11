//
//  HeadView.m
//  oil
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//

#import "HeadView.h"
#import "FullOil.h"
#import "CommonTools.h"
#import <CoreData/CoreData.h>
@interface HeadView()
@property (weak, nonatomic) IBOutlet UILabel *lblFull;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property(nonatomic,strong) NSManagedObjectID *mid;
@end
@implementation HeadView

-(void)setData:(FullOil *)data
{
    if(data!=nil)
    {
        self.lblFull.text=[NSString stringWithFormat:@"%@L",[data.total stringValue]];
        self.lblDate.text=[CommonTools getFormatDate:data.datetime];
        self.mid=data.objectID;
    }
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithReuseIdentifier:reuseIdentifier])
    {
        
    }
    return self;
}

- (IBAction)btnDel:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(HeadViewDeleteWithMID:sender:)])
    {
        [self.delegate HeadViewDeleteWithMID:self.mid sender:self];
    }
}


@end
