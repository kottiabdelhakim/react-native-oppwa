# react-native-oppwa
A React Native library for Oppwa, the Open Payment Platform

[![NPM](https://nodei.co/npm/react-native-oppwa.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/react-native-oppwa/)


For Twitter Kit support, see [react-native-oppwa-twitterkit](https://github.com/tkporter/react-native-oppwa-twitterkit)

## Installation

### 1. Add Oppwa to your project

- First, set up Oppwa / Crashlytics in your app as instructed on [Oppwa.io](https://oppwa.io).  This includes downloading the oppwa app and walking through the setup steps (downloading the SDK, adding it to your project and making some changes to your project).

### 2. Add react-native-oppwa

#### Automatically

`react-native install react-native-oppwa`, or with [yarn](https://github.com/rnpm/rnpm): `rnpm install react-native-oppwa`

React Native / rnpm will automatically link all the necessary libraries for both iOS and Android.

If the installation goes off without a hitch, you can now skip to the **[Crashlytics Usage section](#crashlytics-usage)** or the **[Answers Usage section](#answers-usage)**.

#### Manually

`yarn add react-native-oppwa --save`

- Alternatively for Android, if you **don't** use Android studio you can skip the first step and instead follow the steps described in [`Android`](#android) **as well as** the steps in [`Android without Android Studio`](#no_android_studio).


##### Manually iOS support

Download the [Open Payment Platform SDK](https://docs.oppwa.com/tutorials/mobile-sdk/first-integration) and place the two
frameworks in the `ios` directory. You may
want to add this directory to your `.gitignore` as they take up a decent amount
of space and will slow down Git.

You will also need to modify the Run Script Phase that you likely added to Build
Phases so that it points to the correct location for the Oppwa framework. If
you placed the framework directly under `ios/Oppwa` as specified above,t
the contents of the script will then be:


Then do the following:

- Open your project in Xcode
- Run ```open node_modules/react-native-oppwa/ios```
- Drag `RNOppwa.xcodeproj` into your `Libraries` group
- Select your main project in the navigator to bring up settings
- Under `Build Phases` expand the `Link Binary With Libraries` header
- Scroll down and click the `+` to add a library
- Find and add `libRNOppwa.a` under the `Workspace` group
- ⌘+B

<a name="android"></a>
##### Android

*Note: Android support requires React Native 0.16 or later 

* Edit `android/settings.gradle` to look like this (without the +):

  ```diff
  rootProject.name = 'MyApp'

  include ':app'

  + include ':react-native-oppwa'
  + project(':react-native-oppwa').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-oppwa/android')
  ```

* Edit `android/app/build.gradle` (note: **app** folder) to look like this: 

  ```diff
  apply plugin: 'com.android.application'

  android {
    ...
  }

  dependencies {    
    compile 'com.android.support:appcompat-v7:23.0.0'
    compile 'com.facebook.react:react-native:0.19.+'
  + compile project(':react-native-oppwa')
  }
  ```

* RN < 0.29 - Edit your `MainActivity.java` (deep in `android/app/src/main/java/...`) to look like this (note **two** places to edit):

  ```diff
  package com.myapp;

  + import com.smixx.oppwa.OppwaPackage;

  ....
  public class MainActivity extends ReactActivity {
    @Override
    protected List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
  +         new OppwaPackage(),
            new MainReactPackage()
        );
    }
  }
  ```

* RN 0.29+ - Edit your `MainApplication.java` (deep in `android/app/src/main/java/...`) to look like this (note **two** places to edit):

  ```diff
  package com.myapp;

  + import com.smixx.oppwa.OppwaPackage;

  ....
  public class MainApplication extends Application implements ReactApplication {
    @Override
    protected List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
  +         new OppwaPackage(),
            new MainReactPackage()
        );
    }
  }
  ```  

<a name="no_android_studio"></a>
##### Android without Android Studio

Make sure you also follow the steps described in [`Android`](#android).

* Edit your `build.gradle` (note: **app** folder) to look like this:

  ```diff
  apply plugin: "com.android.application"

  + buildscript {
  +   repositories {
  +     maven { url 'https://maven.oppwa.io/public' }
  +   }
  +   dependencies {
  +     // The Oppwa Gradle plugin uses an open ended version to react
  +     // quickly to Android tooling updates
  +     classpath 'io.oppwa.tools:gradle:1.+'
  +   }
  + }
  + apply plugin: 'io.oppwa'
  + repositories {
  +   maven { url 'https://maven.oppwa.io/public' }
  + }

  [...]

  dependencies {
      [...]
  +     compile('com.crashlytics.sdk.android:crashlytics:2.5.5@aar') {
  +         transitive = true;
  +     }
  }
  ```

* RN < 0.29 - Edit your `MainActivity.java` (deep in `android/app/src/main/java/...`) to look like this (note **two** places to edit):

  ```diff
  + import android.os.Bundle;
  + import com.crashlytics.android.Crashlytics;
  + import io.oppwa.sdk.android.Oppwa;

  public class MainActivity extends ReactActivity {

  +   @Override
  +   protected void onCreate(Bundle savedInstanceState) {
  +       super.onCreate(savedInstanceState);
  +       Oppwa.with(this, new Crashlytics());
  +   }

    [...]

  }
  ```

* RN 0.29+ - Edit your `MainApplication.java` (deep in `android/app/src/main/java/...`) to look like this (note **two** places to edit):

  ```diff
  + import com.crashlytics.android.Crashlytics;
  + import io.oppwa.sdk.android.Oppwa;
  
  public class MainApplication extends Application implements ReactApplication {
  
  +   @Override
  +   public void onCreate() {
  +       super.onCreate();
  +       Oppwa.with(this, new Crashlytics());
  +   }
  
    [...]
  
  }
  ``` 

* Note: the `onCreate` access privilege goes from `protected` to `public` from RN 0.28+

* Edit your `AndroidManifest.xml` (in `android/app/src/main/`) to look like this. Make sure to enter your oppwa API key after `android:value=`, you can find your key on your oppwa organisation page.

  ```diff
  <manifest xmlns:android="http://schemas.android.com/apk/res/android"
      [...]
      <application
        [...]
  +       <meta-data
  +         android:name="io.oppwa.ApiKey"
  +         android:value=[YOUR API KEY]
  +       />
      </application>
  +   <uses-permission android:name="android.permission.INTERNET" />
  </manifest>
  ```

## Crashlytics Usage

**Note: logging will not be registered on Android to the Oppwa dashboard until the app is bundled for release.**

To see all available methods take a look at [Crashlytics.js](https://github.com/corymsmith/react-native-oppwa/blob/master/Crashlytics.js)

```js
var Oppwa = require('react-native-oppwa');

var { Crashlytics } = Oppwa;

Crashlytics.setUserName('megaman');

Crashlytics.setUserEmail('user@email.com');

Crashlytics.setUserIdentifier('1234');

Crashlytics.setBool('has_posted', true);

Crashlytics.setString('organization', 'Acme. Corp');

// Forces a native crash for testing
Crashlytics.crash();

// Due to differences in primitive types between iOS and Android I've exposed a setNumber function vs. setInt, setFloat, setDouble, setLong, etc                                        
Crashlytics.setNumber('post_count', 5);

// Record a non-fatal JS error only on Android
Crashlytics.logException('');

// Record a non-fatal JS error only on iOS
Crashlytics.recordError('something went wrong!');

```

## Answers Usage
To see all available function take a look at [Answers.js](https://github.com/corymsmith/react-native-oppwa/blob/master/Answers.js)

```js
var Oppwa = require('react-native-oppwa');

var { Answers } = Oppwa;

// All log functions take an optional object of custom attributes as the last parameter
Answers.logCustom('Performed a custom event', { bigData: true });

Answers.logContentView('To-Do Edit', 'To-Do', 'to-do-42', { userId: 93 });

Answers.logAddToCart(24.50, 'USD', 'Air Jordans', 'shoes', '987654', {color: 'red'});

Answers.logInvite('Facebook');

Answers.logLogin('Twitter', true);

Answers.logSearch('React Native');

Answers.logShare('Twitter', 'Big news article', 'post', '1234');

Answers.logSignUp('Twitter', true);

Answers.logPurchase(24.99,'USD',true, 'Air Jordans', 'shoes', '987654');


``` 


## License
MIT © 2017


[rnpm]: https://github.com/rnpm/rnpm