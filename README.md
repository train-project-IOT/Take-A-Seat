# Take-A-Seat

## Take-A-Seat Project by: Shoham Dahan, Tamar Gozlan, Noa Admoni

## Details about the project:
A Project in Internet of Things (IoT) - "Take A Seat".

The goal of our project is to reduce the situations that cause train delays.
With the help of force sensors installed on the seats of the train, we can know how many seats are available and how many are occupied in each car.
We'll divide the train platform to zones of 3-4 cars.
In each zone, a screen that displays the amount and locations of free seats will be installed.
We assume, according to experiments, that displaying this data to the passengers will cause them to stand in a manner that corresponds to the actual available seats in each car and thus be distributed evenly in each area of the railway. This even distribution will result in faster boarding, the train doors to close faster and overall a faster departure of the train from the platform.
Eventually, with our project, we'll be able prevent or at least minimize delays.

## Folder description:
- ESP32: source code for the esp side (firmware).
- flutter_app: dart code for our Flutter app.
- firebase: initialization for our firebase.
- Unit Tests: tests for force_sensor.
- Parameters: contains description of configurable parameters.
- Documentation: wiring diagram, project poster and link to project video.
- Assets: logo and screens that will be displayed at the train platform.
- Simulation: simulation analyzation and final report.

## Arduino/ESP libraries installed and used for the project:
- Firebase Arduino Client Library for ESP8266 and ESP32 - version 2.3.7

## The Hardware list used in this project:
- 1 ESP32 DEVKITV1
- 4 Force Sensors RP S-40 ST
- 4 1.8k Ohm Resistor
- 2 Breadboards
- 6 Breadboard Jumper Wires Male to Male

## Project Poster:

![Group #12 -Train project with force sensors - IOT poster](https://github.com/train-project-IOT/Take-A-Seat/assets/141609508/e4c488ed-f0ba-40bd-9772-5bed4e921947)

## Wiring Diagram:

![Wiring_Diagram](https://github.com/train-project-IOT/Take-A-Seat/assets/141609508/f8e4d6eb-3a1f-425a-9a4d-d5d1f4d5422e)

## Link To Project Video:

https://drive.google.com/file/d/1B1wPRSnCdIMgr4LuFoWEbpA0scDJcD3G/view?usp=sharing


This project is part of ICST - The Interdisciplinary Center for Smart Technologies, Taub Faculty of Computer Science, Technion https://icst.cs.technion.ac.il/
