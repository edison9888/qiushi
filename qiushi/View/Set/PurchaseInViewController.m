//
//  PurchaseInViewController.m
//  qiushi
//
//  Created by xyxd mac on 12-8-31.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "PurchaseInViewController.h"
#import "iToast.h"
#import "IsNetWorkUtil.h"
@interface PurchaseInViewController ()
{
    NSMutableArray *_itemsArray;
    NSMutableArray *_subItemsArray;
    NSMutableArray *_valuesArray;
}
@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic, retain) NSMutableArray *subItemsArray;
@property (nonatomic, retain) NSMutableArray *valuesArray;
@end

@implementation PurchaseInViewController
@synthesize itemsArray = _itemsArray;
@synthesize subItemsArray = _subItemsArray;
@synthesize valuesArray = _valuesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"支持我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    //---------------------
    //----监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //申请购买
    /*
     enum{
     IAP0p99=10,
     IAP1p99,
     IAP4p99,
     IAP9p99,
     IAP24p99,
     }buyCoinsTag;
     */
    _itemsArray = [[NSMutableArray alloc]initWithObjects:@"去除广告",@"赞助",@"赞助",@"赞助",@"恢复购买",@"捐赠", nil];
    _subItemsArray = [[NSMutableArray alloc]initWithObjects:@"￥6",@"￥18",@"￥40",@"￥98",@"",@"", nil];
    _valuesArray = [[NSMutableArray alloc]initWithObjects:
                    [NSNumber numberWithInt:IAP0p99],
                    [NSNumber numberWithInt:IAP1p99],
                    [NSNumber numberWithInt:IAP4p99],
                    [NSNumber numberWithInt:IAP9p99], nil];
    
   
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - TableView data
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Contentidentifier = @"_ContentCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (!cell){
        //设置cell 样式
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Contentidentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.textLabel.text = [self.itemsArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.subItemsArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([IsNetWorkUtil isNetWork1] == NO) {
        return;
    }
    if (indexPath.row == 4) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }else if (indexPath.row == 5){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://me.alipay.com/xyxdasnjss"]];
    }
    else{
        [self buy:[[_valuesArray objectAtIndex:indexPath.row] intValue]];
    }
    
    
}



-(void)buy:(int)type
{
    buyType = type;
    if ([SKPaymentQueue canMakePayments]) {
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [self RequestProductData];
        DLog(@"允许程序内付费购买");
    }
    else
    {
        [[iToast makeText:@"不允许程序内付费购买" ] show];
        
        
    }
}

-(bool)CanMakePay
{
    return [SKPaymentQueue canMakePayments];
}

-(void)RequestProductData
{
    DLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (buyType) {
        case IAP0p99:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP0p99,nil];
            break;
        case IAP1p99:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP1p99,nil];
            break;
        case IAP4p99:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP4p99,nil];
            break;
        case IAP9p99:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP9p99,nil];
            break;
                    
        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];

}
//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", [myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    SKPayment *payment = nil;
    switch (buyType) {
        case IAP0p99:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP0p99];    //支付$0.99
            break;
        case IAP1p99:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP1p99];    //支付$1.99
            break;
        case IAP4p99:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP4p99];    //支付$9.99
            break;
        case IAP9p99:
            payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP9p99];    //支付$19.99
            break;
            
        default:
            break;
    }
    DLog(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
//    [request autorelease];
    
}
- (void)requestProUpgradeProductData
{
    DLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    DLog(@"-------弹出错误信息----------");

    [[iToast makeText:[error localizedDescription]] show];
 }

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    DLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
//    [transactions release];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    DLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                [self completeTransaction:transaction];
                DLog(@"-----交易完成 --------");
//                [[iToast makeText:@"购买成功 (ˇˍˇ）"] show];
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"感谢"//Thank You
                                                                    message:@"您购买成功啦～"//Your purchase was successful.
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                                                          otherButtonTitles:nil];
                
                [alerView show];
                
//                [self recordTransaction:transaction.originalTransaction];
//                [self provideContent:transaction.originalTransaction.payment.productIdentifier];
//                [self finishTransaction:transaction wasSuccessful:YES];
                

            }break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                [self failedTransaction:transaction];
                DLog(@"-----交易失败 --------");

                [[iToast makeText:@"购买失败,请重新尝试购买"] show];

            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
            {
                [self restoreTransaction:transaction];
                DLog(@"-----已经购买过该商品 --------");
            }break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
            {
                DLog(@"-----商品添加进列表 --------");
            }break;
            default:
                break;
        }
    }
}
//当用户成功的购买了一个项目时，你的观察者就会为你提供刚购买的产品。
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    DLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            ////    你的应用程序应该 实现这两个方法
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    // //从付费队列中删除交易
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    DLog(@"-----记录交易--------Product:%@",product);
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    DLog(@"-----下载--------Product:%@",product);
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@" 交易恢复处理");
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES] forKey:@"isAdvanced"];
    
    [[iToast makeText:@"恢复购买成功..."] show];
    
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    DLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
//    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"viewDidDisappear~~");
    request.delegate = nil;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    
}

@end
