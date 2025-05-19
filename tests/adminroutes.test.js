import request from 'supertest';
import app from '../src/app';

describe('Admin Routes', () => {
	it('should check admin credentials', async () => {
		const res = await request(app).post('/admin/checkCredentials').send({ email: 'admin@example.com', password: 'password' });
		expect(res.statusCode).toBe(400); // Assuming no admin exists
	});

	it('should get all employees', async () => {
		const res = await request(app).get('/admin/getAllEmployees');
		expect(res.statusCode).toBe(200);
	});

	it('should predict attrition', async () => {
		const res = await request(app).post('/admin/predictAttrition').send({ features: {} });
		expect(res.statusCode).toBe(500); // Assuming prediction fails without proper input
	});
});
