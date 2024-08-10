FROM python:3.8
WORKDIR /OpenEFT
#USER openeft

COPY . /OpenEFT
#RUN pip install --upgrade setuptools && 
RUN apt-get update && apt-get install cmake -y

RUN ./build_docker.sh
ENV PATH="$PATH:/OpenEFT/nbis/nfseg/bin:/OpenEFT/nbis/nfiq/bin"

CMD [ "python3", "./openeft.py"]