#include <ESP8266WiFi.h>
#include <ArduinoJson.h>

#define BLOCK_NAME "Bloco 1"
#define BLOCK_PASS ""

#define device_IP ""

#define REQUEST_PATH "http://" + String(DEVICE_IP) + "Blocos/" + String(BLOCK_NAME) + "/Request"

#define ELEMENT_PATH "http://" + String(DEVICE_IP) + "/blocks/" + String(BLOCK_NAME) + "/allElements"

#define WIFI_SSID "WIFI_SSID"
#define WIFI_PASSWORD "WIFI_PASSWORD"

FirebaseData data;

void setup() {
WiFi.mode(WIFI_STA);
WiFi.begin(WIFI_SSID,WIFI_PASSWORD);

Serial.begin(115200);

while(WiFi.status() != WL_CONNECTED){
  delay(500);
  Serial.print(".");
}

Serial.println("");
Serial.print("Connected to: ");
Serial.println(WIFI_SSID);
Serial.print("IP Address: ");
Serial.println(WiFi.localIP());

Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
Firebase.reconnectWiFi(true);

pinMode(LED_BUILTIN, OUTPUT);
digitalWrite(LED_BUILTIN, HIGH);

}

void pinSet(FirebaseData &data){
  Serial.println("Executing pinSet of Elements in path: " + String(ELEMENT_PATH));

  if (Firebase.RTDB.getJSON(&data, ELEMENT_PATH)) {
    FirebaseJson &json = data.jsonObject();
    String jsonStr;
    json.toString(jsonStr, true); // Prettify the JSON output
    Serial.println(jsonStr);

        DynamicJsonDocument doc(1024);
    DeserializationError error = deserializeJson(doc, jsonStr);

    if (error) {
      Serial.println("Failed to parse JSON");
      return;
    }

      for (JsonPair element : doc.as<JsonObject>()) {
      const String &elementName = element.key().c_str();
      JsonObject elementObj = element.value().as<JsonObject>();

      // Extract the values from the elementObj
      String name = elementObj["name"].as<String>();
      int pin = elementObj["pin"].as<int>();
      String room = elementObj["room"].as<String>();
      bool stats = elementObj["stats"].as<bool>();
      String type = elementObj["type"].as<String>();

      Serial.print("Executing pinSet of Element " + elementName + ": ");
      Serial.print("Name: " + name + ", Pin: " + pin + ", Room: "+ room + ", Stats: " + stats + ", Type: " + type);

      pinMode(pin,)
    }
  } else {
    Serial.println("No Elements Found");
  }
}

void executeRequests(FirebaseData &data) {
  Serial.println("Executing requests at path: " + String(REQUEST_PATH));

  if (Firebase.RTDB.getJSON(&data, REQUEST_PATH)) {
    FirebaseJson &json = data.jsonObject();
    String jsonStr;
    json.toString(jsonStr, true); // Prettify the JSON output
    Serial.println(jsonStr);

    DynamicJsonDocument doc(1024);
    DeserializationError error = deserializeJson(doc, jsonStr);

    if (error) {
      Serial.println("Failed to parse JSON");
      return;
    }

    for (JsonPair element : doc.as<JsonObject>()) {
      const String &elementName = element.key().c_str();
      JsonObject elementObj = element.value().as<JsonObject>();

      // Extract the values from the elementObj
      String name = elementObj["name"].as<String>();
      int pin = elementObj["pin"].as<int>();
      bool stats = elementObj["stats"].as<bool>();

      Serial.print("Executing Element " + elementName + ": ");
      Serial.print("Name: " + name + ", Pin: " + pin +", Stats: " + stats);

      // Execute the action
      // Since "stats" is not available in the "Request" node, we assume the action should be executed as HIGH.
      digitalWrite(pin, HIGH);

      // Update the "stats" value in the "Elements" node
      String elementPath = ELEMENT_PATH + "/" + elementName;
      if (Firebase.set(data, elementPath + "/stats", stats)) {
        Serial.println(" - Action executed and stats updated.");
      } else {
        Serial.println(" - Action executed, but failed to update stats.");
      }

      // Delete the node from Firebase
      String nodePath = REQUEST_PATH + "/" + elementName;
      if (Firebase.deleteNode(data, nodePath)) {
        Serial.println("Node " + nodePath + " deleted from Firebase.");
      } else {
        Serial.println("Failed to delete node " + nodePath + " from Firebase.");
      }
    }
  } else {
    Serial.println("No Requests Found");
  }
}


void loop() {
  executeRequests(data);

  digitalWrite(LED_BUILTIN, HIGH);
  delay(10000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(10000);
}



