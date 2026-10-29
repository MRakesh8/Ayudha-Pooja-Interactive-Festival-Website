# 👑 TECHNITIX — Royal Palace Smart Door & Vision Lightgun Simulator

<div align="center">

![TECHNITIX Banner](frontend/preview_final.png)

### 🎯 An Interactive Computer-Vision & WebSerial IoT Celebration Platform
**Engineered for Ayudha Pooja 2026 Celebration**

[![Node.js](https://img.shields.io/badge/Node.js-v14+-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![WebSerial API](https://img.shields.io/badge/WebSerial_API-Hardware_Ready-blue?style=for-the-badge&logo=arduino&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/API/WebSerial_API)
[![Computer Vision](https://img.shields.io/badge/Vision_Engine-60_FPS_Canvas-00f5d4?style=for-the-badge&logo=webgl&logoColor=black)](#-computer-vision-engine)
[![Platform](https://img.shields.io/badge/Platform-Chrome_%7C_Edge-FFD700?style=for-the-badge&logo=googlechrome&logoColor=black)](#-getting-started)
[![License: ISC](https://img.shields.io/badge/License-ISC-ff4081?style=for-the-badge)](LICENSE)

<br/>

**Institution:** [Sree Sakthi Engineering College (SREC)](#-credits--acknowledgments)  
**Department:** Department of Information Technology & Artificial Intelligence and Data Science (IT & AI&DS)  
**Lead Developer:** [Rakesh](#-credits--acknowledgments)  

---

[Key Features](#-key-features) •
[System Architecture](#-system-architecture) •
[Computer Vision Engine](#-computer-vision-engine) •
[Hardware & IoT Setup](#-hardware--iot-integration) •
[Quick Start](#-quick-start-guide) •
[Media Configuration](#-media-configuration) •
[Controls](#-controls--shortcuts) •
[Credits](#-credits--acknowledgments)

</div>

---

## 📖 About The Project

**TECHNITIX** is an interactive, physical-computing exhibition platform developed specifically for the **Ayudha Pooja 2026** celebration at **Sree Sakthi Engineering College (SREC)** by the **Department of IT & AI&DS**.

The project uniquely bridges **authentic Dravidian royal temple architecture** with modern **computer vision**, **physical hardware integration (IoT)**, and **real-time media streaming**:

1. **Physical Cardboard Lightgun**: Users aim a cardboard gun fitted with a neon green tracking marker at the screen.
2. **Real-Time Webcam Sight Tracking**: An in-browser computer vision algorithm isolates the tip of the gun in real-time at 60 FPS while intelligently ignoring green shirts, walls, and ambient clutter.
3. **Hardware Trigger Switch**: Pulling the trigger on the gun transmits instant firing signals to the browser via the **WebSerial API** connected to an **ESP32 / Arduino** microcontroller.
4. **Royal Palace Door Simulation**: Hitting the antique brass temple padlock shatters it into 3D physics-based polygonal shards, plays dynamic synthesized procedural audio, swings open the massive Chettinad carved palace doors, showers celebratory flower petals, and automatically launches the department presentation video.

---

## ✨ Key Features

### 🎯 High-Precision Computer Vision Tracking
- **60 FPS In-Browser Tracking**: Lightweight, zero-dependency vision pipeline running directly on HTML5 Canvas with zero garbage-collection latency.
- **Shirt & Background Rejection**: Advanced spatial blob segmentation filters out green clothing, curtains, and room backgrounds, locking exclusively on small handheld markers (8px–40px).
- **Sub-Pixel Deadband & EMA Smoothing**: Suppresses natural hand tremors when aiming still, but responds instantaneously with adaptive acceleration during rapid weapon swings.
- **Interactive Calibration HUD**: Live camera feed with interactive color picker, hue threshold adjustment, sensitivity sliders, and preset chips (Neon, Lime, Common, Dark Green).

### 🔌 WebSerial Hardware Integration (IoT)
- **Direct Browser-to-Microcontroller Interface**: Communicates directly over USB with **ESP32** or **Arduino** without needing intermediate native drivers or WebSocket bridges.
- **Microsecond Debounced Trigger**: Dedicated GPIO polling sketch fires instant `SHOOT` commands over 115200 baud serial connection.
- **Bidirectional Event Feedback**: Webpage notifies the microcontroller upon unlocking (`DOOR_UNLOCKED`), allowing servo-motor deadbolts or LEDs to synchronize in physical space.

### 🏛️ Dravidian Royal Palace Aesthetics
- **Authentic Chettinad Teakwood Pillars**: Hand-carved 3D pillar pillars adorned with Bodhigai lotus brackets and temple bells.
- **Swaying Mavilai Thoranam**: Sacred mango leaf garland with golden temple bells and marigolds animated with synchronized gentle physics.
- **Triptych Commemorative Plaques**: High-definition embossed brass plaques honoring:
  1. *Sree Sakthi Engineering College (SREC)*
  2. *TECHNITIX Festive Emblem*
  3. *Department of Information Technology & AI&DS*
- **Antique Temple Padlock & Shard Physics**: Realistic heavy brass lock that fractures into 3D tumbling shards with procedural gravity and friction upon impact.

### 🔊 Procedural Web Audio Engine
- **Zero External Audio Dependencies**: Gunshot muzzle blasts, metallic bullet ricochets, heavy lock shatter explosions, temple bell chimes, and fanfare sounds are generated procedurally via the **Web Audio API** in real-time.

### ⚡ Range-Based Streaming Server
- **Node.js HTTP Server (`server.js`)**: Supports HTTP `206 Partial Content` byte-range video streaming for smooth seeking and zero-buffer video playback.
- **Smart Path Resolver**: Auto-heals Windows drive letters, unescaped backslashes, and folder typos.
- **Instant Hot-Reloading Watcher**: Modifying `database/media-config.js` immediately updates the active video in the simulator within **1 second** without reloading the page.

---

## 📁 System Architecture

```text
project01/
│
├── 🌐 frontend/                      # User Interface & Visual Simulation Layer
│   ├── finialpro1.html               # Main Palace Door Simulator & Vision Engine
│   ├── media.html                    # Dedicated Media & Video Player Portal
│   ├── index.html                    # Auto-routing Launcher (Localhost redirector)
│   ├── preview_final.png             # UI Demonstration Preview Screenshot
│   └── assets/                       # High-Resolution Visual & Graphic Assets
│       ├── plaque_college_perfect.png     # SREC Official Crest Plaque
│       ├── plaque_technitix_perfect.png   # TECHNITIX Center Plaque
│       ├── plaque_dept_it_aids_perfect.png# Department of IT & AIDS Plaque
│       ├── antique_temple_brass_lock.png  # Hand-crafted Antique Brass Lock
│       ├── tamil_palace_pillar.png        # Chettinad Teakwood Pillar
│       └── srec_crest.png                 # Official SREC Institutional Crest
│
├── ⚙️ backend/                       # Server Engine & Video Streaming Layer
│   └── server.js                     # Native Node.js Server & HTTP Range Streamer (Port 5500)
│
├── 🗄️ database/                      # Data & Media Configuration Layer
│   ├── media-config.js               # Real-time User Video & Audio Path Config
│   └── media/                        # Storage folder for local MP4/Audio files
│
├── 📦 package.json                   # Project Manifest & NPM Start Script
└── 📄 README.md                      # Comprehensive Technical Documentation
```

---

## 🎯 Computer Vision Engine

The vision subsystem processes live frames using a 4-pass pipeline executed within a `requestAnimationFrame` loop:

```
[Webcam Stream (60 FPS)]
         │
         ▼
 1. FAST COLOR ISOLATION ──► Excess Green Index (ExG = 2G - R - B) & HSV Hue Weighting
         │
         ▼
 2. 8x8 SPATIAL BINNING  ──► Zero-GC Spatial Grid Matrix & BFS Multi-Blob Clustering
         │
         ▼
 3. SHIRT REJECTION      ──► Area & Aspect-Ratio Filtering (Discard Blobs > 250px)
         │
         ▼
 4. MOTION STABILIZATION ──► Sub-Pixel Deadband (< 1.8px) & Dynamic EMA Smoothing
         │
         ▼
[Crosshair Reticle Lock on Antique Padlock]
```

### Automatic Shirt Rejection Mechanism
Ordinary color trackers mistakenly track users wearing green shirts or green walls. TECHNITIX eliminates this using strict geometric criteria:
- **Large Objects (> 250px or dimensions > 50px)**: Flagged as `⚠️ SHIRT / ROOM IGNORED`.
- **Tiny Noise (< 6px)**: Dropped as sensor speckle.
- **Elongated Streaks (Aspect Ratio < 0.28 or > 3.5)**: Dropped as wall shadows or cables.
- **Target Marker (8px – 40px)**: Confirmed as cardboard gun sight with target lock acquired (`🟢 GREEN STICKER LOCKED`).

---

## 🔌 Hardware & IoT Integration

### 1. Wiring Diagram (ESP32 / Arduino)

Connect any standard momentary push-button or micro-switch inside your cardboard gun trigger:

```
    ┌─────────────────────────────────┐
    │          ESP32 / ARDUINO        │
    │                                 │
    │   [GPIO 4] ───┐                 │
    │               │                 │
    │             ┌─┴─┐               │
    │             │   │ Trigger Switch│
    │             │ O │ (Push-to-Make)│
    │             └───┘               │
    │               │                 │
    │   [  GND ] ───┘                 │
    └─────────────────────────────────┘
```

> **Note**: Uses the internal pull-up resistor on GPIO 4 (`INPUT_PULLUP`). No external resistor is required.

### 2. Microcontroller Firmware Sketch

Flash this C++ sketch to your ESP32 or Arduino Uno/Nano via the **Arduino IDE**:

```cpp
// =========================================================================
// TECHNITIX ESP32 / ARDUINO CARDBOARD GUN TRIGGER (Baud Rate: 115200)
// Wiring: Connect Trigger Push-Button between GPIO 4 and GND
// =========================================================================

const int TRIGGER_PIN = 4;
int lastState = HIGH;
unsigned long lastDebounceTime = 0;
const unsigned long DEBOUNCE_DELAY = 40; // milliseconds

void setup() {
  Serial.begin(115200);
  pinMode(TRIGGER_PIN, INPUT_PULLUP);
}

void loop() {
  int currentState = digitalRead(TRIGGER_PIN);

  if (currentState != lastState) {
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > DEBOUNCE_DELAY) {
    if (currentState == LOW && lastState == HIGH) {
      // Trigger pressed -> Emit SHOOT command over WebSerial
      Serial.println("SHOOT");
    }
  }

  lastState = currentState;

  // Listen for unlock confirmation from browser
  if (Serial.available()) {
    String incoming = Serial.readStringUntil('\n');
    incoming.trim();
    if (incoming == "DOOR_UNLOCKED") {
      // Optional: Add haptic motor vibration or flash an LED here!
    }
  }
}
```

---

## 🚀 Quick Start Guide

### Prerequisites
- [Node.js](https://nodejs.org/) (Version 14 or higher)
- Modern Web Browser: **Google Chrome** or **Microsoft Edge** (required for WebSerial & WebCam permissions)
- USB Webcam (or integrated laptop camera)

### 1. Installation
Clone the repository and inspect the project directory:
```bash
git clone https://github.com/your-username/technitix.git
cd project01
```

### 2. Launching the Localhost Server
Run the built-in HTTP streaming server:
```bash
npm start
```
*or directly with Node.js:*
```bash
node backend/server.js
```

The console will indicate that the server is active on Port 5500:
```text
================================================================
🚀 TECHNITIX ROYAL PALACE SERVER RUNNING AT:
👉 http://127.0.0.1:5500/
================================================================
```

### 3. Open in Browser
Open either of the following URLs in **Google Chrome** or **Microsoft Edge**:
- 🏛️ **Main Royal Simulator**: [http://127.0.0.1:5500/finialpro1.html](http://127.0.0.1:5500/finialpro1.html)
- 🎬 **Dedicated Media Player**: [http://127.0.0.1:5500/media.html](http://127.0.0.1:5500/media.html)

---

## 🎬 Media Configuration

You can configure what video plays when the palace gates swing open.

Open `database/media-config.js` and set your local video file or YouTube URL:

```javascript
var TECHNITIX_MEDIA = {
  // 🎥 1. VIDEO FILE PATH (Local Video or YouTube Link):
  //    - Local File : "D:/Videos/department_presentation.mp4"
  //    - Relative   : "media/ayudha_pooja_celebration.mp4"
  //    - YouTube    : "https://www.youtube.com/watch?v=YOUR_VIDEO_ID"
  video: "media/ayudha_pooja_celebration.mp4",

  // 🔊 2. AUDIO FILE PATH (Optional):
  audio: ""
};
```

> ⚡ **Live Watcher Active**: The moment you save `media-config.js` (`Ctrl + S`), the backend watcher detects the change and notifies the simulator in **1 second** without needing a browser reload!

---

## 🎮 Controls & Shortcuts

| Action | Control / Keybinding | Description |
|---|---|---|
| **Fire Gun** | `Spacebar` / Mouse Click / ESP32 Trigger | Shoots at the current reticle position |
| **Aim Crosshair** | Mouse Movement / Green Marker | Directs the targeting reticle |
| **Toggle Camera Tracking**| Control Bar Button `📷 Tracking` | Starts / stops webcam computer vision |
| **Tracker Settings** | Control Bar Button `⚙️` | Opens color calibration & sensitivity HUD |
| **Toggle Fullscreen** | `F` Key | Enters / exits borderless cinematic view |
| **Close Modals / HUD** | `Escape` Key | Closes ESP32 code modal & Tracker HUD |
| **Manual Gate Unlock** | `🔓 Unlock` Button | Manually triggers the door opening sequence |
| **Manual Gate Lock** | `🔒 Lock` Button | Resets and locks the doors |

---

## 🛠️ Technology Stack

- **Frontend Core**: HTML5, Vanilla JavaScript (ES6+), CSS3 Flexbox & 3D Transforms
- **Graphics & Vision**: HTML5 Canvas 2D Context, Connected-Component Analysis (CCA), HSV/ExG Filters
- **Audio Synthesis**: Web Audio API (Sine/Triangle oscillators, Biquad lowpass filters, Procedural noise generators)
- **Hardware Communication**: W3C WebSerial API (115200 Baud, asynchronous stream piping)
- **Backend Server**: Node.js `http`, `fs`, `path` modules (Zero external npm package dependencies)
- **Microcontroller**: ESP32 / Arduino C++ Core

---

## 👨‍💻 Credits & Acknowledgments

This project was conceived, designed, and developed for the **Ayudha Pooja 2026** festival:

- **Lead Developer & Creator**: **Rakesh**
- **Department**: **Department of Information Technology & Artificial Intelligence and Data Science (IT & AI&DS)**
- **Institution**: **Sree Sakthi Engineering College (SREC)**, Karamadai, Coimbatore, Tamil Nadu

---

## 📄 License

This project is licensed under the [ISC License](LICENSE). Feel free to use, modify, and build upon this project for educational and exhibition purposes.

<div align="center">
  <sub>Built with ❤️ and dedication for the SREC Ayudha Pooja Celebration.</sub>
</div>
#   A y u d h a - P o o j a - I n t e r a c t i v e - F e s t i v a l - W e b s i t e  
 