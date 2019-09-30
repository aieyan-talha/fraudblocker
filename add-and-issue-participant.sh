#Create an instance of a participant
composer participant add -d '{
  "$class": "org.fraudblocker.hlf.client.Client",
  "Username": "khizar.butt",
  "Info": {
    "$class": "org.fraudblocker.hlf.client.ProfileInfo",
    "first_name": "Khizar",
    "last_name": "Butt",
    "email": "khizar.butt@nmxglobalsoftware.com",
    "address": "Bahria Town, Rawalpindi",
    "contact_no": "0320-1546987"
  },
  "wallet": {
    "$class": "org.fraudblocker.hlf.wallet.Wallet",
    "WalletID": "khizar.butt",
    "token": 3
  }
}' -c admin@fraudblocker

#Issue an card to the participant
composer identity issue -u khizar.butt -a org.fraudblocker.hlf.client.Client#khizar.butt -c admin@fraudblocker
