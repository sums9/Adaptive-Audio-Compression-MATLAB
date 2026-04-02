# Adaptive Audio Compression 

A Hardware-In-The-Loop (HIL) system that uses physical voltage levels to control digital signal processing parameters.

## Project Overview
This project implements a **Discrete Cosine Transform (DCT)** algorithm in MATLAB. Unlike standard compression, the 'Keep Ratio' (data density) is determined by reading real-time analog signals from an **Arduino Uno**.

## Tech Stack
* **Software:** MATLAB (Signal Processing Toolbox)
* **Hardware:** Arduino Uno (ATMega328P)
* **Algorithm:** Block-wise DCT/IDCT (Block size: 256)

## How to Run
1. Connect your Arduino Uno to **COM3** (or update the port in the script).
2. Ensure **Analog Pin A0** is receiving a voltage (0-5V).
3. Run `src/adaptive_dct_compression.m` in MATLAB.
4. The onboard **LED (Pin 13)** will light up during the DCT computation.

## Key Results
The system generates a final report including:
* **SNR (Signal-to-Noise Ratio):** Measures reconstruction quality.
* **MSE (Mean Squared Error):** Quantifies data loss.
* **Latency:** Real-time processing time in seconds.
