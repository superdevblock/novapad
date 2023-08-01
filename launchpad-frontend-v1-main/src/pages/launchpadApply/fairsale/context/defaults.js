// This file holds the initial, default values for context
// Note: it's good practice to specify defaults here,
//  but in our case they are overwritten by the values
//  within AppContextProvider

export const defaultValue = {
  step: 1,
  maxStep: 5,
  currencyAddress: "0x0000000000000000000000000000000000000000",
  currencyTSymbol: "BNB",
  tokenAddress: "",
  tokenSymbol: "",
  tokenName: "",
  tokenDecimal: "",
  feesType: "1",
  isApprove: false,
  saletoken: 0,
  softcap: 0,
  hardcap: 0,
  refund: 1,
  routeraddress: "",
  liquidity: 0,
  starttime: new Date(),
  endtime: new Date(),
  llockup: 0,
  logourl: "",
  bannerurl: "",
  website: "",
  facebook: "",
  twitter: "",
  github: "",
  telegram: "",
  instagram: "",
  discord: "",
  reddit: "",
  youtube: "",
  brief: "",
  blockstart: "",
  partnerAddress: [],
  kyc: false,
  audit: false,
  totalCost: 0,
  totaltoken: 0,
  ispoolExist: false,
  usermail: "",
  auditlink: "",
  kyclink: "",
};

const defaultContext = {
  value: defaultValue,
  setValue: () => {},
  btnNextStep: () => {},
  btnPrevStep: () => {},
  handleInput: () => {},
};

export default defaultContext;

export const feesSetting = {
  1: {
    token: 0,
    bnb: 5,
    extra: 0,
  },
  2: {
    token: 2,
    bnb: 2,
    extra: 0,
  },
};
