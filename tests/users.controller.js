import { register, loginUser, getAllUsers, getUserByUuid, updateUser, deleteUser } from '../controller/users';
import { jest } from '@jest/globals';

describe('User Controller', () => {
	it('should register a user', async () => {
		const req = { body: { uuid: '123', email: 'user@example.com', name: 'User', password: 'password', currentLocation: 'Location' } };
		const res = { json: jest.fn() };
		await register(req, res);
		expect(res.json).toHaveBeenCalled();
	});

	it('should login a user', async () => {
		const req = { body: { email: 'user@example.com', password: 'password' } };
		const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
		await loginUser(req, res);
		expect(res.status).toHaveBeenCalledWith(400);
	});

	it('should get all users', async () => {
		const req = {};
		const res = { json: jest.fn() };
		await getAllUsers(req, res);
		expect(res.json).toHaveBeenCalled();
	});
});
