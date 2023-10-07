import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { BaseURL } from '../constants';

const CompletedOrders = () => {
  const [orders, setOrders] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const params = useParams();

  const fetchOrders = () => {
    const url = `${BaseURL}/customers/${params.customerId}/completed_orders?page=${currentPage}`;
    return fetch(url)
      .then((res) => res.json())
      .then((data) => setOrders(data));
  };

  const beautifyDate = (isoDate) => {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(isoDate).toLocaleDateString(undefined, options);
  };

  useEffect(() => {
    fetchOrders();
  }, [currentPage, params.customerId]);

  const hasNextPage = orders.length > 0;
  const hasPrevPage = currentPage > 1;

  const handleNextPage = () => {
    if (hasNextPage) {
      setCurrentPage(currentPage + 1);
    }
  };

  const handlePrevPage = () => {
    if (hasPrevPage) {
      setCurrentPage(currentPage - 1);
    }
  };

  return (
    <div className="container">
      <h1>Completed Orders</h1>
      <div>
        <table className="completed-orders-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Date</th>
              <th>Total</th>
            </tr>
          </thead>
          <tbody>
            {orders.map((order) => (
              <tr key={order.id}>
                <td>{order.id}</td>
                <td>{beautifyDate(order.date)}</td>
                <td>${(order.total_in_cents / 100).toFixed(2)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div className="pagination">
        {hasPrevPage && (
          <button onClick={handlePrevPage} className="prev-button">
            Previous Page
          </button>
        )}
        {hasNextPage && (
          <button onClick={handleNextPage} className="next-button">
            Next Page
          </button>
        )}
      </div>
    </div>
  );
};

export default CompletedOrders;
