import math = require('../src/main/math');

var tests = {
	"test sum": function(test) {
		test.strictEqual(math.sum(5,2), 7);
		test.done();
	}
};

export = tests;
