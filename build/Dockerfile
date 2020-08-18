FROM ubuntu:20.04

ENV S3_PATH
ARG AWS_ACCESS_KEY
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION=us-east-1
ARG LIB_DIR=python
ARG LAYER_NAME=PyTesseractLayer
ARG ZIP_FILE=pytesseract_layer.zip

# Install Dependencies
RUN apt-get -y update && apt-get -y upgrade; apt-get clean
RUN apt-get install -y zip && apt-get install -y unzip && \
    apt-get install -y curl
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN DEBIAN_FRONTEND="noninteractive" TZ=US/ apt-get install -y tzdata
RUN apt-get install -y automake ca-certificates g++ git \
    libtool libleptonica-dev make pkg-config

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install
RUN aws configure set aws_access_key_id ${AWS_ACCESS_KEY} && \
    aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY} && \
    aws configure set default.region ${AWS_REGION}

# Install Tesseract-OCR
WORKDIR /opt
RUN mkdir tesseract/
WORKDIR /tmp
RUN git clone https://github.com/tesseract-ocr/tesseract.git
RUN cd tesseract && \
    ./autogen.sh && ./configure && \
    make && \
    make install && \
    ldconfig


WORKDIR /usr