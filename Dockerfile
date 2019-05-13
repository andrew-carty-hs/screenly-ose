FROM debian:stretch
MAINTAINER Viktor Petersson <vpetersson@screenly.io>

RUN apt-get update && \
    apt-get -y install \
        build-essential \
        curl \
        ffmpeg \
        git-core \
        libffi-dev \
        libssl-dev \
        mplayer \
        net-tools \
        procps \
        python-dev \
        python-gobject \
        python-imaging \
        python-netifaces \
        python-simplejson \
        sqlite3 \
    && \
    apt-get clean

# Install Python requirements
ADD requirements.txt /tmp/requirements.txt
ADD requirements.dev.txt /tmp/requirements.dev.txt
RUN curl -s https://bootstrap.pypa.io/get-pip.py | python && \
    pip install -r /tmp/requirements.txt && \
    pip install -r /tmp/requirements.dev.txt

# Create runtime user
RUN useradd pi

# Install config file and file structure
RUN mkdir -p /opt/pi/.screenly /opt/pi/screenly /opt/pi/screenly_assets
COPY ansible/roles/screenly/files/screenly.conf /opt/pi/.screenly/screenly.conf

# Copy in code base
COPY . /opt/pi/screenly
RUN chown -R pi:pi /opt/pi

USER pi
WORKDIR /opt/pi/screenly

EXPOSE 8080

CMD python server.py
