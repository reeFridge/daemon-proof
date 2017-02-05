# daemon-proof
Proof-of-concept daemon application on Dart lang.

#Using
```
dart bin/main.dart [-o | --option]
```
Without parameters - just spawn daemon process and exit.

##Allowed options:
* *restart* - kill'n'start daemon as new process.
* *kill* - just kills daemon by sending SIGTERM signal to it.

