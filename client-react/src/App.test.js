import React from 'react';
import { render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import App from './App';
import CompletedOrders from './components/completedOrders.component.';

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

  xit('does not render the CompletedOrders component when the route does not match', () => {
    render(
      <MemoryRouter initialEntries={['/']}>
        <Routes>
          <Route
            path="/customers/:customerId/completed_orders"
            element={<App />}
          />
        </Routes>
      </MemoryRouter>
    );

    expect(screen.queryByText('Completed Orders')).not.toBeInTheDocument();
  });
});
