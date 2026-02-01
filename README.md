# STEdgeAI docker environment image

- Florian Dupeyron (florian.dupeyron@mugcat.fr)
- February 2026


This is a small docker environment that can contain STEdgeAI-Core tools

## Dependencies

- `docker`
- `just` (https://just.systems): Script recipes


## Create the docker image

1. Download `stedgeai-linux-onlineinstaller` program from https://www.st.com/en/development-tools/stedgeai-core.html#st-get-software. Please place the file in the `etc` folder
2. If needed, adjust the version (variable `stedgeai_version` and list of components (`stedgeai_components`) in the `Justfile` file

Available components are:

| Component name | Description                                                               | Dependencies                                      |
|----------------|---------------------------------------------------------------------------|---------------------------------------------------|
| `base` 	     | common components for all targets (hidden)                                |                                                   |
| `core` 	     | common components for STM32, STELLAR and ISPU targets (hidden)            | `stedgeai0105.base`                               |
| `stm32mcu` 	 | STM32Cube.AI component targeting all STM32 MCUs | stedgeai0105.core       | `stedgeai0105.stm32mculib`                        |
| `stm32mculib`  | STM32Cube.AI inference libraries for the STM32 MCUs (hidden)              |                                                   |
| `stneuralart`  | STNeural-Art component targeting STM32N6 with Neural Art                  | `stedgeai0105.stm32mcu`                           |
| `stm32mpu`     | STM32AI-MPU component targeting STM32 MPUs                                | `stedgeai0105.core`                               |
| `stellarmcu`   | StellarStudio.AI component targeting STELLAR MCUs                         | `stedgeai0105.core`, `stedgeai0105.stellarmculib` |
| `stellarmculib`| StellarStudio.AI inference libraries for the STELLAR MCUs (hidden)        |                                                   |
| `ispu`         | ISPU.AI component targeting sensors with an ISPU core                     | `stedgeai0105.core`                               |
| `mlc`          | MLC.AI component targeting sensors with an embedded machine learning core | `stedgeai0105.base`                               |

By default, all components are selected.

3. Create the offline installer file:

```bash
just create-offline-installer
```

This should create a `stedgeai-linux-offline` file in the `etc` folder.

4. Generate the docker image

```bash
just docker-iamge-build
```


## Use the docker image

You can use the `just shell` recipe to start a shell in the current working directory, or use the `exec` recipe to execute a specific command.

For instance:

```
just exec stedgeai generate -m my_model.tflite --target stm32n6 --st-neural-art
```
