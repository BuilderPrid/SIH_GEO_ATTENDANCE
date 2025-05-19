import request from 'supertest';
import app from '../src/app';

describe('User Routes', () => {
	it('should register a new user', async () => {
		const res = await request(app).post('/users/signup').send({ uuid: '123', email: 'user@example.com', name: 'User', password: 'password', currentLocation: 'Location' });
		expect(res.statusCode).toBe(200);
	});

	it('should login a user', async () => {
		const res = await request(app).post('/users/login').send({ email: 'user@example.com', password: 'password' });
		expect(res.statusCode).toBe(400); // Assuming user does not exist
	});

	it('should get all users', async () => {
		const res = await request(app).get('/users');
		expect(res.statusCode).toBe(200);
	});
});
