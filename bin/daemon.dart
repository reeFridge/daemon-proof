import 'dart:io';
import 'package:args/args.dart';
import 'package:daemonproof/src/Daemon.dart';

const int DEFAULT_PORT = 6649;

void main(List<String> args) {
	ArgParser parser = new ArgParser();
	parser.addOption('pid-file', abbr: 'p');
	ArgResults results = parser.parse(args);
	
	new Daemon(results['pid-file'], () {
		ServerSocket.bind(InternetAddress.LOOPBACK_IP_V4, DEFAULT_PORT)
			.then((ServerSocket socket) {
			socket.listen(handleClient);
		});
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