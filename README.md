# SDU Tracker MacOS

SDU Tracker tracks the computer usage of participants in a [IT-health research study by Syddansk University](https://www.researchgate.net/publication/340106467_Short-term_efficacy_of_reducing_screen_media_use_on_physical_activity_sleep_and_physiological_stress_in_families_with_children_aged_4-14_study_protocol_for_the_SCREENS_randomized_controlled_trial).

It has the following features:
   - Tracking of user sessions, i.e. when a user starts or ends work fx by logging in or out
   - Tracking of app-specific usage, i.e. which apps are in focus and when
   - Uploads all logged data to a SDU database
   - Handles and differentiates between multiple users per computer (even with just one system user)
   - Can be setup using a link or QR-code, which also determines the date for automatic termination
      - The researchers send out invite links to the participants, which sets up their ID, type of tracking, and termination date in SDU Tracker
      - [The links are generated with this webapp](https://github.com/Bargsteen/SDU-Tracker-Setup)
   - Automatically terminates tracking at a given date
   - [A version for Windows also exists](https://github.com/Bargsteen/SDU-Tracker-Windows)
   

## Tips For Developing
 * Tracker keeps its settings, such as users, end-of-tracking date etc., in the UserDefaults. To clear them run the following in a terminal: `defaults delete dk.sdu.devicetracker` The last part has to match the identifier of the app exactly, and is case-sensitive.
 * [Carthage](https://github.com/Carthage/Carthage) is the primary package manager being used. The file `Cartfile` contains the list of packages used. To update the packages, use the following command in terminal, while being inside the project: `carthage update --new-resolver --platform MacOS` (I've found the `--new-resolver` to be faster in general, but it is optional).
 
 ### Removal of Secrets
The username and password for the database have been replaced with '\*\*\*REMOVED\*\*\*' everywhere, including previous commits, by using [BFG](https://rtyley.github.io/bfg-repo-cleaner/).
A git-safe way of handling secrets should be implemented.
A temporary fix to make the app functional is to reinsert the secrets.

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
