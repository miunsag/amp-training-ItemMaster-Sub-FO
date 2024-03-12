# News Service Microservices Runtime Example 

## Prerequisites

- you must have access to a base Microservices Runtime (MSR) image, either downloaded from a Software AG source or build by yourself. It is recommended to have the obtained the image with the approach described [here](https://github.com/SoftwareAG/sag-mainstream-devops-az-02-01-container-images-set1)
- You must have a valid MSR license file
- You must have pull and push access to a container registry where the pipeline will pull the base image from and push the resulting image to. For simplicity reasons, this project considers a single registry for both operations
- in order to mount the Azure pipeline into Azure DevOps, you need to upload into the project's library a secure file called `acr.sp.credentials.sh` having the contents described [here](https://github.com/SoftwareAG/sag-mainstream-devops-az-00-prerequisites/blob/main/secureFiles/example.acr.sp.credentials.sh)
  - Remember this file is a unix file and must have unis endlines
- Your Azure DevOps project must be able to use a custom agents pool called `WmDevOpsTutorialAgentsPool`. Change the name in the azure-pipelines.yml file if needed.

## Quick Start

- Use this repository as a GitHub template. Use the template to generate a new repository
- Clone and change the setEnv.sh file in the folder buildScripts to reflect your specific needs and environment
- Create a new pipeline in your Azure DevOps project
- Adapt the code as needed
- Each run config has an `example.env` file. Copy it in the `.env` file and adapt to your own environment before launching the specific run configuration

------------------------------

These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
