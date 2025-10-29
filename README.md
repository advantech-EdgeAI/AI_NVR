# AI-NVR
Advantech AI-NVR

# Introduction

Network Video Recorder (AI-NVR) as a application built using the Metropolis Microservices for Jetson stack. The application is downloaded as a docker compose package (within compressed tar file) and can be installed based on instructions in the setup section.

MIC-717OX is designed to facilitate the deployment and operation of Nvidia Jetson AI-NVR system.
![image](https://github.com/user-attachments/assets/af53b491-392e-465a-be48-59edf8ad2319)
![image](https://github.com/user-attachments/assets/307b5ffd-734a-4e5f-b008-4d5d5e146936)

# System Setup

This chapter describe hardware and software requirement.

## Hardware Preparation

| Name | Description |
| --- | --- |
| Product | MIC-711-OX4A1 (16GB) |
| JetPack | V6.0 (MIC717OX_Jetpack6.0.0_V1.0.0.tbz2) |
| Storage (NVMe) | 128GB |
| POE Camera | Support up to 8 POE Cameras |

## BSP

Please confirm your MIC-717 device has flashed **MIC717OX\_Jetpack6.0.0\_V1.0.0.tbz2.**

## POE Camera

MIC-717 supports up to eight POE cameras which supports RTSP stream output. Please adjust IP address of POE camera to 192.168.1.X.
![image](https://github.com/user-attachments/assets/36a6d379-89c4-4e82-ae19-04ab0db9f416)

The list of POE cameras is supported by default. Other cameras can be used but need to manually add to sensor list.
![image](https://github.com/user-attachments/assets/8b15a726-db96-4715-a74f-dd949e8f883f)

# AINVR Service

## Installation

After BSP flashing successfully, please download AINVR package from URL.

Filename: mic717\_ainvr\_v01.tbz2 ([Download](https://advantecho365-my.sharepoint.com/:u:/g/personal/sean23_chang_advantech_com/ES5RdqVBaLhInU2BkSMfcloBc6Z0vnd5DsNQkM1nZzGjsg?e=RQs50v))

MD5: ea8d8d1a6ec92a0ca4efb8b36ba75141

Filesize: 7.0 GB

![image](https://github.com/user-attachments/assets/5354eb6a-b330-49b1-8032-cd9d36a32571)
![image](https://github.com/user-attachments/assets/0f61ad07-f88f-47e8-b3b5-dd817538a7f2)
 ![image](https://github.com/user-attachments/assets/cd7fa356-0a48-40f5-9d4f-cd4fbbb8c0f5)

![image](https://github.com/user-attachments/assets/edb548c7-7058-408e-9648-9d67a697b9c2)
![image](https://github.com/user-attachments/assets/35d8a95e-e23b-43aa-8246-543d3a24d7c6)

After finish installation process, AINVR service will start running when MIC-717 boot up. It will takes times to launch all process in background. Before running NVR application, please idle MIC around 10 minutes in Ubuntu desktop.

## NVStreamer

To have better user experience, please install chromium browser before running AINVR.

![image](https://github.com/user-attachments/assets/9ce83561-5a4f-40b3-80f1-46befac58009)

NVStreamer is an NVIDIA software that enables storing and serving of video files that can then be streamed using RTSP protocol
Launch Chromium Browser 
In the address bar enter http://127.0.0.1:31000

(Please connect MIC-717 eth1 with internet, it is required for NVStreamer service)

![image](https://github.com/user-attachments/assets/b6ef85a9-df9f-4b95-ad35-fa913c952d4c)

File Upload: 
Select “File Upload” and select a video from file (Supported codec: h264/h265, file: mp4/mkv), drag-and-drop it on UI area.
![image](https://github.com/user-attachments/assets/4ee24c62-1efd-4daa-b50e-270c06d5559b)

## VIT

**Video Storage Toolkit (VST)** is developed by Nvidia. It is particularly suitable for AI based video analytics systems by providing hardware accelerated video decoding, streaming and storage from multiple video sources. VST auto-discovers ONVIF-S compliant IP cameras, and allows use of custom IP stream as video source. It also allows for video to be stored, played back at various speeds, or paused at any frame.

Launch Chromium Browser In the address bar enter http://127.0.0.1:30080/vst

(Please connect MIC-717 eth1 with internet, it is required for VST service)

![image](https://github.com/user-attachments/assets/7e2cd7c4-4e24-4af0-bdba-82352fabd49c)

To setup IP camera manually in Sensor management, input the IP address of RTSP and click submit.
![image](https://github.com/user-attachments/assets/40ba09f4-6fa0-44d1-9d8d-ebf166f669dc)

## ROI

MIC-717 supports up to eight POE cameras and H.265 streams based on using PeopleNet 2.6 model using DLA based inference and NVDCF tracker.

Click ROI and set up region and then select ROI and show, you can check the people counting in video.
![image](https://github.com/user-attachments/assets/f902d616-9825-4494-8dc9-f0ba390c6a5f)

## Video Wall

Based on scenario, user can select multiple stream in video wall.
![image](https://github.com/user-attachments/assets/627888b2-9f89-4baa-9ebe-4b2604357a03)

## Video Record

The files are saved at /data/vst-volume/video.
![image](https://github.com/user-attachments/assets/a1cbbf52-5150-4417-94cc-58b71e4260d5)

**REFERENCE**

https://docs.nvidia.com/moj/setup/ai-nvr.html

https://docs.nvidia.com/moj/setup/quick-start.html

Looking for tech support or have a business inquiry? Let’s talk: [Contact Form](https://www.advantech.com/en/form/2bcb7004-44e9-4e70-9ef0-520f326e6141?callback=f51f1493-33ae-43e5-8172-cb8055499ec1)
