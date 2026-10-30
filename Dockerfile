# H3 Eros Max (picture to video with sound) — RunPod Serverless ComfyUI worker
# Build on RunPod from your own PRIVATE copy of this repo (Dockerfile path = Dockerfile, build context = .).
# The build steps are downloaded from the original repo, so you never need to edit anything but the token (and the optional LORAS and RECOMMENDED lines).

# >>> Put your Civitai API token here (civitai.com → Account settings → Security & Apps → API Keys → Add API key → Read Only). Keep your repo PRIVATE. <<<
ARG CIVITAI_TOKEN=PASTE_YOUR_CIVITAI_TOKEN_HERE

# >>> Optional — LoRAs built into the worker (each video picks which to use): Civitai or Hugging Face links, each followed by
#     its strength (1 when left out), separated by spaces. Leave it empty for none. Example:
#     ARG LORAS="https://civitai.com/models/12345 0.8 https://huggingface.co/user/some-lora 0.6"   <<<
ARG LORAS=""

# >>> RECOMMENDED=1 (default): the creator's recommended setup — sparse attention. Needs CUDA 13 machines and builds close to RunPod's 30-minute limit.
#     RECOMMENDED=0: plain attention — slower, but runs on any machine and builds faster. Use it if the build keeps timing out.   <<<
ARG RECOMMENDED=1

FROM runpod/worker-comfyui:5.10.0-base
ARG LORAS
ARG CIVITAI_TOKEN
ARG RECOMMENDED
ADD https://github.com/afterdark-workers/h3-eros-max/releases/latest/download/build.sh /build.sh
RUN CIVITAI_TOKEN="$CIVITAI_TOKEN" RECOMMENDED="$RECOMMENDED" sh /build.sh
ADD https://github.com/afterdark-workers/h3-eros-max/releases/latest/download/handler.py /handler.py
RUN python /handler.py --bake-loras
