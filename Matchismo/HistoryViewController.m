//
//  UIViewController+HistoryViewController.m
//  Matchismo
//
//  Created by Yossy Carmeli on 10/08/2020.
//  Copyright © 2020 Yossy Carmeli. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;


@end

@implementation HistoryViewController

- (void) setHistory:(NSString *)history{

  _history = history;
  [self updateUI];
  
}
- (void) setHeadline:(NSString *)headline{
  
  _headline = headline;
  [self updateUI];
}

- (void) viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
  [self updateUI];
}

- (void) updateUI{
  self.historyTextView.text = self.history;
  self.headlineLabel.text = self.headline;
}

@end
