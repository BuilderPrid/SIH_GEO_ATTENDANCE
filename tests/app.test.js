import request from 'supertest';
import http from 'http';
import app from '../src/app.js';

const server = http.createServer(app);

describe('App', () => {
	it('should have a /admin route', async () => {
		const res = await request(server).get('/admin/getAllEmployees');
		expect(res.statusCode).toBe(200);
	});
});

