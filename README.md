This repository hosts unit configuration files that automate
and capture NDN traffic traces from the installed routers. These unit files
were tested on the wide area [NDN testbed](https://named-data.net/ndn-testbed/) routers.

## Requirements
- [Docker Engine](https://docs.docker.com/engine/install/)

## Installation

To install the unit files on the system, simply run the `setup.sh`. They 
internally use [ndntdump](https://github.com/usnistgov/ndntdump) based docker container to capture NDN
traffic traces. The unit files automatically run the container every day from 05:00 - 08:00 UTC 
to capture the traces. Once the capture completes, it tries to copy the generated output files 
to Tennessee Technological University's data server via scp. These behaviors can be changed by modifiying 
the configuration files accordingly for generic use cases.

```
./setup.sh
```

## Uninstallation

To remove the unit files from the system, run the `uninstall.sh`.

```
./uninstall.sh
```
