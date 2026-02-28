Docker files to containerize ComfyUI installation, setup and run.

# Details

The image and container building process includes:
* A light-weight Ubuntu with Pytorch image base.
* Installation of git, python venv and dependencies.
* Cloning of ComfyUI source code.
* ComfyUI installation and its dependencies.
* Launching ComfyUI app each time the container is started.

# Installation
```
# clone the repo
git clone https://github.com/Karlmeister/comfyui_docker.git

# change to the folder where the repo was cloned
cd comfyui_docker

# build the image and run the Container
# ComfyUI  will run automatically at http://localhost:7860/ once the container starts up
docker compose up --build
```

# References
ComfyUI:
https://github.com/Comfy-Org/ComfyUI

pytorch base image:
https://hub.docker.com/r/pytorch/pytorch/tags
