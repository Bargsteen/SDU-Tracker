# ActivityTracker

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
