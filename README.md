# Roku Photo Slideshow

A Roku SceneGraph channel that displays photos from a remote source as a fullscreen slideshow.

## Features

- Fullscreen image display

- Automatic slideshow rotation

- Roku SceneGraph implementation

## Installation

1. Clone repository

2. Package as Roku channel

3. Deploy to Roku developer mode device

## Author

Mark J. Gutman

----

AI-Assisted Roku Development Project

Objective:
Gain hands-on experience with AI-assisted software development while investigating stability issues in Roku Backdrops.

Workflow:
- Used Claude to generate initial BrightScript/SceneGraph framework
- Tested on physical Roku hardware
- Used Gemini as a code review and architecture critique tool
- Compared recommendations and validated results through testing

Current State:
- Working prototype displays two remote images simultaneously
- Successfully deploys through Roku developer mode
- Uses Dropbox-hosted assets
- Being extended into slideshow and diagnostics functionality

Key Findings:
- Observed image retrieval timing differences based on asset size
- Identified potential interaction between Google Drive connection resets and Roku image-loading behavior
- Developed hypothesis for Backdrops stability issues requiring further testing
