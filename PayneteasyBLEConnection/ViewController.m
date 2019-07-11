
#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define Object(obj) obj ? obj : [NSNull null]

@interface ViewController () <CBCentralManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *buttonScan;

@end


@implementation ViewController {
    NSMutableArray *_arrayIdentifiers;
    NSMutableDictionary *_dictPeripherals;
    CBCentralManager *_centralManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.text = nil;
    
    _arrayIdentifiers = [NSMutableArray array];
    _dictPeripherals = [NSMutableDictionary dictionary];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)startScan {
    [self clearData];
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
    [_buttonScan setTitle:@"Stop scanning" forState:UIControlStateNormal];
}

- (void)stopScan {
    [_centralManager stopScan];
    [_buttonScan setTitle:@"Start scanning" forState:UIControlStateNormal];
}

- (void)clearData {
    [_arrayIdentifiers removeAllObjects];
    [self updateData];
}

- (void)updateData {
    NSInteger num = 0;
    NSString *text = nil;
    for (NSString *identifier in _arrayIdentifiers) {
        num++;
        NSDictionary *dict = _dictPeripherals[identifier];
        NSString *item = [NSString stringWithFormat:@"%ld. UUID=%@\nname=%@\nadvertisementData=%@", (long)num, dict[@"UUID"], dict[@"name"], dict[@"advertisementData"]];
        text = text.length ? [text stringByAppendingFormat:@"\n\n%@", item] : item;
    }
    _textView.text = text;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *identifier = peripheral.identifier.UUIDString;
    if (identifier) {
        if (![_arrayIdentifiers containsObject:identifier])
            [_arrayIdentifiers addObject:identifier];
        _dictPeripherals[identifier] = @{ @"UUID" : identifier, @"name" : Object(peripheral.name), @"advertisementData" : Object(advertisementData)};
        [self updateData];
    }
}

#pragma mark - Actions

- (IBAction)buttonScanTouchUpInside:(UIButton *)button {
    if (_centralManager.isScanning) {
        [self stopScan];
    } else {
        [self startScan];
    }
}

- (IBAction)buttonClearTouchUpInside:(UIButton *)button {
    if (_centralManager.isScanning)
        [self stopScan];
    [self clearData];
}

@end
