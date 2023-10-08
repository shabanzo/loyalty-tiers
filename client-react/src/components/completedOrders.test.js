import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import CompletedOrders from './completedOrders.component';

describe('CompletedOrders Component', () => {
  it('renders the component with data', async () => {
    // Mock a successful fetch response
    const mockData = [
      { id: 1, date: '2023-01-01', total_in_cents: 6666 },
      { id: 2, date: '2023-01-02', total_in_cents: 7777 },
    ];
    const fetchMock = jest.spyOn(global, 'fetch').mockImplementation(() =>
      Promise.resolve({
        json: () => Promise.resolve(mockData),
      })
    );

    render(<CompletedOrders />);

    // Wait for data to load
    await waitFor(() => screen.getByText('$66.66'));

    // Assert that the component renders with the initial data
    expect(screen.getByText('ID')).toBeInTheDocument();
    expect(screen.getByText('Date')).toBeInTheDocument();
    expect(screen.getByText('Total')).toBeInTheDocument();
    expect(screen.getByText('$66.66')).toBeInTheDocument();
    expect(screen.getByText('$77.77')).toBeInTheDocument();
    expect(fetchMock).toHaveBeenCalledTimes(1);

    fetchMock.mockRestore();
  });
});
