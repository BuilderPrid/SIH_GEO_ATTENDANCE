const request = require('supertest');
const app = require('../src/app'); // no need for .js extension in CommonJS

describe('App', () => {
	it('should have a /users route', async () => {
		const res = await request(app).get('/users');
		expect(res.statusCode).toBe(200);
	});

	it('should have a /admin route', async () => {
		const res = await request(app).get('/admin');
		expect(res.statusCode).toBe(200);
	});
});

