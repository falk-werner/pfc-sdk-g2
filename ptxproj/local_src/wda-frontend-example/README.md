# WDA Frontend Example

This project contains a brief example how to access WDA frontend via C++, C, Python 3.

While C++ can nativly access WDA via `libparamcom`, other languages need a wrapper. This is done by [libwda_proxy](libwda_proxy). Make sure Python 3 is installed on your device to make python example work.

There is a [pre-release](https://github.com/falk-werner/pfc-sdk-g2/releases/tag/v04.01.10-wda-1.0.0) providing IPKs based on PFC Firmware 23.

## Install and run

- make sure, your are running FW23 (v04.01.10)  
  _SD card image and WUP file can be obtained from [here](https://github.com/falk-werner/pfc-sdk-g2/releases/tag/v04.01.10)_
- install Python 3 _(optional to run Python example)_  
  _Python 3 IPK can be obtained from [here](https://github.com/falk-werner/pfc-sdk-g2/releases/tag/v04.01.10-wda-1.0.0)_
- install wda-fronend-example  
  _IPK can be obtained from [here](https://github.com/falk-werner/pfc-sdk-g2/releases/tag/v04.01.10-wda-1.0.0)_
- log in via SSH and run examples
  - C++: `read-ordernumber-cpp`
  - C: `read-ordernumber-c`
  - Python 3: `read-ordernumber.py`

## Build from source

- make sure, `docker` is installed on your host 
- check out this repository
- switch to `wda` branch
- run `make build` to build firmware

