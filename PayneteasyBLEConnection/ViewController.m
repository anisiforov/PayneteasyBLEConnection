
#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <UITextFieldDelegate, CBCentralManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation ViewController {
    CBCentralManager *centralManager;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.text = nil;
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
}

- (void)retrieveConnectedPeripherals {
    [_textView becomeFirstResponder];
    _textView.text = nil;
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:_textField.text];
    if (serviceUUID) {
        NSArray<CBPeripheral *> *array = [centralManager retrieveConnectedPeripheralsWithServices:@[serviceUUID]];
        _textView.text = [array description];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self retrieveConnectedPeripherals];
    return YES;
}

- (IBAction)buttonTouchUpInside:(id)sender {
    [self retrieveConnectedPeripherals];
}

@end
