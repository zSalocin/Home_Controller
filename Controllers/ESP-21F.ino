#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>

#define FIREBASE_HOST "your-firebase-project.firebaseio.com"
#define FIREBASE_AUTH "your-firebase-api-key"

FirebaseData firebaseData;

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi
  WiFi.begin("your-ssid", "your-password");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  // Initialize Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  // Fetch data from Firebase
  if (Firebase.getJSON(firebaseData, "/Blocos/Bloco 1/Elements/Element 1")) {
    if (firebaseData.dataType() == "json") {
      JsonObject& root = firebaseData.jsonObject();
      String name = root["name"].asString();
      int pin = root["pin"].as<int>();
      String room = root["room"].asString();
      bool stats = root["stats"].as<bool>();
      String type = root["type"].asString();

      // Do something with the data
      Serial.println("Element Name: " + name);
      Serial.println("Element Pin: " + String(pin));
      Serial.println("Element Room: " + room);
      Serial.println("Element Status: " + String(stats));
      Serial.println("Element Type: " + type);
    }
  }

  delay(5000); // Fetch data every 5 seconds (adjust as needed)
}
