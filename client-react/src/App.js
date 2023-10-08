import './App.css';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CompletedOrders from './components/completedOrders.component';
import LoyaltyStats from './components/loyaltyStats.component';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="/customers/:customerId/completed_orders"
          element={<CompletedOrders />}
        />
        <Route
          path="/customers/:customerId/loyalty_stats"
          element={<LoyaltyStats />}
        />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
