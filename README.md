# Overview
This repo includes a sample application that demonstrates the MVC, MVP and MVVM architecture patterns on iOS. It is written in Swift 3.0.2. 

The application accepts search criteria from the user and pulls in movie data using the OMDb service based on the seatch criteria. The results are displayed in the app and the user can get more details on a specific title.
- The OMDb API:https://www.omdbapi.com
- The unit test coverage is not complete but is is enough to get started. When running in test mode, the requests are stubbed out and responses returned from a local file bundled in the app.

# Details
The  presentation that discusses the various architecture patterns is available in the iOS_MVP_MVVM_Patterns.pdf located in this repo

#Repo Structure
* The *mvc folder* contains the Model View Controller (MVC) version of the app
* The *mvp folder* contains the Model View Presenter (MVP) version of the app
* The *mvvm folder* contains the Model View View Model (MVVM) version of the app


#License
MIT License. See LICENSE for details.


