
## [0.0.1+1]
- Add example.
## [0.0.1+2]
- Add more Examples and add rebuild method in Model.
## [0.0.1+3]
- Support null safety
## [0.0.1+4]
- Change search parameter to params & add new parameter #path for get part of json & Add controller in model generator
## [0.0.1+5]
- fix bugs & add new item McController for add/get/remove your model Now you can use your model from another screen without traditional way
## [0.0.1+6]
- Optimization (add) method of McController & possible to add RocketRequest in controller
## [0.0.1+7] 
- fix bugs
- Inject [mc] (instance) of McController in Stateless and ful widget by extension for use it easily 
- remove path parameter
- add complex parameter for complex json
- add inspect parameter for complex json if complex true you need to define inspect by function return List of Map like this [{'item':'value1'},{'item':'value1'}] & if data already like this you dont need define complex and inspect
- add sendFile Method for send files 
## [0.0.1+8] 
- fix PUT bugs
- add params for post methods
- add setCookies parameter for enable and disable setCookie
## [0.0.1+9] 
- Add generics types
- Add on RocketView [call] parameter for call request method & [callType] for define how call function will call (call as future or as stream or call when model is empty) & [secondsOfStream] for define seconds for update data from call method when choose callAsStream callType

## [0.0.2] 

- fix some bugs & optimizated the code

## [0.0.2+1] 

- add [onError] Function(error) parameter for getJson methods for handle errors & exceptions
- handle errors & exceptions in RocketView widget
- add [showExceptionDetails] parameter for show errors details in UI
- add [exception] & [statusCode] in [RocketModel] for models
- add [params] & [data] as body parameter for post methods
- add [debugging] parameter for enable or disable debugging
- add [RocketMiniView] & [RocketValue] for simple case
- add [merge] static method in [RocketValue] for use multiple [RocketValue] in one [RocketMiniView]
- replace exception & statusCode to RocketException bject for capture api, framework error
- create [RocketListenable] & use it instead of [ChangeNotifier] object
- add & call multi [VoidCallback] by one key
- use [RocketException] on setException of [RocketModel] instead of exception & statusCode
- add [onError] builder in [RocketView] for handle errors in widget
- removed [showExceptionDetails] parameter in [RocketView]
- removed [complex] parameter in [RocketRequest] methods
- in [RocketView] passed on [onError] builder [RocketException] msg of error and reload method for use it for retry 
- removed unused parameter on [RocketView] Builder

## [1.0.0]
# Change package name to 🚀 MVCRocket 🚀
- rename package from mc to MVCRocket 🚀
- rename Objects
    * McView to RocketView.
    * McRequest to RocketRequest
    * McModel to RocketModel 
    * McController to RocketController
    * McMv to RocketMiniView
    * McValue to RocketValue
- add default value for onError on [RocketRequest] methods
- make loading automatic on [RocketView]
- use [Size] object instead of height an width double & inject [sizeScreen] extension in [BuildContext]
- use [log] instead of [print] for debugging mode
- optimized [_objData] method in [RocketRequest]
- optimized examples structure
- use [HashMap] instead of Map & add [hasKey] extension on [HashMap]
- use [LinkedList] instead of [List] & add extensions needed
- add const keys for RocketController [rocketRequestKey], [sizeScreenKey] & [sizeDesignKey]