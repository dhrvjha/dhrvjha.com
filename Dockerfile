FROM python:3.12.1-slim-bullseye
WORKDIR /usr/src/dhrvjha

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /home/dhrvjha

RUN addgroup --system dhrvjha && adduser --system --group dhrvjha

ENV HOME=/home/dhrvjha
ENV APP_HOME=/home/dhrvjha/web
RUN mkdir $APP_HOME && mkdir $APP_HOME/staticfiles
WORKDIR $APP_HOME
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY . .
