//
//  QoeQosViewController.m
//  DeSA
//
//  Created by LTFE on 17/02/15.
//  Copyright (c) 2015 LTFE. All rights reserved.
//

#import "QoeQosViewController.h"
#import "RedButton.h"

@interface QoeQosViewController ()
{

}

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSubmit:(id)sender;
- (IBAction)qSlider:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *qSliderRef;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labelDebug;

- (IBAction)btnSmile1:(id)sender;
- (IBAction)btnSmile2:(id)sender;
- (IBAction)btnSmile3:(id)sender;
- (IBAction)btnSmile4:(id)sender;
- (IBAction)btnSmile5:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSmileRef1;
@property (weak, nonatomic) IBOutlet UIButton *btnSmileRef2;
@property (weak, nonatomic) IBOutlet UIButton *btnSmileRef3;
@property (weak, nonatomic) IBOutlet UIButton *btnSmileRef4;
@property (weak, nonatomic) IBOutlet UIButton *btnSmileRef5;

@property (weak, nonatomic) IBOutlet UILabel *labelQuestLike;
@property (weak, nonatomic) IBOutlet UILabel *labelHeadline;
@property (weak, nonatomic) IBOutlet UILabel *labelInstructions;
@property (weak, nonatomic) IBOutlet UILabel *labelExcellent;
@property (weak, nonatomic) IBOutlet UILabel *labelGood;
@property (weak, nonatomic) IBOutlet UILabel *labelFair;
@property (weak, nonatomic) IBOutlet UILabel *labelPoor;
@property (weak, nonatomic) IBOutlet UILabel *labelBad;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;

@end

static NSString *userRateDescription;
static NSString *userRate;
static NSString *featureQuestionnaire;
static NSString *questionnaireComment;

static NSString * const LanguageTableQoeEnglish   = @"Localizable_qoe_eng";
static NSString * const LanguageTableQoeSlovenian = @"Localizable_qoe_slo";
static NSString * const LanguageTableQoeNorwegian = @"Localizable_qoe_nor";

@implementation QoeQosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init
    userRate            = @"3";
    userRateDescription = @"Fair";
    questionnaireComment= @"";
    
    self.textField.delegate     = self;
    
    //gesture for hidding keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    //init slider likelihood
    NSString* initQuestLikelihood = [[NSUserDefaults standardUserDefaults] objectForKey:@QUEST_LIKE_PERCENT];
    
    if ([initQuestLikelihood length])
    {
        self.labelQuestLike.text = initQuestLikelihood;
        self.qSliderRef.value    = [initQuestLikelihood floatValue];
    }
    
    self.labelDebug.text = [NSString stringWithFormat:@"%d", [QoeQosViewController csvParser]];

    //Localization
    self.textField.text         = LocalizedStringQoE(@"Please provide why you feel that way", @"Please provide why you feel that way");
    self.labelInstructions.text = LocalizedStringQoE(@"Please rate your experience with the feature you just used:", @"Please rate your experience with the feature you just used:");
    self.labelHeadline.text     = LocalizedStringQoE(@"Quality of Experience", @"Quality of Experience");
    self.labelExcellent.text    = LocalizedStringQoE(@"Excellent", @"Excellent");
    self.labelGood.text         = LocalizedStringQoE(@"Good", @"Good");
    self.labelFair.text         = LocalizedStringQoE(@"Fair", @"Fair");
    self.labelPoor.text         = LocalizedStringQoE(@"Poor", @"Poor");
    self.labelBad.text          = LocalizedStringQoE(@"Bad", @"Bad");
    [self.btnCancel  setTitle:    LocalizedStringQoE(@"Cancel", @"Cancel") forState: UIControlStateNormal];
    [self.btnSubmit  setTitle:    LocalizedStringQoE(@"Submit", @"Submit") forState: UIControlStateNormal];
}

/** 
 * Generate random string with 18 characters length
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return :  generated user id
 */
+ (NSString *) randomStringUidGenerator
{
    int len = 18;
    
    NSString *letters = @"0123456789abcdefghijklmnopqrstuvwxyz0123456789"; 
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 
 * Text field dismiss
 * @author LTFE
 *
 * @param  : theTextField
 * @param  : /
 * @return : YES
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [self dismissKeyboard];
    return YES;
}

/** 
 * Dismis keyboard
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : /
 */
-(void)dismissKeyboard
{
    if (![self.textField.text length])
    {
        self.textField.text = LocalizedStringQoE(@"Please provide why you feel that way", @"Please provide why you feel that way");
    }
    else
    {
        questionnaireComment = self.textField.text;
    }

    [self.textField resignFirstResponder];
}

/** 
 * Log feature start event
 * @author LTFE
 *
 * @param  : featureName
 * @param  : /
 * @return : /
 */
+(void) logFeatureStart:(NSString *)featureName
{
    [self writeIntoCsv:@"Starting Feature"
          writeIntoCsv:featureName
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""];
}

/** 
 * Log feature complete event
 * @author LTFE
 *
 * @param  : featureName
 * @param  : /
 * @return : /
 */
+(void) logFeatureCompleted:(NSString *)featureName
{
    [self writeIntoCsv:@"Completing Feature"
          writeIntoCsv:featureName
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""];
}

/** 
 * Log fire questionnaire event
 * @author LTFE
 *
 * @param  : featureName
 * @param  : /
 * @return : /
 */
+(void) logFireQuestionnaire:(NSString *)featureName
{
    [self writeIntoCsv:@"Fire Questionnaire"
          writeIntoCsv:featureName
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""];
}

/** 
 * Log user input event
 * @author LTFE
 *
 * @param  : featureName
 * @param  : actionName
 * @return : /
 */
+(void) logUserInput:(NSString *)featureName
        logUserInput:(NSString *)actionName
{
    [self writeIntoCsv:@"User Input"
          writeIntoCsv:featureName
          writeIntoCsv:actionName
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""];
}

/** 
 * Log push data to server event
 * @author LTFE
 *
 * @param  : featureName
 * @param  : actionName
 * @return : /
 */
+(void) logPushDataToServer:(NSString *)featureName
        logPushDataToServer:(NSString *)actionName
{
    [self writeIntoCsv:@"Push to Server"
          writeIntoCsv:featureName
          writeIntoCsv:actionName
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""];
}

/** 
 * Log push received event from server event
 * @author LTFE
 *
 * @param  : featureName
 * @param  : actionName
 * @return : /
 */
+(void) logReceivedEventFromServer:(NSString *)featureName
        logReceivedEventFromServer:(NSString *)actionName
{
    [self writeIntoCsv:@"Received From Server"
          writeIntoCsv:featureName
          writeIntoCsv:actionName
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""];
}

/** 
 * Log push application output event
 * @author LTFE
 *
 * @param  : featureName
 * @param  : actionName
 * @return : /
 */
+(void) logApplicationOutput:(NSString *)featureName
        logApplicationOutput:(NSString *)actionName
{
    [self writeIntoCsv:@"Application Output"
          writeIntoCsv:featureName
          writeIntoCsv:actionName
          writeIntoCsv:@""
          writeIntoCsv:@""
          writeIntoCsv:@""];
}

/** 
 * Set questionnaire likelihood
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : /
 */
+(void) setQuestionnaireLikelihood:(NSString *)featureName
{
    
}

/** 
 * Set questionnaire submit
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : /
 */
+(void) logQuestionnaireSubmit
{
    if (![questionnaireComment length])
    {
        questionnaireComment = @"";
    }
    
    if (questionnaireComment == NULL)
    {
        questionnaireComment = @"";
    }
    
    [self writeIntoCsv:@"Questionnaire"
          writeIntoCsv:featureQuestionnaire
          writeIntoCsv:@""
          writeIntoCsv:userRate
          writeIntoCsv:userRateDescription
          writeIntoCsv:questionnaireComment];
}

/** 
 * Set questionnaire feature name
 * @author LTFE
 *
 * @param  : featureName
 * @param  : /
 * @return : /
 */
+(void) setQuestionnaireFeature:(NSString *)featureName
{
    featureQuestionnaire = featureName;
}

/** 
 * Write into CSV file
 * @author LTFE
 *
 * @param  : event
 * @param  : featureName
 * @param  : actionName
 * @param  : actionName
 * @param  : userRate
 * @param  : userRateDesctiption
 * @param  : questionnaireComment
 * @return : /
 */
+(void) writeIntoCsv:(NSString *)event
        writeIntoCsv:(NSString *)featureName
        writeIntoCsv:(NSString *)actionName
        writeIntoCsv:(NSString *)userRate
        writeIntoCsv:(NSString *)userRateDesctiption
        writeIntoCsv:(NSString *)questionnaireComment
{
    NSString *outputString  = @"";
    NSString *startCsvFile  = @"";
    NSString *outputFileName;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@QOE_CSV_FILE] length])
    {
        outputFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@QOE_CSV_FILE];
        
        startCsvFile = [NSString stringWithContentsOfFile:outputFileName
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
        if (startCsvFile == NULL)
        {
            outputFileName = [self createNewCsvFile];
        }
    }
    else
    {
        outputFileName = [self createNewCsvFile];
    }
    
    NSError *csvError = NULL;
    
    //write
    NSString *tmpInput = @"";
    
    NSString *timestamp = [self logTimestamp];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@QOE_USER_ID];
    
    if (![userId length])
    {
        userId = [QoeQosViewController randomStringUidGenerator];
        
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@QOE_USER_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (startCsvFile == NULL)
    {
        startCsvFile = @"";
    }
    if (event == NULL)
    {
        event = @""; 
    }
    if (featureName == NULL)
    {
        featureName = @"";
    }
    if (userRate == NULL)
    {
        userRate = @""; 
    }
    if (userRateDesctiption == NULL)
    {
        userRateDesctiption = @""; 
    }
    if (questionnaireComment == NULL)
    {
        questionnaireComment = @""; 
    }
    
    tmpInput = [tmpInput stringByAppendingFormat:@"%@;%@;%@;%@;%@;%@;%@;%@;%@;",
                @"DeSA",
                userId,
                timestamp,
                event,
                featureName,
                actionName,
                userRate,
                userRateDesctiption,
                questionnaireComment];
    
    outputString = [outputString stringByAppendingFormat:@"%@\n%@", startCsvFile, tmpInput];
    
    
    //We write the string to a file and assign it's return to a boolean
    BOOL written    = [outputString writeToFile:outputFileName    atomically:YES encoding:NSUTF8StringEncoding error:&csvError];
    
    //If there was a problem saving we show the error if not show success and file path
    if (!written)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@QOE_CSV_FILE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        //[self readFromCsvFile:outputFileName];
    }
    
    //[self deleteCsvFile];
}

/** 
 * Create new CSV file
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : outputFileName
 */
+(NSString*)createNewCsvFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    
    NSString *outputFileName = [docDirectory stringByAppendingPathComponent:@"DeSA_QoE_KPI.csv"];
    
    [[NSUserDefaults standardUserDefaults] setObject:outputFileName forKey:@QOE_CSV_FILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return outputFileName;
}

/** 
 * Delte CSV file
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : /
 */
+(void)deleteCsvFile
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@QOE_CSV_FILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 
 * Read from CSV file
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : /
 */
+(void)readFromCsvFile:(NSString *)csvFileName
{
    NSString *file      = [NSString stringWithContentsOfFile:csvFileName
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    NSLog(@"QOE_KPI File = %@", file);
    
}

/** 
 * CSV file parsen number of lines
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : number of lines
 */
+(int )csvParser
{
    NSString *outputFileName;

        outputFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@QOE_CSV_FILE];
    
    
    NSString *file      = [NSString stringWithContentsOfFile:outputFileName
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if (allLines.count)
    {
        return allLines.count;
    }

    return 0;
}

/** 
 * Log timestamp
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : timestamp log
 */
+ (NSString*)logTimestamp
{
    NSString *MyString;
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    MyString = [dateFormatter stringFromDate:nowDate];
    
    return MyString;
}

- (IBAction)qSlider:(id)sender
{
    int sliderValue= lroundf(self.qSliderRef.value);
    [self.qSliderRef setValue:sliderValue animated:YES];
    
    self.labelQuestLike.text = [NSString stringWithFormat:@"%d", sliderValue];

}

- (IBAction)btnCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)btnSubmit:(id)sender
{
    // set Questionnaire Likelihood
    NSString *strQuest = [NSString stringWithFormat:@"%.0f", self.qSliderRef.value];
    [[NSUserDefaults standardUserDefaults] setObject:strQuest forKey:@QUEST_LIKE_PERCENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // log Questionnaire
    [QoeQosViewController logQuestionnaireSubmit];
    
    NSString * jsonString;  
    
    jsonString = [NSString stringWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@QOE_CSV_FILE]
                                           encoding:NSUTF8StringEncoding
                                              error:nil];
    
    NSMutableDictionary *dictionaryDataFinal = [[NSMutableDictionary alloc]init];
    [dictionaryDataFinal setValue:jsonString           forKey:@"qoeqos"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryDataFinal options:0 error:&error];
    
    //NSLog(@"JSON final\n%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //set your own, define URL_QOE_SUBMIT URL for submmiting data
    NSString * sessionPostUrl = @URL_QOE_SUBMIT;
    
    [request setURL:[NSURL URLWithString:sessionPostUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         /* check response */
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if(httpResponse.statusCode == 200)
         {
             // if submit successfull delete csv
             [QoeQosViewController deleteCsvFile];
         }
         
     }];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)btnSmile5:(id)sender
{
    [self swtBWsmileAll]
    
    [self.btnSmileRef5 setImage:[UIImage imageNamed:@"qoe_smile_5.png"] forState:UIControlStateNormal];
    
    userRate            = @"5";
    userRateDescription = @"Excellent";
}
- (IBAction)btnSmile4:(id)sender
{
    [self swtBWsmileAll]
  
    [self.btnSmileRef4 setImage:[UIImage imageNamed:@"qoe_smile_4.png"] forState:UIControlStateNormal];
    
    userRate            = @"4";
    userRateDescription = @"Good";
}
- (IBAction)btnSmile3:(id)sender
{
    [self swtBWsmileAll]
    
    [self.btnSmileRef3 setImage:[UIImage imageNamed:@"qoe_smile_3.png"] forState:UIControlStateNormal];
    
    userRate            = @"3";
    userRateDescription = @"Fair";
}
- (IBAction)btnSmile2:(id)sender
{
    [self swtBWsmileAll]

    [self.btnSmileRef2 setImage:[UIImage imageNamed:@"qoe_smile_2.png"] forState:UIControlStateNormal];
    
    userRate            = @"2";
    userRateDescription = @"Poor";
}
- (IBAction)btnSmile1:(id)sender
{
    [self swtBWsmileAll]

    [self.btnSmileRef1 setImage:[UIImage imageNamed:@"qoe_smile_1.png"] forState:UIControlStateNormal];
    
    userRate            = @"1";
    userRateDescription = @"Bad";
}

/** 
 * Set all smiles to black and white 
 * @author LTFE
 *
 * @param  : /
 * @param  : /
 * @return : /
 */
-(void)swtBWsmileAll
{
    [self.btnSmileRef1 setImage:[UIImage imageNamed:@"qoe_smile_1bw.png"] forState:UIControlStateNormal];
    [self.btnSmileRef2 setImage:[UIImage imageNamed:@"qoe_smile_2bw.png"] forState:UIControlStateNormal];
    [self.btnSmileRef3 setImage:[UIImage imageNamed:@"qoe_smile_3bw.png"] forState:UIControlStateNormal];
    [self.btnSmileRef4 setImage:[UIImage imageNamed:@"qoe_smile_4bw.png"] forState:UIControlStateNormal];
    [self.btnSmileRef5 setImage:[UIImage imageNamed:@"qoe_smile_5bw.png"] forState:UIControlStateNormal];
}

/** 
 * Method for translation 
 * @author LTFE
 *
 * @param  : key
 * @param  : comment
 * @return : localized string
 */
NSString *LocalizedStringQoE(NSString *key, NSString *comment)
{
    NSNumber *savedLanguageNumber = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@APP_LANGUAGE];
    
    ApplicationLanguageQoE savedLanguage = DesaApplicationLanguageQoE_English;
    if (savedLanguageNumber)
    {
        savedLanguage = [savedLanguageNumber integerValue];
    }
    
    return LocalizedStringForLanguageQoE(key, comment, savedLanguage); 
}

/** 
 * Method for translation based on language
 * @author LTFE
 *
 * @param  : key
 * @param  : comment
 * @param  : language
 * @return : localized string
 */
NSString *LocalizedStringForLanguageQoE(NSString *key, NSString *comment, ApplicationLanguageQoE language)
{
    switch (language) {
        case DesaApplicationLanguageQoE_English:
            return NSLocalizedStringFromTable(key, LanguageTableQoeEnglish, comment);
        case DesaApplicationLanguageQoE_Slovenian:
            return NSLocalizedStringFromTable(key, LanguageTableQoeSlovenian, comment);
        case DesaApplicationLanguageQoE_Norwegian:
            return NSLocalizedStringFromTable(key, LanguageTableQoeNorwegian, comment);
        default:
            return NSLocalizedStringFromTable(key, LanguageTableQoeEnglish, comment);
    }
}

@end
