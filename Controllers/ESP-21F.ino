#include <ESP8266WiFi.h>
#include <ArduinoJson.h>

#define BLOCO_ID "Block_ID"

#define device_IP ""

#define REQUEST_PATH "http://" + String(DEVICE_IP) + "/blocks/get/" + String(BLOCO_ID) + "/requests"

#define DELETE_REQUEST_PATH "http://" + String(DEVICE_IP) + "/blocks/del/" + String(BLOCO_ID) + "/requests/"

#define ELEMENT_PATH "http://" + String(DEVICE_IP) + "/blocks/get/" + String(BLOCO_ID) + "/allElements"

#define WIFI_SSID "WIFI_SSID"
#define WIFI_PASSWORD "WIFI_PASSWORD"

void setup() {
Serial.begin(115200);
delay(10);
  
WiFi.mode(WIFI_STA);
WiFi.begin(WIFI_SSID,WIFI_PASSWORD);

while(WiFi.status() != WL_CONNECTED){
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
    // Verifica se o JSON é um array
    if (doc.is<JsonArray>()) {
      JsonArray jsonArray = doc.as<JsonArray>();
      for (JsonObject obj : jsonArray) {
        String name = obj["name"].as<String>();
        int pin = obj["pin"].as<int>();
        bool stats = obj["stats"].as<bool>();

        // Executa a ação (exemplo: altera o estado do pino)
        // digitalWrite(pin, stats);
        Serial.print("Action executed for request with name: ");
        Serial.println(name);

        // Se necessário, remova a requisição após ser executada
        // Exemplo de como remover a requisição:
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

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  handleRequests();
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}



