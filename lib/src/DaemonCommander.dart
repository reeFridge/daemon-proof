import 'dart:io';

abstract class AbstractDaemonCommander {
	bool isDaemonRunning();
	void startDaemon();
	void killDaemon();
	void restartDaemon();
}

class DaemonCommander extends AbstractDaemonCommander {
	DaemonCommander();
	
	bool isDaemonRunning() {
		return new File('./pidfile').existsSync();
	}
	
	void startDaemon() {
		_requireDaemon((int pid) {
			stdout.writeln('Daemon already running with pid: $pid');
		}, _spawnDaemon);
	}
	
	void killDaemon() {
		_requireDaemon((int pid) {
			stdout.writeln('Kill daemon with pid $pid.');
			Process.killPid(pid);
		}, () => stdout.writeln('No daemon process to kill it.'));
	}
	
	void restartDaemon() {
		_requireDaemon((int pid) {
			stdout.writeln('Restart daemon with pid $pid.');
			killDaemon();
			_spawnDaemon();
		}, () => stdout.writeln('No daemon process to restart it.'));
	}
	
	_requireDaemon(void onExist(int), void onNotExist()) {
		if (isDaemonRunning()) {
			onExist(int.parse(new File('./pidfile').readAsStringSync()));
		} else {
			onNotExist();
		}
	}
	
	_spawnDaemon() {
		Process.start(
			'dart',
			['./bin/daemon.dart'],
			mode: ProcessStartMode.DETACHED,
			includeParentEnvironment: false
		).then((Process proc) {
			stdout.writeln('Daemon runs with pid: ${proc.pid}');
		});
	}
}
