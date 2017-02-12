import 'dart:io';

typedef void Payload();

abstract class AbstractDaemon {
	void createPidFile(String p);
	void removePidFile();
	void listenSignal(ProcessSignal s, void onSignal(ProcessSignal s));
	void executePayload();
}

class Daemon extends AbstractDaemon {
	File _pidFile;
	Payload _payload;
	
	Daemon(String pidFilePath, Payload payload,
		{ bool executePayloadOnStart = true }) : _payload = payload
	{
		createPidFile(pidFilePath);
		listenSignal(ProcessSignal.SIGTERM, (ProcessSignal signal) {
			removePidFile();
			exit(0);
		});
		
		if (executePayloadOnStart) {
			executePayload();
		}
	}
	
	void createPidFile(String path) {
		_pidFile = new File(path);
		_pidFile.writeAsStringSync(pid.toString());
	}
	
	void removePidFile() {
		if (_pidFile.existsSync()) {
			_pidFile.deleteSync();
		}
	}
	
	void listenSignal(ProcessSignal signal,
		void onSignal(ProcessSignal signal)) {
		signal.watch().listen(onSignal);
	}
	
	void executePayload() => _payload();
}