import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { BaseURL } from '../constants';
import { BeautifyCurrency, BeautifyDate } from '../helpers';

const LoyaltyStats = () => {
  const [information, setInformation] = useState();
  const params = useParams();

  const fetchInformation = () => {
    const url = `${BaseURL}/customers/${params.customerId}/loyalty_stats`;
    return fetch(url)
      .then((res) => res.json())
      .then((data) => setInformation(data));
  };

  useEffect(() => {
    fetchInformation();
  }, []);
  console.log(information);

  const tierIcon = (tierName) => {
    const tierIconList = {
      Gold: '🥇',
      Silver: '🥈',
      Bronze: '🥉',
    };
    return tierIconList[tierName];
  };

  const retainInformation = () => {
    return information.remaining_to_retain > 0 ? (
      <>
        Hey there! Just a friendly heads-up your loyalty tier
        {tierIcon(information.current_tier_name)}{' '}
        <strong>{information.current_tier_name}</strong> is set to be downgraded
        to {tierIcon(information.downgrade_to)}{' '}
        <strong>{information.downgrade_to}</strong> on
        <strong>{BeautifyDate(information.downgrade_date)}</strong> if you don't
        maintain your spending levels. You're almost there,{' '}
        <strong>{BeautifyCurrency(information.remaining_to_retain)}</strong>{' '}
        left, just a bit more to go!
      </>
    ) : (
      <>
        Hey there! You've already reached the minimum spending required to
        maintain your current tier {tierIcon(information.current_tier_name)}{' '}
        <strong>{information.current_tier_name}</strong>. Keep enjoying your
        elevated benefits!
      </>
    );
  };

  return (
    <div className="container">
      <h1>Loyalty Stats</h1>
      <div>
        {information && (
          <>
            <p>{retainInformation()}</p>
            <ul>
              <li>Start date: {BeautifyDate(information.start_date)}</li>
              <li>
                Total spending:{' '}
                {BeautifyCurrency(information.total_spent_cents)}
              </li>
            </ul>
          </>
        )}
      </div>
    </div>
  );
};

export default LoyaltyStats;
