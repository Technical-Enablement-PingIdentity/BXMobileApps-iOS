//
//  MBRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/11/2017.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"

/**
 * Enumeration of posibble recognizer result state
 */
typedef NS_ENUM(NSInteger, MBRecognizerResultState) {
    
    /**
     *  Empty
     */
    MBRecognizerResultStateEmpty,
    
    /**
     *  Uncertain
     */
    MBRecognizerResultStateUncertain,
    
    /**
     *  Valid
     */
    MBRecognizerResultStateValid,

    /**
     *  StageValid
     */
    MBRecognizerResultStateStageValid,

};

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class for all recognizer results
 */
MB_CLASS_AVAILABLE_IOS(13.0)
@interface MBRecognizerResult : NSObject

MB_INIT_UNAVAILABLE

@property (nonatomic, assign, readonly) MBRecognizerResultState resultState;
@property (nonatomic, readonly) NSString *resultStateString;

@end

NS_ASSUME_NONNULL_END
