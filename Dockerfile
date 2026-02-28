# Use PYTORCH CUDA runtime with cuDNN support as the base image
FROM pytorch/pytorch:2.10.0-cuda13.0-cudnn9-devel
    
# Set ENV vars
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    SHELL=/bin/bash \
    COMFYUI_PATH=/stable-diffusion \
    NVIDIA_VISIBLE_DEVICES=all

# Update package list and install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        apt-utils \
        tzdata \
        ffmpeg \
        git \
        software-properties-common \
        wget \
        curl \
        python3.12-venv \
    && apt-get clean

# Set the working directory in the container
WORKDIR ${COMFYUI_PATH}

# Clone ComfyUI and its dependencies
RUN --mount=type=cache,target=/root/.cache/pip \
    git clone https://github.com/comfyanonymous/ComfyUI.git ${COMFYUI_PATH} && \
    cd ${COMFYUI_PATH} && \
    python -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy necessary scripts for startup and comfyui custom nodes dependencies.
COPY extra_model_paths.yaml ${COMFYUI_PATH}
COPY entrypoint.sh /docker/
COPY dependencies_comfy_nodes.sh /docker/
RUN chmod u+x /docker/entrypoint.sh && chmod u+x /docker/dependencies_comfy_nodes.sh

# Make port 7860 available to the world outside this container
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python3 -u main.py --listen --port 7860
