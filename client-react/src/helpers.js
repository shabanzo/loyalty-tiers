export const BeautifyCurrency = (cents) => {
  return `$${(cents / 100).toFixed(2)}`;
};

export const BeautifyDate = (isoDate) => {
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(isoDate).toLocaleDateString(undefined, options);
};
