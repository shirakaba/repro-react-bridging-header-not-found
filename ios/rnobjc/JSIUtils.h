//
//  JSIUtils.h
//  VisionCamera
//
//  Forked by Jamie Birch on 29.09.21.
//  Created by Marc Rousavy on 30.04.21.
//  Copyright © 2021 mrousavy. All rights reserved.
//  Forked from: https://github.com/mrousavy/react-native-vision-camera/blob/71730a73ef5670e45e34185a13a260a374a96dcd/ios/React%20Utils/JSIUtils.h
//

#pragma once

#import <jsi/jsi.h>
#import <ReactCommon/CallInvoker.h>
#import <React/RCTBridgeModule.h>

using namespace facebook;
using namespace facebook::react;

// (any...) => any -> (void)(id, id)
RCTResponseSenderBlock convertJSIFunctionToCallback(jsi::Runtime& runtime, const jsi::Function& value, std::shared_ptr<CallInvoker> jsInvoker);
