FROM ubuntu:16.04

RUN apt-get update && \
        apt-get install -y software-properties-common && \
        add-apt-repository ppa:deadsnakes/ppa && \
        apt-get update -y  && \
        apt-get install -y build-essential python3.6 python3.6-dev python3-pip libgl1-mesa-glx && \
        apt-get install -y git  curl && \
        # update pip
        python3.6 -m pip install pip --upgrade && \
        python3.6 -m pip install wheel


RUN mkdir /src
WORKDIR /src
COPY . .

RUN pip3 install -r requirements.txt && \
        pip3 install jupyter

# Install Mask RCNN and download pretrained weights 
RUN git clone https://github.com/matterport/Mask_RCNN.git && \
        cd Mask_RCNN && \
        pip3 install -r requirements.txt && \
        python3.6 setup.py install && \
        curl -O https://github.com/matterport/Mask_RCNN/releases/download/v2.0/mask_rcnn_coco.h5 && \
        cd ..

# Install Coco Dependencies
RUN git clone https://github.com/waleedka/coco && \
        cd coco/PythonAPI/ && \
        python3.6 setup.py build_ext install && \
        rm -rf build && \
        cd ../..

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# WORKDIR /src/notebooks

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
