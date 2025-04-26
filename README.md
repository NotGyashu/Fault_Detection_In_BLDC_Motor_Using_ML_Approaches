# Fault_Detection_In_BLDC_Motor_Using_ML_Approaches

This project focuses on detecting faults in Brushless DC (BLDC) motors using Machine Learning (ML) techniques. By simulating different fault conditions in a BLDC motor model created in MATLAB/Simulink, key electrical parameters (voltages, currents, power, efficiency, torque, etc.) are recorded. These simulation datasets are then used to train ML models to accurately classify the motor's health status, helping in predictive maintenance and reducing downtime.

## Table of Contents
- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Dataset Generation](#dataset-generation)
- [Machine Learning Approach](#machine-learning-approach)
- [Results](#results)
- [Screenshots](#screenshots)
- [Conclusion](#conclusion)

## Introduction
Fault detection in electric motors, especially BLDC motors, is critical for various industries like automotive, aerospace, and manufacturing. Traditional methods can be time-consuming and less adaptable. Hence, a data-driven, machine learning-based approach is proposed to identify early signs of faults effectively.

## Project Overview
- **Motor Model:** A detailed BLDC motor model is built using MATLAB Simscape Electrical.
- **Fault Injection:** Faults like supply voltage variation, winding short-circuits, and sensor faults are introduced.
- **Data Recording:** Electrical parameters are captured under both healthy and faulty conditions.
- **ML Pipeline:** Preprocessing, model training, evaluation, and fault classification using algorithms like Decision Trees, Random Forests, SVMs, etc.

## Dataset Generation
The BLDC motor model is subjected to different operational conditions. For each simulation:
- Input supply, phase currents, phase voltages, back EMFs, torque, input/output power, and efficiency are recorded.
- Fault scenarios are intentionally injected.
- Data is collected into structured formats like `.csv` for easy ML processing.

## Machine Learning Approach
- Feature engineering to select significant signals.
- Data splitting into training and testing sets.
- Model training and hyperparameter tuning.
- Evaluation metrics: Accuracy, Confusion Matrix, Precision, Recall.

## Results
The trained ML models demonstrated high accuracy in distinguishing healthy and faulty states of the motor. Random Forest and SVM showed particularly promising results with accuracy above 95%.

## Screenshots

### 1. BLDC Motor Model in Simulink
![BLDC Motor Model](./assets/Screenshot%202025-04-12%20151115.png)

### 2. Hall Sensor and Commutation Logic
![Hall Sensor Logic](./assets/Screenshot%202025-04-12%20154529.png)

### 3. Motor Back-EMF Monitoring and Validation
![Back EMF Validation](./assets/Screenshot%202025-04-14%20225107.png)

### 4. Simulation of Fault Scenarios
![Fault Injection Simulation](./assets/Screenshot%202025-04-14%20225141.png)

### 5. Output Analysis - Current and Voltage Waveforms
![Waveform Analysis](./assets/Screenshot%202025-04-14%20225429.png)

### 6. Data Extraction and Recording
![Data Extraction](./assets/Screenshot%202025-04-14%20225628.png)

### 7. Feature Engineering and Preprocessing
![Feature Engineering](./assets/Screenshot%202025-04-15%20021236.png)

### 8. Machine Learning Model Training and Evaluation
![ML Model Training](./assets/Screenshot%202025-04-20%20232202.png)

## Conclusion
The project successfully demonstrates how Machine Learning techniques can be applied to BLDC motor fault detection. By generating a synthetic yet realistic dataset from simulations and training ML models, predictive maintenance strategies can be significantly enhanced, ensuring greater system reliability and performance.
