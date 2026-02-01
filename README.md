# STEdgeAI docker environment image

- Florian Dupeyron (florian.dupeyron@mugcat.fr)
- February 2026


This is a small docker environment that can contain STEdgeAI program


## Create the docker image

1. Download `stedgeai-linux-onlineinstaller` program from https://www.st.com/en/development-tools/stedgeai-core.html#st-get-software. Please place the file in the `etc` folder
2. Please configure the version and list of components you want in your docker environment in the `Justfile` file

Available components are:

| Component name | Description |
|---|---|
|

3. Create the offline installer file:

```bash
just create-offline-installer
```

This should create a `stedgeai-linux-offline` file in the `etc` folder.

4. Generate the docker image

```bash
just docker-iamge-build
```


## Generate the docker image

## Use the docker image
