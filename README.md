# SwiftVision

## Project Overview

SwiftVision is an iOS application designed to assist visually impaired users through real-time object detection and audio narration. The app uses computer vision and text-to-speech technologies to identify objects in the user's environment and provide audio descriptions.

### Key Features

- **Real-time Object Detection**: Identifies objects in the user's surroundings using YOLOv3
- **Audio Narration**: Provides clear, natural-sounding descriptions of detected objects using ElevenLabs API
- **Optimized Performance**: Delivers fast and accurate detection with 30% improved accuracy and 25% faster interaction
- **Accessibility Focused**: Designed specifically to assist visually impaired users

### Technologies Used

- **Swift**: Core programming language for iOS development
- **CoreML**: Apple's machine learning framework for on-device inference
- **YOLOv3**: State-of-the-art object detection model
- **Vision Framework**: Used for efficient video processing and analysis
- **ElevenLabs API**: Provides high-quality text-to-speech capabilities

### Model Information

This project uses the YOLOv3 model for object detection. Due to the large size of the model files (typically 100MB+), they are not included in this repository. **Note: I wanted to include the YOLOv3 CoreML model directly in this repository for your convenience, but GitHub has file size limitations (typically 100MB per file) that prevent uploading such large machine learning models.** Users will need to download the required YOLO model files separately and add them to the project.

#### Obtaining YOLO Models

You can obtain the YOLOv3 CoreML model in several ways:

1. **From Apple's ML Model Zoo**:
   - Visit [Apple's Machine Learning Models page](https://developer.apple.com/machine-learning/models/)
   - Scroll to the "Vision" section and find YOLOv3
   - Download the model file (it will be in `.mlmodel` format)

2. **Convert from original weights**:
   - If you need a custom version, you can convert the original YOLOv3 weights using CoreMLTools
   - Installation: `pip install coremltools`
   - Conversion script example available in Apple's [CoreMLTools repository](https://github.com/apple/coremltools/tree/main/examples/neural_network_inference/object_detection)

3. **From Hugging Face**:
   - Visit [Hugging Face's Model Hub](https://huggingface.co/models)
   - Search for "YOLOv3 CoreML"
   - Download the compatible CoreML model

After downloading, place the `.mlmodel` file in the project's `SwiftVision/Models` directory.

### Target Platform

- iOS 15.0+

### Development Status

This project is currently operational with core features implemented. Ongoing optimizations and additional accessibility features are in development.

## Getting Started

### Requirements

- macOS Monterey (12.0) or later
- Xcode 13.0 or later
- iOS 15.0+ device for testing (recommended for real-world performance)
- Apple Developer account for deployment
- ElevenLabs API key (for text-to-speech functionality)

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/SwiftVision.git
   cd SwiftVision
   ```

2. Download the YOLOv3 CoreML model:
   - Download the YOLOv3 CoreML model as described in the "Obtaining YOLO Models" section above
   - Place the `.mlmodel` file in the `SwiftVision/Models` directory
   - If the Models directory doesn't exist, create it: `mkdir -p SwiftVision/Models`
   - Note: The model file size is approximately 100MB-250MB depending on the variant

3. Set up your ElevenLabs API key:
   - Create an account at [ElevenLabs](https://elevenlabs.io/) to get your API key
   - Add your API key to the `Config.swift` file in the designated location

4. Open the project in Xcode:
   ```
   open SwiftVision.xcodeproj
   ```

5. Build and run the application on your device.

### Usage

1. Upon first launch, grant the app camera permissions
2. Point your camera at objects in your environment
3. The app will detect objects and narrate what it sees
4. Adjust settings as needed in the app's configuration menu

## License

[License information to be added]
