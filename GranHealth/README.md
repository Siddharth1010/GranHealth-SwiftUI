![App Brewery Banner](Documentation/AppBreweryBanner.png)

# GranHealth

## Our Goal

Almost 70% of senior citizens suffer from Alzheimers and other neurological conditions, apart from regular health issues. In some cases, they forget where they are. This could cause potential harm and make it extremely difficult for us to track them down. GranHealth is an iOS application that a person can use to monitor the health, fitness and location status of an elderly family member / loved one.  

## How it Works

Apple Watches are equipped with sensors that measure parameters such as Heart Rate and ECG along with the calculation of fitness data. We extract such data at regular intervals and transfer it to FireStore. This data is accessed by the users iPhone and can be monitored. Data leak will not be a problem as a connection will establish only when both the iPhones are logged in with the same credentials. 

<center>
![pasted image 0](https://user-images.githubusercontent.com/59433969/109671108-caf1f780-7b99-11eb-95a7-ee745c441414.png)
<img src ="https://user-images.githubusercontent.com/59433969/109671108-caf1f780-7b99-11eb-95a7-ee745c441414.png" />
</center>

## What you will learn

* How to integrate third party libraries in your app using Cocoapods and Swift Package Manager.
* How to store data in the cloud using Firebase Firestore.
* How to query and sort the Firebase database.
* How to use Firebase for user authentication, registration and login.
* How to work with UITableViews and how to set their data sources and delegates.
* How to create custom views using .xib files to modify native design components.
* How to embed View Controllers in a Navigation Controller and understand the navigation stack.
* How to create a constants file and use static properties to store Strings and other constants.
* Learn about Swift loops and create animations using loops.
* Learn about the App Lifecycle and how to use viewWillAppear or viewWillDisappear.
* How to create direct Segues for navigation.


# Constants
```
struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

```

>This is a companion project to The App Brewery's Complete App Developement Bootcamp, check out the full course at [www.appbrewery.co](https://www.appbrewery.co/)

![End Banner](Documentation/readme-end-banner.png)
