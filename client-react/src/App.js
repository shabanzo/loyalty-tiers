import './App.css';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CompletedOrders from './components/completedOrders.component.';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route
          path="/customers/:customerId/completed_orders"
          element={<CompletedOrders />}
        />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
