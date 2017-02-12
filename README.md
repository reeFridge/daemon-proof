# daemon-proof
Proof-of-concept daemon application on Dart lang.

#Using
```
dart bin/main.dart [-o | --option]
```

##Allowed options:
* *start* - spawn daemon process. (**default**)
* *restart* - kill'n'start daemon as new process.
* *kill* - just kills daemon by sending SIGTERM signal to it.

