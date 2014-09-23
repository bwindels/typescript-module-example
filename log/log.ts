export interface Thing {
	a: string
	b: number
}

export function logSomething(foo: Thing) {
	console.log('log',foo.a,foo.b);
}