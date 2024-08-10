# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8

EXPOSE 7100

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /OpenEFT
COPY . /OpenEFT

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
#RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /OpenEFT
#USER appuser

RUN apt-get update && apt-get install cmake -y
RUN ./build_docker.sh
ENV PATH="$PATH:/OpenEFT/nbis/nfseg/bin:/OpenEFT/nbis/nfiq/bin"

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:7100", "OpenEFT.wsgi"]
