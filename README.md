# HoloCollectionView

[![CI Status](https://img.shields.io/travis/gonghonglou/HoloCollectionView.svg?style=flat)](https://travis-ci.org/gonghonglou/HoloCollectionView)
[![Version](https://img.shields.io/cocoapods/v/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)
[![License](https://img.shields.io/cocoapods/l/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/HoloCollectionView.svg?style=flat)](https://cocoapods.org/pods/HoloCollectionView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

```objective-c
UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
flowLayout...

UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
[self.view addSubview:collectionView];

[collectionView holo_makeRows:^(HoloCollectionViewRowMaker * _Nonnull make) {
    // make a cell
    make.row(ExampleCollectionViewCell.class).model(NSDictionary.new).size(CGSizeMake(100, 200));
    
    // make a list
    for (NSObject *obj in NSArray.new) {
        make.row(ExampleCollectionViewCell.class).model(obj).didSelectHandler(^(id  _Nullable model) {
            NSLog(@"did select row : %@", model);
        });
    }
}];

[self.collectionView reloadData];

// etc...
```

If you want to set the model to your UICollectionViewCell or change it's height according to the model, the UICollectionViewCell could conform to protocol: `HoloCollectionViewCellProtocol` and implement their selectors: 

```objective-c
- (void)holo_configureCellWithModel:(id)model;

+ (CGSize)holo_sizeForCellWithModel:(id)model;
```

Also, you can make `configSEL` or `sizeSEL` to set yourself selector for cell.

## Installation

HoloCollectionView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HoloCollectionView'
```

## Author

gonghonglou, gonghonglou@icloud.com

## License

HoloCollectionView is available under the MIT license. See the LICENSE file for more info.


