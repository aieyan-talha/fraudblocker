/**
 * Create Client Transaction
 * @param {org.fraudblocker.hlf.client.CreateClient} clientData
 * @transaction
 */

function createClient(clientData) {
  console.log("Creating client");
  return getParticipantRegistry("org.fraudblocker.hlf.client.Client").then(
    function(clientRegistry) {
      var factory = getFactory();
      var NS = "org.fraudblocker.hlf.client";

      var clientId = clientData.Username;
      var client = factory.newResource(NS, "Client", clientId);
      var clientInfo = factory.newConcept(NS, "ProfileInfo");

      clientInfo.first_name = clientData.first_name;
      clientInfo.last_name = clientData.last_name;
      clientInfo.email = clientData.email;
      clientInfo.address = clientData.address;
      clientInfo.contact_no = clientData.contact_no;

      client.Info = clientInfo;

      var WalletNS = "org.fraudblocker.hlf.wallet";
      var wallet = factory.newResource(WalletNS, "Wallet", clientId);
      wallet.token = 0;

      client.wallet = wallet;

      var event = factory.newEvent(NS, "ClientCreated");
      event.Username = clientId;
      emit(event);

      return clientRegistry.add(client);
    }
  );
}
