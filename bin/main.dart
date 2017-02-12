import 'dart:io';
import 'package:args/args.dart';
import 'package:daemonproof/src/DaemonCommander.dart';

void main(List<String> args) {
	DaemonCommander dc = new DaemonCommander('./bin/daemon.dart');
	ArgParser parser = new ArgParser();
	
	var commands = new Map<String, Function>();
	commands['kill'] = dc.killDaemon;
	commands['restart'] = dc.restartDaemon;
	commands['start'] = dc.startDaemon;
	
	dc.commands = commands;
	
	parser.addOption('command',
		abbr: 'c',
		allowed: commands.keys,
		defaultsTo: 'start'
	);
	
	ArgResults results;
	try {
		results = parser.parse(args);
	} on FormatException catch(exception) {
		print(exception.message);
		exit(1);
	}
	
	dc.command(results['command']);
}