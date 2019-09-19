#Create an instance of a participant
composer participant add -d '{
  "$class": "org.fraudblocker.hlf.client.Client",
  "Username": "aieyan.talha",
  "Info": {
    "$class": "org.fraudblocker.hlf.client.ProfileInfo",
    "first_name": "Aieyan",
    "last_name": "Talha",
    "email": "aieyan.talha@nmxglobalsoftware.com",
    "address": "Bahria Town, Islamabad",
    "contact_no": "0320-5501928"
  },
  "wallet": {
    "$class": "org.fraudblocker.hlf.wallet.Wallet",
    "WalletID": "aieyan.talha",
    "token": 0
  }
}' -c admin@fraudblocker

#Issue an card to the participant
composer identity issue -u aieyan -a org.fraudblocker.hlf.client.Client#aieyan.talha -c admin@fraudblocker
