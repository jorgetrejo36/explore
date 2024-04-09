# explore

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



![Running app](https://github.com/ucfcs/GrowthPlus/assets/45129978/2f8d2a5a-7046-4d92-86c7-d78ae4e4183e)

## Contributing

Check out [CONTRIBUTING.md](https://github.com/ucfcs/GrowthPlus/blob/main/CONTRIBUTING.md) for the process for submitting pull requests to us and for details on our code of conduct.
















# Flutter App with Realm Database Setup Guide

This guide will walk you through the steps to set up and run a Flutter app project with a Realm database using an Android emulator.

## Prerequisites

- Flutter SDK installed: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Android Studio installed: [Android Studio Installation Guide](https://developer.android.com/studio/install)
- Emulator installed and set up: [Android Emulator Setup Guide](https://developer.android.com/studio/run/emulator)
- Realm Dart package installed: [Realm Dart Installation Guide](https://pub.dev/packages/realm#-installing-tab-)

## Steps

1. **Clone the Repository:**

git clone [https://github.com/jorgetrejo36/explore.git]


3. **Open the Project in Android Studio:**

Open Android Studio and select `Open an existing Android Studio project`. Navigate to the cloned repository directory and select it.

4. **Install Dependencies:**

Open a terminal within Android Studio or navigate to the project directory in your system's terminal and run:

flutter pub get


5. **Set Up Android Emulator:**

Launch Android Studio and open the AVD Manager. Create a new virtual device if you haven't already done so. Start the emulator.

6. **Run the App:**

Ensure that your emulator is running, then run the Flutter app by executing:

flutter run


7. **Verify Installation:**

Once the app is built and deployed on the emulator, verify that it's running correctly and interacting with the Realm database as expected.

## Additional Notes

- Make sure to configure Realm according to your application's needs. Refer to the [Realm Dart Documentation](https://docs.mongodb.com/realm-dart/latest/) for more information.
- Troubleshoot any errors or issues encountered during setup by referring to Flutter and Realm documentation or seeking help from the community.





