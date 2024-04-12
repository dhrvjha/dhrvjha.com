# BUILDER

FROM python:3.12.1-slim-bullseye as builder

WORKDIR /usr/src/dhrvjha

ENV PYTHONWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y --no-install-recommends gcc

RUN pip install --upgrade pip
RUN pip install flake8

COPY . /usr/src/dhrvjha
RUN flake8 --ignore=E501,F401

COPY ./requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/dhrvjha/wheels -r requirements.txt

# FINAL

FROM python:3.12.1-slim-bullseye

RUN mkdir -p /home/dhrvjha

RUN addgroup --system dhrvjha && adduser --system --group dhrvjha

ENV HOME=/home/dhrvjha
ENV APP_HOME=/home/dhrvjha/web
ENV DJANGO_SETTINGS_MODULE=dhrvjha.settings_prod
ENV DJANGO_ALLOWED_HOSTS=dhrvjha.dev
ENV DEBUG=1
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update && apt-get install -y --no-install-recommends netcat
COPY --from=builder /usr/src/dhrvjha/wheels/ /wheels
COPY --from=builder /usr/src/dhrvjha/requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache /wheels/*

COPY . $APP_HOME

RUN chown -R dhrvjha:dhrvjha $APP_HOME

USER dhrvjha

EXPOSE 8000

ENTRYPOINT ["gunicorn","dhrvjha.wsgi:application", "--bind", "0.0.0.0:8000"]
