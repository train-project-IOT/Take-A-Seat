/*

  Rui Santos

  Complete project details at our blog.

    - ESP32: https://RandomNerdTutorials.com/esp32-firebase-realtime-database/

    - ESP8266: https://RandomNerdTutorials.com/esp8266-nodemcu-firebase-realtime-database/

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files.

  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

  Based in the RTDB Basic Example by Firebase-ESP-Client library by mobizt

  https://github.com/mobizt/Firebase-ESP-Client/blob/main/examples/RTDB/Basic/Basic.ino

*/

 
//Including the libraries.
#include <Arduino.h>

#include <WiFi.h>

#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"

//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"



//Insert Firebase project API Key
#define API_KEY "AIzaSyD_03InveOvFFXjTYbB85ce6PE_KLUoJ7k"

//Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://train-project-iot-default-rtdb.europe-west1.firebasedatabase.app/"


//Network Credentials
#define WIFI_SSID "iphone"

#define WIFI_PASSWORD "tamar123"


#define NUM_OF_SEATS 4

#define READING_FREQUENCY 3000

#define THRESHOLD_VALUE 500

#define WIFI_DELAY 300

#define SERIAL_COMMUNICATION 115200
 

//Define Firebase Data object
FirebaseData fbdo;

// Define firebase authentication.
FirebaseAuth auth;

// Definee firebase configuration.
FirebaseConfig config;

 
 
int is_sitting[NUM_OF_SEATS] = {0};

int force_sensor_pins[NUM_OF_SEATS] = {32, 34, 33, 36};

unsigned long sendDataPrevMillis = 0;

// Boolean variable for sign in status.
bool signupOK = false;

 

void setup(){

  Serial.begin(SERIAL_COMMUNICATION);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");

  while (WiFi.status() != WL_CONNECTED){

    Serial.print(".");

    delay(WIFI_DELAY);

  }

  Serial.println();

  Serial.print("Connected with IP: ");

  Serial.println(WiFi.localIP());

  Serial.println();

 
  config.api_key = API_KEY;

  config.database_url = DATABASE_URL;
 

  /* Sign up */

  if (Firebase.signUp(&config, &auth, "", "")){

    Serial.println("ok");

    signupOK = true;

  }

  else{

    Serial.printf("%s\n", config.signer.signupError.message.c_str());

  }


  /* Assign the callback function for the long running token generation task */

  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h


  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);

}

 

void loop(){

  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > READING_FREQUENCY || sendDataPrevMillis == 0)){

    sendDataPrevMillis = millis();

    int analogReadings[NUM_OF_SEATS];
    
    for (int i=0; i<NUM_OF_SEATS ; i++)
    {
      analogReadings[i] = analogRead(force_sensor_pins[i]);
    }

    for (int i=0; i<NUM_OF_SEATS ; i++)
    {
      if (analogReadings[i] < THRESHOLD_VALUE)
        is_sitting[i] = 0;
      else
        is_sitting[i] = 1;
    }
 
    for (int i=0; i<NUM_OF_SEATS ; i++)
    {
      std::string name = "test/chair_" + std::to_string(i);

      if (Firebase.RTDB.setInt(&fbdo, name.c_str() , is_sitting[i])){
        Serial.println("PASSED");
      }

      else {
        Serial.println("FAILED");
      }

    }

  }

}