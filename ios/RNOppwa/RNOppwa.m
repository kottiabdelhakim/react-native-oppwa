#import "RNOppwa.h"

@implementation RNOppwa

OPPPaymentProvider *provider;

RCT_EXPORT_MODULE(RNOppwa);


-(instancetype)init
{
    self = [super init];
    if (self) {
         provider = [OPPPaymentProvider paymentProviderWithMode:OPPProviderModeTest];
    }
    
    return self;
}

/**
 * transaction
 */
RCT_EXPORT_METHOD(transactionPayment: (NSDictionary*)options resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSError * _Nullable error;
   
    
    OPPCardPaymentParams *params = [OPPCardPaymentParams cardPaymentParamsWithCheckoutID:[options valueForKey:@"checkoutID"]

                                                                        paymentBrand:[options valueForKey:@"paymentBrand"]
                                                                              holder:[options valueForKey:@"holderName"]
                                                                              number:[options valueForKey:@"cardNumber"]
                                                                         expiryMonth:[options valueForKey:@"expiryMonth"]
                                                                          expiryYear:[options valueForKey:@"expiryYear"]
                                                                                 CVV:[options valueForKey:@"cvv"]
                                                                               error:&error];

    if (error) {
      reject(@"oppwa/card-init",error.description, error);
    } else {
      OPPTransaction *transaction = [OPPTransaction transactionWithPaymentParams:params];

      [provider submitTransaction:transaction completionHandler:^(OPPTransaction * _Nonnull transaction, NSError * _Nullable error) {
        if (transaction.type == OPPTransactionTypeAsynchronous) {
          // Open transaction.redirectURL in Safari browser to complete the transaction
        }  else if (transaction.type == OPPTransactionTypeSynchronous) {
         resolve(transaction);
        } else {
          reject(@"oppwa/transaction",error.description, error);
          // Handle the error
        }
      }];
    }
}
/**
 * validate number
 * @return
 */
RCT_EXPORT_METHOD(isValidNumber:
            options:
            (NSDictionary *) options
            resolver:
            (RCTPromiseResolveBlock) resolve
            rejecter:
            (RCTPromiseRejectBlock) reject) {

        
        if (![OPPCardPaymentParams isNumberValid:[options valueForKey:@"cardNumber"] forPaymentBrand:[options valueForKey:@"paymentBrand"]]) {
            resolve([NSNull null]);
        }
        else {
           reject(@"oppwa/card-invalid", @"The card number is invalid.", nil);
        }
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
