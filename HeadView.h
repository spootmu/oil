//
//  HeadView.h
//  oil
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class FullOil;
@class HeadView;

@protocol HeadViewDelegate <NSObject>

@required
-(void)HeadViewDeleteWithMID:(NSManagedObjectID*) mid sender:(HeadView*) sender;

@end

@interface HeadView : UITableViewHeaderFooterView
@property(nonatomic,strong) FullOil *data;

@property(weak,nonatomic) id<HeadViewDelegate>delegate;
@end
