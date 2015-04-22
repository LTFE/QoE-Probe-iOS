# QoE Probe for  iOS

QoE probe was developed by  [LTFE - University of Ljubljana](http://www.ltfe.org) in cooperation with [BTH - Blekinge Tekniska Högskola](http://www.bth.se) as QoE Probe Enabler during European Union [FI-STAR](https://www.fi-star.eu) project.

## Table of Contents

* [Description](#description)
* [Methods](#methods)
* [Usage](#usage)
* [Version](#version)
* [License](#license)

### Description

QoE probe is a tool for measuring and collecting data relevant to QoE/QoS from an iOS mobile application. Different methods are used for logging data.
Collected data are stored inside iOS mobile application as records in the CSV format.
User can submit data to custom server in JSON format after questionnaire appears.
Frequency of appearing questionnaire can be set through probability likelihood.

### Methods

Different basic methods are implemented to collect data:
* Log start of feature
* Log completion of feature
* Log user input
* Log application output
* Log received from server event
* Log push to server event
* Log fire questionnaire

### Usage

Usage of QoE probe are represented in this section. 

**Imports:**

File *QoeQosViewController.h* have to be imported.

```objc
//Import .h file
#import "QoeQosViewController.h"
```

**Defines:**

*QOE_CSV_FILE*, *QUEST_LIKE_PERCENT* and *QOE_USER_ID* should remain untouched, they are used for *NSUserDefaults*.
*URL_QOE_SUBMIT* have to be set for custom URL server on which JSON file will be submitted.

```objc
//Used for NSUserDefaults
#define QOE_CSV_FILE       "qoeCsvFilePath"
#define QUEST_LIKE_PERCENT "queQuestionnaireLikelihood"
#define QOE_USER_ID        "queUserId"
//Set URL of custom server for submit data
#define URL_QOE_SUBMIT     "url_ip_port_file" 
```

**Logging methods:**

Example of usage for all logging methods are represented bellow.

```objc
//Log start of feature
[QoeQosViewController logFeatureStart:@"My Event"];
//Log questionnaire feature
[QoeQosViewController setQuestionnaireFeature:@"My Event"];
//Log application output
[QoeQosViewController logApplicationOutput:@"My Event" logApplicationOutput:@"Screen open"];
//Log user input                     
[QoeQosViewController logUserInput:@"My Event" logUserInput:@"Press button"];
//Log push to server event  
[QoeQosViewController logPushDataToServer:@"My Event" logPushDataToServer:@"Send to server"];
//Log received from server event  
[QoeQosViewController logReceivedEventFromServer:@"My Event" logReceivedEventFromServer:@"Received from server"];
//Log completion of feature  
[QoeQosViewController logFeatureCompleted:@"My Event"];
```

**Questionnaire firing:**

Random number is generated every time after feature is completed and probability of firing Questionnaire is calculated with Likelihood predefined percentage value. Special Questionnaire Screen is represented if condition is valid.

```objc
//Generate random number 
int questLikelihood = arc4random_uniform (100);

//Check condition for firing Questionnaire Screen
NSString* initQuestLikelihood = [[NSUserDefaults standardUserDefaults] objectForKey:@QUEST_LIKE_PERCENT];
if(([initQuestLikelihood length]) && (questLikelihood <= [initQuestLikelihood integerValue]))
{
    //Log questionnaire fire
    [QoeQosViewController logFireQuestionnaire:@"My Event"];
        
    //Open Questionnaire Screen   
    QoeQosViewController * qoeqos = [[QoeQosViewController alloc] init];
    [self presentViewController:qoeqos animated:YES completion:nil];
}
```

**Questionnaire Screen:**

User can submit data to custom server by rating application feature and adding comments.

![screenshot of selection conversion](https://raw.githubusercontent.com/LTFE/QoE-Probe-iOS/master/iPhoneQoE.png)



### Version

0.0.1


### License

LGPL
