//
//  ConnectionViewController.m
//  DeckPress
//
//  Created by Daren taylor on 20/06/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "ConnectionViewController.h"

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectPressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];

}
@end
