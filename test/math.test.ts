import math = require('../src/main/math');

export function testSum(test) {
	test.strictEqual(math.sum(5,2), 7);
	test.done();
}