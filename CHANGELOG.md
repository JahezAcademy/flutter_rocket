
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
- Optimization (add) method of McController & possible to add McRequest in controller
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
- Add on McView [call] parameter for call request method & [callType] for define how call function will call (call as future or as stream or call when model is empty) & [secondsOfStream] for define seconds for update data from call method when choose callAsStream callType

## [0.0.2] 

- fix some bugs & optimizated the code

## [0.0.2+1] 

- add [onError] Function(error) parameter for getJson methods for handle errors & exceptions
- handle errors & exceptions in McView widget
- add [showExceptionDetails] parameter for show errors details in UI
- add [exception] & [statusCode] in McModel for models
- add [params] & [data] as body parameter for post methods
- add [debugging] parameter for enable or disable debugging
- add [McMV] & [McValue] for simple case
- add [merge] method in [McValue] for use multiple [McValue] in one [McMV]
- replace exception & statusCode to McException bject for capture api, framework error
- create [McListenable] & use it instead of [ChangeNotifier] object
- add & call multi VoidCallback by one key
- use McException on setException of McModel instead of exception & statusCode
- add [onError] builder in McView for handle errors in widget
- removed [showExceptionDetails] parameter in McView
- removed [complex] parameter in [McRequest] methods
- in [McView] passed on [onError] builder [McException] msg of error and reload method for use it for retry 
- removed unused parameter on [McView] Builder
