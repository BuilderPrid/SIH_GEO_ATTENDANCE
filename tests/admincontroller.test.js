import { checkAdminCredentials, getAllEmployees, predictAttrition } from '../controller/admin';
import { jest } from '@jest/globals';

describe('Admin Controller', () => {
	it('should check admin credentials', async () => {
		const req = { body: { email: 'admin@example.com', password: 'password' } };
		const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
		await checkAdminCredentials(req, res);
		expect(res.status).toHaveBeenCalledWith(400);
	});

	it('should get all employees', async () => {
		const req = {};
		const res = { json: jest.fn() };
		await getAllEmployees(req, res);
		expect(res.json).toHaveBeenCalled();
	});

	it('should predict attrition', async () => {
		const req = { body: {} };
		const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
		await predictAttrition(req, res);
		expect(res.status).toHaveBeenCalledWith(500);
	});
});
