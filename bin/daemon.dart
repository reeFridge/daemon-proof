import 'dart:io';
import 'dart:core';

void main(List<String> args) {
	ProcessSignal.SIGUSR1.watch()
		.listen((sig) => exit(0));
	
	ProcessSignal.SIGTERM.watch().listen((ProcessSignal sig) {
		File pidFile = new File('./pidfile');
		pidFile.exists().then((bool exist) {
			if (exist) {
				pidFile.deleteSync();
			}
			exit(0);
		});
	});
	
	ServerSocket.bind(InternetAddress.LOOPBACK_IP_V4, 6649)
		.then((ServerSocket socket) {
			socket.listen(handleClient);
	});
}

void handleClient(Socket client) {
	client.writeln('[DAEMON-PROOF] Listen for your commands');
	client.listen(handleMessage, onDone: () => client.close());
}

void handleMessage(List<int> data) {
	String message = new String.fromCharCodes(data).trim();
	File log = new File('./log');
	log.writeAsStringSync('MESSAGE RECEIVED: $message\n', mode: FileMode.APPEND);
}