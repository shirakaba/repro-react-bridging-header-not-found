//
//  JSIUtils.mm
//  VisionCamera
//
//  Forked and Adjusted by Jamie Birch on 29.09.21.
//  Forked and Adjusted by Marc Rousavy on 02.05.21.
//  Copyright © 2021 Jamie Birch, mrousavy, and Facebook. All rights reserved.
//
// Forked and adjusted from: https://github.com/mrousavy/react-native-vision-camera/blob/5dc8ded62a4cb25971006287b7c634ca0981c5a2/ios/React%20Utils/JSIUtils.mm
//  ... which itself was forked and adjusted from: https://github.com/facebook/react-native/blob/900210cacc4abca0079e3903781bc223c80c8ac7/ReactCommon/react/nativemodule/core/platform/ios/RCTTurboModule.mm
//  Original Copyright Notice:
//
//  Copyright (c) Facebook, Inc. and its affiliates.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "JSIUtils.h"
#import <React/RCTBridge.h>
#import <ReactCommon/TurboModuleUtils.h>

using namespace facebook;
using namespace facebook::react;

RCTResponseSenderBlock convertJSIFunctionToCallback(jsi::Runtime &runtime, const jsi::Function &value, std::shared_ptr<CallInvoker> jsInvoker)
{
  auto weakWrapper = CallbackWrapper::createWeak(value.getFunction(runtime), runtime, jsInvoker);
  BOOL __block wrapperWasCalled = NO;
  RCTResponseSenderBlock callback = ^(NSArray *responses) {
    if (wrapperWasCalled) {
      throw std::runtime_error("callback arg cannot be called more than once");
    }

    auto strongWrapper = weakWrapper.lock();
    if (!strongWrapper) {
      return;
    }

    strongWrapper->jsInvoker().invokeAsync([weakWrapper, responses]() {
      auto strongWrapper2 = weakWrapper.lock();
      if (!strongWrapper2) {
        return;
      }

      const jsi::Value* args = convertNSArrayToJSICStyleArray(strongWrapper2->runtime(), responses);
      strongWrapper2->callback().call(strongWrapper2->runtime(), args, static_cast<size_t>(responses.count));
      strongWrapper2->destroy();
      delete[] args;
    });

    wrapperWasCalled = YES;
  };

  return [callback copy];
}
