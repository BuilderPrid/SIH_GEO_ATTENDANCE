import { haversine } from '../controller/utils/haversvine';
import request from 'supertest';
describe('Haversine Function', () => {
	it('should calculate the distance between two points', () => {
		const distance = haversine(51.5, 0, 38.8, -77.1);
		expect(distance).toBeCloseTo(5918240, -1); // Distance in meters
	});
});
