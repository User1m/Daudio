//
//  NoteViewController.m
//  Daudio
//
//  Created by Claudius Mbemba on 1/1/17.
//  Copyright © 2017 Claudius Mbemba. All rights reserved.
//

#import "NoteViewController.h"
#import "UIAlertController+Utils.h"
#import "NoteManager.h"
#import <Objection/Objection.h>

const float keyboardDuration = 0.3f;
static NSString *note =  @"note";

@interface NoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *annotateButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation NoteViewController

objection_requires(note)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noteTextView.inputAccessoryView = self.toolBar;
    [self loadNote:self.noteKey];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObservers];
    [self annotateNote];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObservers];
}

#pragma mark Setup


#pragma mark Observers

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Helpers

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)loadNote:(NSString *)noteKey {
    self.note = [NoteManager getNote:noteKey fromUserDefaults:NSUserDefaults.standardUserDefaults];
    if (self.note == nil) {
        [JSObjection.defaultInjector injectDependencies:self];
    }
    self.noteTextView.text = self.note.formattedText;
}

- (void)saveNote {
    self.note.formattedText = self.noteTextView.text;
    [NoteManager saveNote:self.note userDefaults:NSUserDefaults.standardUserDefaults withKey:self.noteKey];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //https://stackoverflow.com/questions/3825822/how-do-i-get-uitextview-to-scroll-properly-when-the-keyboard-is-visible
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.noteTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.noteTextView.scrollIndicatorInsets = self.noteTextView.contentInset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.noteTextView.contentInset = UIEdgeInsetsZero;
    self.noteTextView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark Actions
- (IBAction)handleDoneButton:(id)sender {
    [self.view endEditing:YES];
    [self saveNote];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate didFinishNote];
}

- (IBAction)handleCancelButton:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleClearButton:(id)sender {
    self.noteTextView.text = @"";
}

- (IBAction)handleAnnotateButton:(id)sender {
    [self.delegate didRequestAnnotationUpdate];
    [self annotateNote];
}

- (void)annotateNote {
    self.noteTextView.text = ([self.noteTextView.text isEqualToString:@""]) ? self.noteAnnotation : [NSString stringWithFormat:@"%@\n%@", self.noteTextView.text, self.noteAnnotation];
}

@end
