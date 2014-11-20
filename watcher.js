var exec = require('child_process').exec;
var colors = require('colors/safe');

function parseArguments(args) {
	var daemons = [];
	var daemon;
	var expectName, expectCwd;

	args.forEach(function(arg) {
		if(expectName) {
			daemon.name = arg;
			expectName = false;
		}
		else if(expectCwd) {
			daemon.cwd = arg;
			expectCwd = false;
		}
		else if(arg === '--cwd') {
			expectCwd = true;
		}
		else if(arg === '--name') {
			expectName = true;
		}
		else {
			daemon = {name:''};
			daemons.push(daemon);
			daemon.command = arg;
		}
	});

	return daemons;
}

function runDaemon(daemon) {
	console.log('starting',colors.grey(daemon.name),'...');
	var options = {};
	if(daemon.cwd) {
		options.cwd = daemon.cwd;
	}
	var proc = exec(daemon.command, options, function(err) {
		console.log(colors.grey(daemon.name),'exited');
	});
	proc.stdout.on('data', function(chunk) {
		process.stdout.write(colors.green(daemon.name)+': ');
		process.stdout.write(chunk);
	});
	proc.stderr.on('data', function(chunk) {
		process.stderr.write(colors.red(daemon.name)+': ');
		process.stderr.write(chunk);
	});
	return proc;
}

function sendSignalToDaemon(daemon, proc, signal) {
	proc.kill(signal);
}

function listenForSignals(daemons, procs) {
	var signals = ['SIGTERM','SIGINT'];
	signals.forEach(function(signal) {
		process.on(signal, function() {
			console.log('\nExiting with signal',signal);
			daemons.forEach(function(daemon, i) {
				var proc = procs[i];
				sendSignalToDaemon(daemon, proc, signal);
			});
		});
	});
}

var args = process.argv.slice(2);
var daemons = parseArguments(args);
var procs = daemons.map(runDaemon);

listenForSignals(daemons, procs);
