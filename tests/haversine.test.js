import { haversine } from '../controller/utils/haversvine';
import request from 'supertest';
describe('Haversine Function', () => {
	it('should calculate the distance between two points', () => {
		const distance = haversine(51.5, 0, 38.8, -77.1);
		const expected = 5918240;
		const tolerance = 55; // meters

		expect(Math.abs(distance - expected)).toBeLessThan(tolerance);
	});
});
