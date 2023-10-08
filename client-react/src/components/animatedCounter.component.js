import { useEffect, useState } from 'react';

const AnimatedCounter = ({ targetValue }) => {
  const [currentValue, setCurrentValue] = useState(0);

  useEffect(() => {
    const animationDuration = 15;
    const stepValue = (targetValue - currentValue) / animationDuration;

    const interval = setInterval(() => {
      setCurrentValue((prevValue) => {
        const newValue = prevValue + stepValue;
        if (newValue >= targetValue) {
          clearInterval(interval);
          return targetValue;
        }
        return newValue;
      });
    }, 16); // Adjust the interval (in milliseconds) for smoother animation

    return () => {
      clearInterval(interval);
    };
  }, [targetValue, currentValue]);

  return <>{currentValue.toFixed(2)}</>;
};

export default AnimatedCounter;
