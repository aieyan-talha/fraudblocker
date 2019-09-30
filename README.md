# fraudBlocker

fraudBlocker is a web application that utilizes block-chain technology to prevent any sort of fraudulent activity in the supply chain network. Although the full project is still underworks and at the moment private, nonetheless the purpose of this repo is to explain the basic workflow of how to create a simple blockchain network using Hyperledger Composer. (INFO: As of August 29th 2019, Hyperledger Composer has been deprecated, and therefore it is advised to persue Hyperledger Fabric instead)

### Third Party Sources

https://github.com/acloudfan/HLF-Windows-Fabric-Tool (Hyperledger Fabric Backend, upon which the Composer network will be built)

https://www.codementor.io/gangachris125/passport-jwt-authentication-for-hyperledger-composer-rest-server-jqfgkoljn (JWT authentication for Composer REST Server)

## Setting Up Fabric Enviorment

All of the code done in this repo has been done on Windows 10 Pro, as Hyperledger has been built to work on Linux or Mac, therefore we would require third-party softwares to runu shell scripts created to run the fabric enviorment. You can either install Cygwin or intall Git bash. For setting up the fabric network we will use Cygwin. Open Cygwin and set the following flags by running the following commands:

```bash
vi .bash_profile

//Press SHIFT+ga (keys) adn type the following

export COMPOSE_CONVERT_WINDOWS_PATHS=1
export MSYS_NO_PATHCONV=1

//You can change your default working directoy as well
cd /cygdrive/c/<PATH TO YOUR PROJECT>

//Press ESC+:+wq to exit the bash_profile
```

You can check if the flags are set by echoing the above flags. Now clone the repo (https://github.com/acloudfan/HLF-Windows-Fabric-Tool) in your working directory, go into the folder after clonning is completed and run the following commands: (INFO: You will require the latest version of Docker Desktop for this)

```bash
./startFabric.sh (This will start the fabric network, if you run into any errors, restart docker and make sure docker has access to your directories)

//If no errors recieved from the above command the run the following
./createPeerAdminCard.sh (This will create the Peer Admin and import the network admins card into composer)
```

Now your Fabric Enviorment is up and running.

## Starting Composer Project

Clone the above project into some directory and using Git bash terminal cd into the folder. The following commands require the following packges `composer-cli@0.20`, `composer-rest-server@0.20` and `composer-playground`. Now for some reason, even I couldn't find why, the above packages can only be installed using `node@8.9.4`, so if your wish to keep your latest version of node, I would suggest using NVM Windows Package that allows you to run multiple node versions at the same time. Once the packages are installed, run the following commands: 

```bash

composer archive create -t dir -n ../ 
(This will create a .bna file into the folder, its version will match that mentioned in package.json)

composer network install -a fraudblocker@0.0.6.bna -c PeerAdmin@hlfv1
(This will install the Buisiness Network, ready to deployed)

composer network install -c PeerAdmin@hlfv1 -n fraudblocker -V 0.0.6 -A admin -S adminpw
(This will deploy the network and create a administator card in the dist folder which can be used to deploy the Composer REST Server)

composer card import -f admin@fraudblocker.card

//Then run the following script
./start-composer-multi.sh
(This will run the composer REST Server in Multiuser mode and secured with JWT Authentication)

```


## Composer REST Server Authentication
Composer REST Server is one of Hyperledger Composer most useful products. It exposes all the functions on the Hyperledger Composer as HTTP Requests, similar to Swagger. Using Composer REST Server we can easily communicate with Hyperledger through our front-end code. But an obvious problem of REST Server is its insecurity if left as is. Therefore the developers of Hyperledger fabric have allowed us to implement almost any Passport (http://www.passportjs.org/) based authentication. In this project we have used JWT Based authentication. 

If we open the `start-composer-rest-server.sh` file, we can see the following code: 
```bash

#1) Set up the card to be used
export COMPOSER_CARD=admin@fraudblocker

#2) Set up the namespace usage    always | never
export COMPOSER_NAMESPACES=never

#3) Set up the REST Server Authentication    true | false
export COMPOSER_AUTHENTICATION=true

#4) Set up the Passport stratergy provider
export COMPOSER_PROVIDERS='{
  "jwt": {
    "provider": "passport-jwt",
    "module": "/Work/Testing/Composer-Multiuser/fraudBlocker/fraudblocker/custom-jwt.js",
    "secretOrKey":"Secret Hash",
    "authScheme": "saml",
    "successRedirect": "/",
    "failureRedirect": "/"
  }
}'

#5) Execure the REST Server
composer-rest-server

```

Here `COMPOSER_PROVIDERS` set up the passport strategy to be used. We will have to install `npm install -g passport-jwt` in order to use JWT Authentication. Now we have create our custom module `custom-jwt.js` which is exposed by giving it the full path to the module file itself. 

```bash

//Here other than "C:", we mention the full path from the home directory
"module": "/Work/Testing/Composer-Multiuser/fraudBlocker/fraudblocker/custom-jwt.js"

```

INFO: For more detailed instructions on setting up the JWT Authentication, I suggest you visit the following webiste (https://www.codementor.io/gangachris125/passport-jwt-authentication-for-hyperledger-composer-rest-server-jqfgkoljn). 

Now in `custom-jwt.js` we can either set jwtFromRequest to `fromAuthHeaderAsBearerToken`, in which case you will have to pass the token as Bearer in the Auth header of the GET call to the following URL: localhost:3000/auth/jwt/callback (This can only be tested through Postman. The REST Server will not allow you to make call on its termial). If the token is valid token, then you will obseve that in response you have recieved three cookies `connect.sid`, `access_token` and `userId`. We require the access_token to make requests onto the REST Server, which once recieved is sent with every request made until the cookie expires. After that we will run the following command in our project directory. 

```bash

./add-and-issue-participant.sh
(This will create a network partiicpant and issue it an identity. You can see a card appearing in the project folder)
(You can change the parameters in the file to create more users)

```
Once done, using Postman we will make import the card on the link http://localhost:3000/api/Wallet/import, using the card that was created by running the above shell script and providing it with a custom name. GET http://localhost:3000/api/Wallet to see if the card has been imported successfully, if so then you can make anyother request without interuption. 

If we set jwtFromRequest to `fromUrlQueryParameter` as done in the file `custom-jwt.js` then we can access the REST server with the token directy by visiting http://localhost:3000/auth/jwt/callback?token=<token> (You will not add Bearer as a prefix to the token this time). You will be redirected to the REST Server terminal with the authenticated user token. Now you can use the REST Server terminal itself to make further requests.
 
