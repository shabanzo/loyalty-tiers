import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import LoyaltyStats from './loyaltyStats.component';

describe('LoyaltyStats Component', () => {
  it('renders the component with data', async () => {
    // Mock the fetch function and its response
    const mockData = {
      current_tier_name: 'Gold',
      downgrade_to: 'Silver',
      downgrade_date: '2023-12-31',
      remaining_to_retain: 1000,
      start_date: '2023-01-01',
      total_spent_cents: 5000,
    };

    const fetchMock = jest.spyOn(global, 'fetch').mockImplementation(() =>
      Promise.resolve({
        json: () => Promise.resolve(mockData),
      })
    );

    render(<LoyaltyStats />);

    // Wait for data to load
    await waitFor(() => screen.getByText('GOLD'));

    // Assert that the component renders with the initial data
    expect(screen.getByText('GOLD')).toBeInTheDocument();
    expect(fetchMock).toHaveBeenCalledTimes(1);

    fetchMock.mockRestore();
  });
});
