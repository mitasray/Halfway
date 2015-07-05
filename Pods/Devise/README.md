# devise-ios

[![Circle CI](https://circleci.com/gh/netguru/devise-ios/tree/master.svg?style=svg)](https://circleci.com/gh/netguru/devise-ios/tree/master)

**devise-ios** is a simple client which automates connection with [Devise](https://github.com/plataformatec/devise). Specially created to work with [devise-ios backend gem](https://github.com/netguru/devise-ios-rails) to make your job easier and faster!

## Features:
**devise-ios** handles:
* user registration
* signing in / out
* password reminder
* form validation
* profile updating
* account deleting
* Facebook and Google+ lightweight signing in

## Requirements

- Xcode 6.0 and iOS 7.0+ SDK
- CocoaPods 0.36.0 (use `gem install cocoapods` to grab it!)

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party. To use **devise-ios** via CocoaPods write in your Podfile:

```rb
pod 'Devise', '~> 1.0.0'
```

## Configuration

Use `#import <Devise/Devise.h>` whenever you want to use **devise-ios**.

`[DVSConfiguration sharedConfiguration]` is a singleton to keep configuration in one place. At the very beginning, somewhere in `application:didFinishLaunchingWithOptions:` in your `AppDelegate` use:

```objc
[[DVSConfiguration sharedConfiguration] setServerURL:<#NSURL#>];
```

 **devise-ios** is also able to inform you about encountered problems. Logging is especially useful during debug process. There are 3 designed log levels:

* `DVSLoggingModeNone` - Don't log anything, ignore all messages.
* `DVSLoggingModeWarning` - Print all messages using NSLog.
* `DVSLoggingModeAssert` - Abort the code with the message.

To specify logging mode use:

 ```objc
[[DVSConfiguration sharedConfiguration] setLoggingMode:<#DVSLoggingMode#>];
```

 **devise-ios** takes care about network problems and is able to automatically retry requests in case of connection issues. You can specify a number and time between retries using `numberOfRetries` and `retryTresholdDuration` properties of `DVSConfiguration`.

 Devise uses `AFNetworking` under the hood. If needed network activity indicator can be enable through `AFNetworkActivityIndicatorManager` in `AppDelegate application:didFinishLaunchingWithOptions:`.

## User manager
The main class of **devise-ios** is `DVSUserManager`. Provided implementation is enough for login, registration, edition and any other features offered by **devise-ios**.

Functions are pretty straightforward and self-explanatory.

* User registration:

    ```objc
    - (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Profile update:

    ```objc
    - (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Signing in:

    ```objc
    - (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Signing in with Facebook account:

    ```objc
    - (void)signInUsingFacebookWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Signing in with Google Plus account:

    ```objc
    - (void)signInUsingGoogleWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

    To handle callback from Google Plus authorization implement one of `AppDelegate` method as following:

    ```objc
    - (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
        return [[DVSUserManager defaultManager] handleURL:url sourceApplication:sourceApplication annotation:annotation];
        //or instance of other DVSUserManager used to sign in via g+.
    }
    ```
    This guarantees that one of passed callbacks will be invoked as authorization result.

* Password reminder:

    ```objc
    - (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Password update:

    ```objc
    - (void)changePasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Account deleting:

    ```objc
    - (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

## User customization

Although `DVSUser` implementation is enough for a basic usage, you can customize it as well.

If it's needed to persist locally more info about `DVSUser` subclass (other than `email`, `sessionToken` and `identifier` - these are stored by default) conform `DVSUserPersisting` protocol. You can choose which properties should be persist by invoking:
```objc
- (NSArray *)propertiesToPersistByName;
```
Just remember to pass property names as `NSString`.

## User model validation and messaging

**devise-ios** under the hood uses [NGRValidator](https://github.com/netguru/ngrvalidator) to validate data. On top of it **devise-ios** delivers a possibility to add your own or modify default validation rules. If you wish to take benefit from it, conform `DVSUserManagerDelegate` protocol and implement `- (void)userManager:(DVSUserManager *)manager didPrepareValidationRules:(NSMutableArray *)validationRules forAction:(DVSActionType)action;` method.


Let's say a subclass of `DVSUser` has an additional property `NSString *registrationUsername` you want to validate during registration process to fulfill conditions:
* cannot be nil
* length should be at least 4 signs
* length should be at most 20 signs

and display appropriate messages when validation fails:

* when has less than 4 signs: "should has at least 4 signs"
* when has more than 20 signs: "should has at most 20 signs"

Moreover `registrationUsername` doesn't sound very well for a user, so it should be displayed as a "Username":

```objc
- (void)userManager:(DVSUserManager *)manager didPrepareValidationRules:(NSMutableArray *)validationRules forAction:(DVSActionType)action {

    NGRPropertyValidator *validator = NGRValidate(@"registrationUsername").required().lengthRange(5, 20).msgTooShort(@"should have at least 4 signs.").msgTooLong(@"should have at most 20 signs").localizedName(@"Username");
    [validationRules addObject:validator];
}
```

When user will provide string `foo` for `registrationUsername` property, **devise-ios** will return an `NSError` with localized description:

```objc
NSLog(@"%@", error.localizedDescription);
// Username should have at least 4 characters.
```

Simple as that! For more info please refer to [NGRValidator](https://github.com/netguru/ngrvalidator).

## Expanding networking

All right. But you didn't create subclass of `DVSUser` only for local purposes, did you? To attach own parameters to request, please conform `DVSUserJSONSerializerDataSource` like below:

```objc
- (void)setupManager {
    
    TestUser *user = [[TestUser alloc] init]; //TestUser is subclass of DVSUser with "foo" property
    
    self.manager = [[DVSUserManager alloc] initWithUser:user]; //manager is an ivar here
    self.manager.serializer.dataSource = self;
}

#pragma mark - DVSUserJSONSerializerDataSource

- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action {
    //use action to distinguish type of request
    TestUser *user = (TestUser *)self.manager.user;
    //make sure that foo is not nil. Eg. add own validation rule in userManager:didPrepareValidationRules:forAction: method
    return @{@"foo" : user.foo};
}
```
**devise-ios** will take care of the rest.

## UI Components

![Sign up view example](https://github.com/netguru/devise-ios/blob/master/doc/0_sign_up.jpg "Sign up view example")

At some point in your app you might want to prepare a quick setup for your users and allow them to log in and sign up. **devise-ios** provides a handy view controller, called `DVSAccountRetrieverViewController`, which simplifies that process. Here is a simple example of usage:

```objc
DVSAccountRetrieverViewController *logInController = [[DVSAccountRetrieverViewController alloc] initWithType:DVSRetrieverTypeLogIn fields:DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton];
logInController.delegate = self;
[self.navigationController pushViewController:logInController animated:YES];
```

Simple, right? As you can see initializer takes two parameters:`type` and `fields`. First one is defining how your view controller will act and look. If you want to perform log in action, you should pass `DVSRetrieverTypeLogIn`. Using it with `DVSAccountRetrieverViewController` will automatically configure proceed button title and tap event to perform log in request. For sign up action you can use `DVSRetrieverTypeSignUp` type.

`fields` is options parameter that defines which parts of view should be visible. For example, if you want to use simple form with only text fields and proceed button, you should define `fields` like:

```objc
DVSAccountRetrieverFields logInFields = DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton;
```

And the result will be:

![Log in view example](https://github.com/netguru/devise-ios/blob/master/doc/1_log_in.jpg "Log in view example")

If you want to add a password reminder to form, just use following combination:

```objc
DVSAccountRetrieverFields logInFields = DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton | DVSAccountRetrieverFieldPasswordReminder;
```

Result:

![Log in view with reminder example](https://github.com/netguru/devise-ios/blob/master/doc/2_log_in_with_reminder.jpg "Log in view with reminder example")

In order to handle result of performed action, your class should override two `DVSAccountRetrieverViewControllerDelegate` protocol methods:

```objc
// for success
- (void)accountRetrieverViewController:(DVSAccountRetrieverViewController *)controller didSuccessForAction:(DVSRetrieverAction)action user:(DVSUser *)user;

// for failure
- (void)accountRetrieverViewController:(DVSAccountRetrieverViewController *)controller didFailWithError:(NSError *)error forAction:(DVSRetrieverAction)action;
```

In both cases view controller will return `action` variable, that defines type of finished action and can have one of values: `DVSRetrieverActionLogIn`, `DVSRetrieverActionSignUp`, `DVSRetrieverActionPasswordRemind`. Success callback additionally will return corresponded user object saved in `user`.

`DVSAccountRetrieverViewController` doesn't implement autoclose feature. A developer is responsible for deciding when to close a view. To help with this task, **devise-ios** provides additional callback in `DVSAccountRetrieverViewControllerDelegate` that is executed when a user tapps a dismiss button:

```objc
- (void)accountRetrieverViewControllerDidTapDismiss:(DVSAccountRetrieverViewController *)controller;
```

## Demo
Implements full account [lifecycle](#Features). Contains also an example with simple `DVSUser` subclassing and validation. To run demo please follow the instructions below:

```bash
$ git clone --recursive git@github.com:netguru/devise-ios.git
$ pod install
```

or if you already cloned the project without `--recursive`:

```bash
$ git submodule update --init --recursive
$ pod install
```

## License
**devise-ios** is available under the [MIT license](https://github.com/netguru/devise-ios/blob/master/LICENSE.md).

## Contribution
First, thank you for contributing!

Here's a few guidelines to follow:

- we follow [Ray Wenderlich Style Guide](https://github.com/raywenderlich/objective-c-style-guide).
- write tests
- make sure the entire test suite passes

## More Info

Have a question? Please [open an issue](https://github.com/netguru/devise-ios/issues/new)!
You can also read our blog post [announcing devise-iOS for simplified auth](https://netguru.co/blog/open-source-announcing-devise-ios).

##
Copyright © 2014-2015 [Netguru](https://netguru.co)
