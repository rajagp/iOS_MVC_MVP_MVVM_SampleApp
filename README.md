# Overview
This repo includes a sample application that demonstrates the MVC, MVP and MVVM architecture patterns on iOS. 
- Xcode 8.3
- Swift 3.2

The application accepts search criteria from the user and pulls in movie data using the OMDb service based on the seatch criteria. The results are displayed in the app and the user can get more details on a specific title.
- The OMDb API:https://www.omdbapi.com
- The unit test coverage is not complete but is is enough to get started. When running in test mode, the requests are stubbed out and responses returned from a local file bundled in the app.

![](http://www.priyaontech.com/wp-content/uploads/2017/01/moviedemo.gif)

# Details
An overview of the patterns is available at http://www.priyaontech.com/2017/01/mvc-mvp-and-mvvm-patterns-on-ios/
There is also a PDF document (iOS_MVP_MVVM_Patterns.pdf) available in this repo that provides details on how the patterns are implemented in the context of the sample app.

#Repo Structure
* The *mvc folder* contains the Model View Controller (MVC) version of the app
* The *mvp folder* contains the Model View Presenter (MVP) version of the app
* The *mvvm folder* contains the Model View View Model (MVVM) version of the app


#License
MIT License. See LICENSE for details.


