# Zephyr SDK and RTOS Feature
This feature is a work in progress however, some features are at this stage considered complete.

## SDK Installation
This feature will take a version, e.g. 0.16.8 and will install it however you should note that prior to version 0.14.0, the way the SDK was distributed was different. This was distributed as .run files and contained the full feature set.

The toolchains at the moment are fixed and include **_arm-zephyr-eabi_** and **_x86_64-zephyr-elf_** and in the future will support the entire list as supported by the selected SDK.

The host tools are not currently downloaded but will be supported in future.

## Zephyr RTOS
The Zephyr RTOS will take a revision and download it however it must be noted that the entire set of modules will also be downloaded. There is planned support for a comma separated list of modules that you can choose to download.

