#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h> // Include the HTTPClient library

#define BLOCO_ID "Block_ID"

#define DEVICE_IP "" // Adjusted variable name

#define REQUEST_PATH "http://" + String(DEVICE_IP) + "/blocks/get/" + String(BLOCO_ID) + "/requests"

#define DELETE_REQUEST_PATH "http://" + String(DEVICE_IP) + "/blocks/del/" + String(BLOCO_ID) + "/requests/"

#define ELEMENT_PATH "http://" + String(DEVICE_IP) + "/blocks/get/" + String(BLOCO_ID) + "/allElements"

#define WIFI_SSID "WIFI_SSID"
#define WIFI_PASSWORD "WIFI_PASSWORD"

WiFiClient client; // Initialize the WiFi client

void setup() {
  Serial.begin(115200);
  delay(10);
  
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected to: ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
}

void deleteRequest(String requestName) {
  HTTPClient http; // Initialize the HTTP client for each request
  if (http.begin(client, DELETE_REQUEST_PATH + requestName)) {
    int httpCode = http.DELETE();
    
    if (httpCode == HTTP_CODE_NO_CONTENT) {
      Serial.println("Request deleted successfully");
    } else {
      Serial.print("HTTP DELETE request failed with error code ");
      Serial.println(httpCode);
    }

    http.end();
  } else {
    Serial.println("Failed to connect to server");
  }
}

void processRequests(String payload) {
  DynamicJsonDocument doc(1024);
  DeserializationError error = deserializeJson(doc, payload);

  if (!error) {
    if (doc.is<JsonArray>()) {
      JsonArray jsonArray = doc.as<JsonArray>();
      for (JsonObject obj : jsonArray) {
        String name = obj["name"].as<String>();
        int pin = obj["pin"].as<int>();
        bool stats = obj["stats"].as<bool>();

        //digitalWrite(pin, stats);
        Serial.print("Action executed for request with name: ");
        Serial.println(name);

        deleteRequest(name);
      }
    } else {
      Serial.println("Invalid JSON format: not an array");
    }
  } else {
    Serial.println("Failed to parse JSON");
  }
}

void handleRequests() {
  Serial.println("Checking for requests...");
  HTTPClient http; // Initialize the HTTP client for each request
  if (http.begin(client, REQUEST_PATH)) {
    int httpCode = http.GET();
    
    if (httpCode == HTTP_CODE_OK) {
      String payload = http.getString();
      processRequests(payload);
    } else {
      Serial.print("HTTP GET request failed with error code ");
      Serial.println(httpCode);
    }

    http.end();
  } else {
    Serial.println("Failed to connect to server");
  }
}

void processElement(String payload) {
  DynamicJsonDocument doc(1024);
  DeserializationError error = deserializeJson(doc, payload);

  if (!error) {
    if (doc.is<JsonArray>()) {
      JsonArray jsonArray = doc.as<JsonArray>();
      for (JsonObject obj : jsonArray) {
        String name = obj["elementName"].as<String>();
        String type = obj["elementType"].as<String>();
        int pin = obj["pin"].as<int>();
        JsonArray attachpinArray = obj["attachPins"].as<JsonArray>(); // Get attachpin as a JsonArray

        // Convert the JsonArray to a vector of ints
        std::vector<int> attachpin;
        for (JsonVariant value : attachpinArray) {
          attachpin.push_back(value.as<int>());
        }

        if (type.indexOf("Sensor") != -1) {
          //int sensorValue = digitalRead(pin);
          
          //for(int x = 0; x < attachpin.size(); x++) {
          //  digitalWrite(attachpin[x], sensorValue);
          //}

          Serial.print("Action executed for sensor with name: ");
          Serial.println(name);
        }
      }
    } else {
      Serial.println("Invalid JSON format: not an array");
    }
  } else {
    Serial.println("Failed to parse JSON");
  }
}

void handleElement(){
  Serial.println("Checking for elements...");
  HTTPClient http; // Initialize the HTTP client for each request
  if (http.begin(client, ELEMENT_PATH)) {
    int httpCode = http.GET();
    
    if (httpCode == HTTP_CODE_OK) {
      String payload = http.getString();
      processElement(payload);
    } else {
      Serial.print("HTTP GET request failed with error code ");
      Serial.println(httpCode);
    }

    http.end();
  } else {
    Serial.println("Failed to connect to server");
  }
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  handleRequests();
  digitalWrite(LED_BUILTIN, LOW);
    handleElement(); // Call handleElement function
  delay(1000);
}
