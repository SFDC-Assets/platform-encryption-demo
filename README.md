# Platform Encryption Demo

This project is part of a series of one-feature Salesforce Platform demos.

From <https://www.platformdemos.com> you can:

- Watch a video of this demo (3 minutes or less).
- Spin up your own instance of the demo in a free scratch org.
- Find related Trailhead content.
- Get high-resolution screenshots.

___

## Installation Instructions

1. [Create your own Dev Hub and setup SFDX](https://trailhead.salesforce.com/en/content/learn/modules/sfdx_app_dev/sfdx_app_dev_setup_dx).


2. Clone this repository:

```
git clone https://github.com/gabesumner/transaction-security
cd transaction-security
```

3. Install [**shane-sfdx-plugins**](https://github.com/mshanemc/shane-sfdx-plugins) (if you don't already have it)

  ```
  sfdx plugins:install shane-sfdx-plugins
  ```

4. Install [**sfdx-migration-automatic**](https://github.com/stomita/sfdx-migration-automatic) (if you don't already have it)

  ```
  sfdx plugins:install sfdx-migration-automatic
  ```


5. Run the startup script

  ```
  sh orgInit.sh
  ```

6. Check out the demo guide on [PlatformDemos.com](https://www.platformdemos.com) for the Platform Encryption demo.
