ARG FUNCTION_DIR="/home/app/"

FROM python:3.8-slim-buster
RUN apt-get update
ENV DEBCONF_NOWARNINGS yes
RUN apt-get install -y libgl1-mesa-dev libglib2.0-0 libsm6 libxrender1 libxext6

ARG FUNCTION_DIR
RUN mkdir -p ${FUNCTION_DIR}
COPY ./yolov5/ ${FUNCTION_DIR}


RUN which python3
RUN pip3 install awslambdaric --target ${FUNCTION_DIR}
RUN pip3 install -r ${FUNCTION_DIR}requirements.txt --target ${FUNCTION_DIR}
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
RUN chmod 755 /usr/bin/aws-lambda-rie
WORKDIR ${FUNCTION_DIR}
COPY entry.sh /
RUN chmod 755 /entry.sh
RUN ls -l ${FUNCTION_DIR}
ENTRYPOINT [ "/entry.sh"  ]
CMD [ "app.handler" ]