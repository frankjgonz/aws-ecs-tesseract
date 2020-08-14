FROM ubuntu:20.04

ARG AWS_ACCESS_KEY
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION=us-east-1
ARG LIB_DIR=python
ARG LAYER_NAME=PyTesseractLayer
ARG ZIP_FILE=pytesseract_layer.zip
ARG LAYER_DESC="This layer was built frankjgonz @ GitHub (https://github.com/frankjgonz/aws-pytesseract-lambda-layer); it includes the Tesseract OCR engine, the Pillow module, and the PyTesserat module."
ARG LAYER_RUNTIMES="python3.6 python3.7 python3.8"

RUN apt-get -y update && apt-get -y upgrade; apt-get clean
RUN apt-get install -y zip && apt-get install -y unzip
RUN apt-get install -y python3
RUN apt-get install -y python3-pip 
#RUN apt-get install -y tesseract-ocr

#Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install
RUN aws configure set aws_access_key_id ${AWS_ACCESS_KEY} && \
    aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY} && \
    aws configure set default.region ${AWS_REGION}

WORKDIR /tmp
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt ${LIB_DIR}

RUN cp -r ./${LIB_DIR} /opt/${LIB_DIR}
#RUN cp -r /usr/bin/tesseract /opt/tesseract

WORKDIR /opt
RUN zip -r ${ZIP_FILE} .
#RUN aws lambda publish layer-version --layer-name ${LAYER_NAME} \
#    --description ${LAYER_DESC} --compatible-runtimes ${LAYER_RUNTIMES} \
#    --zip-file fileb://${ZIP_FILE}

EXPOSE 80 
CMD bash