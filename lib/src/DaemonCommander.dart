import 'dart:io';

abstract class AbstractDaemonCommander {
	bool isDaemonRunning();
	void startDaemon();
	void killDaemon();
	void restartDaemon();
	set commands(Map<String, Function> commands);
	void command(String command);
}

class DaemonCommander extends AbstractDaemonCommander {
	File _pidFile;
	String _daemonScript;
	Map<String, Function> _commands;
	DaemonCommander(String script, [ String pidFilePath = './pidfile' ])
		: _daemonScript = script, _pidFile = new File(pidFilePath);
	
	bool isDaemonRunning() {
		return _pidFile.existsSync();
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
	
	void _requireDaemon(void onExist(int), void onNotExist()) {
		if (isDaemonRunning()) {
			onExist(int.parse(_pidFile.readAsStringSync()));
		} else {
			onNotExist();
		}
	}
	
	void _spawnDaemon() {
		Process.start(
			'dart',
			[ _daemonScript, '-p', _pidFile.path],
			mode: ProcessStartMode.DETACHED,
			includeParentEnvironment: false
		).then((Process proc) {
			stdout.writeln('Daemon runs with pid: ${proc.pid}');
		});
	}
	
	set commands(Map<String, Function> commands) => _commands = commands;
	
	void command(String command) => _commands[command]();
}
