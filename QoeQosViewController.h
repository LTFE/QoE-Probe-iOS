//
//  QoeQosViewController.h
//  DeSA
//
//  Created by LTFE on 17/02/15.
//  Copyright (c) 2015 LTFE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QOE_CSV_FILE       "qoeCsvFilePath"
#define QUEST_LIKE_PERCENT "questionnaireLikelihood"
#define QOE_USER_ID        "queUserId"
#define URL_QOE_SUBMIT     "url_ip_port_file" 

typedef NS_ENUM(NSInteger, ApplicationLanguageQoE)
{
    DesaApplicationLanguageQoE_English,
    DesaApplicationLanguageQoE_Slovenian,
    DesaApplicationLanguageQoE_Norwegian
};

@interface QoeQosViewController : UIViewController <UITextFieldDelegate>

+(void) logFeatureStart:(NSString *)featureName;
+(void) logFeatureCompleted:(NSString *)featureName;

+(void) setQuestionnaireFeature:(NSString *)featureName;
+(void) logQuestionnaireSubmit;
+(void) logFireQuestionnaire:(NSString *)featureName;

+(void) logUserInput:(NSString *)featureName
        logUserInput:(NSString *)actionName;
+(void) logApplicationOutput:(NSString *)featureName
        logApplicationOutput:(NSString *)actionName;
+(void) logPushDataToServer:(NSString *)featureName
        logPushDataToServer:(NSString *)actionName;
+(void) logReceivedEventFromServer:(NSString *)featureName
        logReceivedEventFromServer:(NSString *)actionName;

@end
