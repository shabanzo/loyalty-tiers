import React from 'react';
import { render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import App from './App';
import CompletedOrders from './components/completedOrders.component';
import LoyaltyStats from './components/loyaltyStats.component';

describe('App Component', () => {
  it('renders the CompletedOrders component when the route matches', () => {
    render(
      <MemoryRouter initialEntries={['/customers/123/completed_orders']}>
        <Routes>
          <Route
            path="/customers/:customerId/completed_orders"
            element={<CompletedOrders />}
          />
        </Routes>
      </MemoryRouter>
    );

    expect(screen.getByText('Completed Orders')).toBeInTheDocument();
  });

  it('renders the LoyaltyStats component when the route matches', () => {
    render(
      <MemoryRouter initialEntries={['/customers/123/loyalty_stats']}>
        <Routes>
          <Route
            path="/customers/:customerId/loyalty_stats"
            element={<LoyaltyStats />}
          />
        </Routes>
      </MemoryRouter>
    );

    expect(screen.queryByText('Loyalty Stats')).toBeInTheDocument();
  });
});
