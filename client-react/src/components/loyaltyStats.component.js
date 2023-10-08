import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { BaseURL } from '../constants';
import { BeautifyCurrency, BeautifyDate } from '../helpers';
import AnimatedCounter from './animatedCounter.component';

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

  const tierIcon = (tierName) => {
    const tierIconList = {
      Gold: '🥇',
      Silver: '🥈',
      Bronze: '🥉',
    };
    return tierIconList[tierName];
  };

  const retainInformation = () => {
    return information.remaining_amount_to_retain > 0 ? (
      <>
        <div className="information-downgrade information-downgrade-date">
          <div className="information-label">Downgrade date:</div>
          <strong className="information-value">
            {BeautifyDate(information.downgrade_date)}
          </strong>
        </div>
        <div className="information-downgrade information-downgrade-to">
          <div className="information-label">Downgrade to:</div>
          <strong className="information-value">
            {tierIcon(information.downgrade_to)}{' '}
            {information.downgrade_to.toUpperCase()}
            {tierIcon(information.downgrade_to)}
          </strong>
        </div>
        <div className="information-downgrade information-remaining-to-retain">
          <div className="information-label">Remaining to retain:</div>
          <strong className="information-value">
            {BeautifyCurrency(information.remaining_amount_to_retain)}
          </strong>
        </div>
      </>
    ) : (
      <>
        <p>
          Hey there! <br />
          <br /> You've already reached the minimum spending required to
          maintain your current tier. Keep enjoying your elevated benefits!{' '}
          {information.upgrade_to
            ? 'And reach the next tier for better benefits!'
            : ''}{' '}
          <br />
          <br />
          Thank you for trusting us!
        </p>
      </>
    );
  };

  const upgradeInformation = () => {
    return information.remaining_amount_to_upgrade > 0 ? (
      <>
        <div className="information-downgrade">
          <div className="information-label">Upgrade to:</div>
          <strong className="information-value">
            {tierIcon(information.upgrade_to)}{' '}
            {information.upgrade_to.toUpperCase()}
            {tierIcon(information.upgrade_to)}
          </strong>
        </div>
        <div className="information-downgrade">
          <div className="information-label">Remaining to upgrade:</div>
          <strong className="information-value">
            {BeautifyCurrency(information.remaining_amount_to_upgrade)}
          </strong>
        </div>
      </>
    ) : (
      <>
        <p>
          Hey there! <br />
          <br /> You've already reached the highest tier. Keep enjoying your
          elevated benefits!
          <br />
          <br />
          Thank you for trusting us!
        </p>
      </>
    );
  };

  const progress = () => {
    return (
      (information.total_spent_cents /
        (information.remaining_amount_to_upgrade +
          information.total_spent_cents)) *
      100
    );
  };
  console.log(information && progress());
  console.log(information && information);
  return (
    <div className="container stats-container">
      <h1>Customer#{params.customerId} - Loyalty Stats</h1>
      <div>
        {information && (
          <div className="information-card">
            <h3 className="information-tier">
              {tierIcon(information.current_tier_name)}{' '}
              <strong className="information-value">
                {information.current_tier_name.toUpperCase()}
              </strong>{' '}
              {tierIcon(information.current_tier_name)}
            </h3>
            <div className="information-total-spending">
              $
              <AnimatedCounter
                targetValue={information.total_spent_cents / 100}
              />
            </div>
            <div className="progress progress-moved">
              <div
                className="progress-bar"
                style={{
                  width: `${progress()}%`,
                  '--target-width': `${progress()}%`,
                }}
              ></div>
            </div>
            <div className="information-retain">
              <h3>Upgrade Tier Information</h3>
              {upgradeInformation()}
            </div>
            <div className="information-retain">
              <h3>Retain Tier Information</h3>
              {retainInformation()}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default LoyaltyStats;
