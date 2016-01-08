//
//  ViewController.m
//  oil
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 Spoot Studio. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "FullOil.h"
#import "OilData.h"
#import "CoreDataManager.h"
#import "HeadView.h"
#import "CommonTools.h"
#import "CellView.h"
#import "MBProgressHUD+NJ.h"
@interface ViewController ()<HeadViewDelegate>
@property(nonatomic,strong) NSManagedObjectContext *context;
@property(nonatomic,strong) NSArray *fulloilsData;

@end

@implementation ViewController

-(NSManagedObjectContext *)context
{
    if(!_context)
    {
        _context=[CoreDataManager ShareCoreDataManager].context;
    }
    return _context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(concurrentQueue, ^(){
     [MBProgressHUD showMessage:@"正在加载...不要猴急"];
        [self initData];
//    });
   
//    [NSThread detachNewThreadSelector:@selector(initData) toTarget:self withObject:nil];
}


/**
 *  初始化navbar按钮
 */
-(void)initUI
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addMain)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"trash"] style:UIBarButtonItemStylePlain target:self action:@selector(trash)];
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:(139/255.0) green:(198/255.0) blue:(49/255.0) alpha:1.0];
    
    self.tableView.backgroundColor=[UIColor grayColor];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
}

/**
 *  bar左侧按钮事件
 */
-(void)trash
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认清空?"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearData];
        [self initData];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

/**
 *  bar右侧按钮事件
 */
-(void)addMain
{
    //底部菜单
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"增加新记录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //主记录弹框配置
    UIAlertAction *addMainAction=[UIAlertAction actionWithTitle:@"加满油" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *mainalert=[UIAlertController alertControllerWithTitle:nil message:@"加满油" preferredStyle:UIAlertControllerStyleAlert];
        [mainalert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }];
        UIAlertAction *saveAction=[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tbfulloil=mainalert.textFields.firstObject;
            

            [self addOil:[tbfulloil.text floatValue]];
            [self initData];
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [mainalert addAction:saveAction];
        [mainalert addAction:cancelAction];
        
        [self presentViewController:mainalert animated:YES completion:nil];
        
    }];
    
    //子记录弹框配置
    UIAlertAction *addSubAction=[UIAlertAction actionWithTitle:@"新旅程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *subalert=[UIAlertController alertControllerWithTitle:nil message:@"新旅程" preferredStyle:UIAlertControllerStyleAlert];
        
        [subalert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder=@"剩余油量";
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }];
        
        [subalert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder=@"续航里数";
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *saveActoin=[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *tbOil=subalert.textFields.firstObject;
            UITextField *tbKM=subalert.textFields.lastObject;
            
            [self addOilData:[tbOil.text floatValue] SurplusKM:[tbKM.text floatValue]];
            [self initData];
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [subalert addAction:saveActoin];
        [subalert addAction:cancelAction];
        
        [self presentViewController:subalert animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:addMainAction];
    [alert addAction:addSubAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
                            
}

/**
 *  初始化数据
 */
-(void)initData
{
    
    self.fulloilsData=nil;
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    request.entity=[NSEntityDescription entityForName:@"FullOil" inManagedObjectContext:self.context];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:NO];
    request.sortDescriptors=[NSArray arrayWithObject:sort];

    NSError *requesterr=nil;
    NSArray *arr=[self.context executeFetchRequest:request error:&requesterr];
    
    if(requesterr)
    {
        [NSException raise:@"查询失败" format:@"%@",[requesterr localizedDescription]];
    }
    self.fulloilsData=arr;
    [MBProgressHUD hideHUD];
    [self.tableView reloadData];
    
}

/**
 *  清空所有数据
 */
-(void)clearData
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    request.entity=[NSEntityDescription entityForName:@"FullOil" inManagedObjectContext:self.context];
    [request setIncludesPropertyValues:NO];
    NSError *err=nil;
    NSArray *arr=[self.context executeFetchRequest:request error:&err];
    for (FullOil *obj in arr) {
        [self.context deleteObject:(NSManagedObject*)obj];
    }
    [self.context save:nil];
    self.fulloilsData=nil;
    [self.tableView reloadData];
}

/**
 *  删除主数据
 *
 *  @param mid <#mid description#>
 */
-(void)delFullOil:(NSManagedObjectID*)mid
{
    FullOil *oil=[self.context objectWithID:mid];
    [self.context deleteObject:oil];
    [self.context save:nil];
    [self initData];
}

/**
 *  删除单条
 *
 *  @param mid    <#mid description#>
 *  @param mainid <#mainid description#>
 */

-(void)delOilData:(NSManagedObjectID*)mid MainID:(NSManagedObjectID*)mainid
{
//    NSFetchRequest *request=[[NSFetchRequest alloc]init];
//    request.entity=[NSEntityDescription entityForName:@"FullOil" inManagedObjectContext:self.context];
    NSError *err=nil;
    OilData *obj=[self.context objectWithID:mid];
    NSLog(@"delOilData:%@",obj);
    
    FullOil *fulloil=[self.context objectWithID:mainid];
    //1.先移除数组中内容
    [fulloil removeOildataObject:obj];
    //2.再真正删除数据库内容
    [self.context deleteObject:obj];
    [self.context save:&err];
    [self initData];
}

/**
 *  主表数据
 *
 *  @param total <#total description#>
 */
-(void)addOil:(float) total
{
    FullOil *fulloil=[NSEntityDescription insertNewObjectForEntityForName:@"FullOil" inManagedObjectContext:self.context];
    fulloil.total=[NSNumber numberWithFloat:total];
    fulloil.datetime=[CommonTools getLocalDate];
    [self.context save:nil];
}



/**
 *  添加明细数据
 *
 *  @param surplusOilL <#surplusOilL description#>
 *  @param surplusKM   <#surplusKM description#>
 */
-(void)addOilData:(float) surplusOilL SurplusKM:(float) surplusKM
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    request.entity=[NSEntityDescription entityForName:@"FullOil" inManagedObjectContext:self.context];
    NSError *err=nil;
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:YES];
    request.sortDescriptors=[NSArray arrayWithObject:sort];
    FullOil *obj=[[self.context executeFetchRequest:request error:&err] lastObject];
    if(err)
    {
        [NSException raise:@"查询失败" format:@"%@",[err localizedDescription]];
    }
    else{
        OilData *oildata=[NSEntityDescription insertNewObjectForEntityForName:@"OilData" inManagedObjectContext:self.context];
        oildata.km=[NSNumber numberWithFloat:surplusKM];
        oildata.l=[NSNumber numberWithFloat:surplusOilL];
        oildata.datetime=[CommonTools getLocalDate];
        [obj addOildataObject:oildata];
        BOOL issave=[self.context save:&err];
        if(!issave)
        {
            [NSException raise:@"保存失败" format:@"%@",[err localizedDescription]];
        }
    }
}

/**
 *  改变删除文字
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/**
 *  使表格变为可编辑状态
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 *  删除事件
 *
 *  @param tableView    <#tableView description#>
 *  @param editingStyle <#editingStyle description#>
 *  @param indexPath    <#indexPath description#>
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
         NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"datetime" ascending:NO]];
        FullOil *fulloil=self.fulloilsData[indexPath.section];
        NSArray *arr=[fulloil.oildata sortedArrayUsingDescriptors:sortDesc];
        OilData *oil=arr[indexPath.row];
        NSManagedObjectID *objID=oil.objectID;
        [self delOilData:objID MainID:fulloil.objectID];
        
    }
}

/**
 *  每组行数
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"datetime" ascending:NO]];
    FullOil *fulloil=self.fulloilsData[section];
    NSArray *arr=[fulloil.oildata sortedArrayUsingDescriptors:sortDesc];
    NSLog(@"row:%zd",arr.count);
    return arr.count;
}

/**
 *  组头高度
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

/**
 *  加载组头nib
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headID=@"head";
    HeadView *head=[tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    if(head==nil)
    {
        head=(HeadView*)[[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil] lastObject];
        head.delegate=self;
        FullOil *fulloil=self.fulloilsData[section];
        head.data=fulloil;
    }
    return head;
}

/**
 *  组头代理事件
 *
 *  @param mid    <#mid description#>
 *  @param sender <#sender description#>
 */
-(void)HeadViewDeleteWithMID:(NSManagedObjectID *)mid sender:(HeadView *)sender
{
    NSLog(@"%@",mid);
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除主数据?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okActoin=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self delFullOil:mid];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okActoin];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  总组数
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"head:%zd",self.fulloilsData.count);
    return self.fulloilsData.count;
}

/**
 *  组标题
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    FullOil *fulloil=self.fulloilsData[section];
    return [NSString stringWithFormat:@"%@L-%@",[fulloil.total stringValue],[CommonTools getFormatDate:fulloil.datetime]];
}

/**
 *  行高度
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/**
 *  行记录
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(nib==nil)
    {
        nib=[UINib nibWithNibName:@"CellView" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"custcell"];
    }
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"datetime" ascending:NO]];
    CellView *cell=[tableView dequeueReusableCellWithIdentifier:@"custcell"];
    FullOil *fulloil=self.fulloilsData[indexPath.section];
    NSArray *arr=[fulloil.oildata sortedArrayUsingDescriptors:sortDesc];
    OilData *oil=arr[indexPath.row];
    cell.data=oil;
    return cell;
}
@end
