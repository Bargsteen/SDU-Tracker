# ActivityTracker

## Tips For Developing
 * Tracker keeps its settings, such as users, end-of-tracking date etc., in the UserDefaults. To clear them run the following in a terminal: `defaults delete dk.sdu.devicetracker` The last part has to match the identifier of the app exactly, and is case-sensitive.
 * [Carthage](https://github.com/Carthage/Carthage) is the primary package manager being used. The file `Cartfile` contains the list of packages used. To update the packages, use the following command in terminal, while being inside the project: `carthage update --new-resolver --platform MacOS` (I've found the `--new-resolver` to be faster in general, but it is optional).

## Building the Release
 * Build and Archive the application (preferably signed) in XCode.
 * Create a `.dmg` with the install script.
    * Open [dmgCreator](https://sourceforge.net/projects/dmgcreator/).
    * Add the following files to the `Source` box:
      * The `Installer` shell script ([change its icon](https://9to5mac.com/2019/01/17/change-mac-icons/) to `images/SDU_Tracker_512x512.icns`).
      * A new folder `.Manuel installering` (notice the `.`, making it hidden) with the generated `.app` file from the archiving step inside.
    * Add the `images/dmgBackground.png` as the `Background Image`.
    * Add the `images/SDU_Tracker_512x512.icns` as the `Volume Icon`.
    * Write `ActivityTrackerSDU-X.Y.Z` in the `Disk Image File Name` and the `Volume Name` fields. (X.Y.Z being the app-version)
    * Uncheck the `Symbolic Link to "Applications"`.
    * Choose a destination folder.
    * Press `Prepare`.
      * The goal is now to _move_ the `Installer` icon over the black dot on the background image. This can be tricky, as the background is not always shown, but Finder usually shows it, if you close down the initial window and opens it again.
      * Once in position, close the Finder window and return to dmgCreator.
    * Press `Finish`.

## Cuckoo Mocking Framework
Mocking in Swift is a bit tricky, because the language does not have runtime reflection. Instead code generation is used.
[Cuckoo](https://github.com/Brightify/Cuckoo) is the most popular mocking framework, but it is a bit tricky to use.

### Mock generation
You specify which protocols to mock in a _Run Script_ phase of the test project's _Build Phases_.
This script generates a file **GeneratedMocks.swift** which resides in the test folder.

The file generated file becomes outdated, when you change one of your mocked protocols. 
In that case you need to delete the file and regenerate it by building the test project.
The test project will not build completely, because it is missing the reference to the file, which you will have to re-add and the rebuild.

### Limitations
Cuckoo can currently not mock generic functions. See the limits on the github page.
