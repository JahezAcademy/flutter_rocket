// default key for RocketRequest object
const String rocketRequestKey = "rocketRequest";

const String rocketSizeScreenKey = "sizeScreen";
const String rocketSizeDesignKey = "sizeDesign";

const String rocketMiniRebuild = "miniRebuild";
const String rocketMergesRebuild = "mergesRebuild";
const String rocketRebuild = "rebuild";


enum HttpMethods{
  post,
  get,
  delete,
  put
}

enum RocketState{
  loading,
  done,
  failed,  
}

/// call طريقة استدعاء دالة

enum CallType {
  /// يتم استدعاء الدالة يشكل متكرر
  callAsStream,

  /// يتم استدعاء الدالة مرة واحدة
  callAsFuture,

  /// يتم استدعاء الدالة عندما يكون النموذج فارغ
  callIfModelEmpty,
}