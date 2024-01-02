const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.addTestGame = functions.https.onRequest(async (request, response) => {
  try {
    const gameData = {
      teamName: "Chicago Bears",
    };

    const db = admin.firestore();
    const testGamesRef = db.collection("testGames");

    await testGamesRef.add(gameData);

    response.send("Document with Chicago Bears added to testGames collection");
  } catch (error) {
    console.error("Error adding document:", error);
    response.status(500).send("Error adding document to testGames collection");
  }
});

exports.updateGame = functions.https.onRequest(async (request, response) => {
  try {
    const documentId = "10c45d3ea3c7306b41f67688c09df290";
    const awayMoneyLineOdds = 123;
    const gameRef = admin.firestore().collection("games").doc(documentId);

    await gameRef.update({awayMoneyLineOdds});

    const updateMsgPart1 = `Game ID ${documentId}`;
    const updateMsgPart2 = `updated. Odds: ${awayMoneyLineOdds}`;
    response.send(`${updateMsgPart1} ${updateMsgPart2}`);
  } catch (error) {
    console.error("Error updating document:", error);
    response.status(500).send("Error updating document in games collection");
  }
});
