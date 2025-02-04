FROM python:slim

WORKDIR /

RUN pip3 install poetry

COPY poetry.lock /
COPY pyproject.toml /

RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-dev --no-ansi

FROM python:slim

WORKDIR /

# copy pre-built packages to this image
COPY --from=0 /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# now copy the actual code we will execute (poetry install above was just for dependencies)
COPY kube_downscaler /kube_downscaler

ARG VERSION=dev

RUN sed -i "s/__version__ = .*/__version__ = '${VERSION}'/" /kube_downscaler/__init__.py

ENTRYPOINT ["python3", "-m", "kube_downscaler"]
