# AWS Lambda Layer - PyTesseract

**Note**: This is a work in progress, so far it seems that Tesseract is too large to run as a layer, even when stripping to just the minimum amount of files. 

## Requirements

- AWS Account with Command Line Interface (CLI)
- Docker 

## Next Steps

Create a solution where Tesseract can be used inside a Fargate container. The goal is for this to installation and deployment of this to be as automated as possible for developers.