#!/usr/bin/env sh

Color_Off='\033[0m'       # Text Reset

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
# Bash Colors End

BIND_PORT=80
CONTAINER_NAME="nginx-on-local"
DEFAULT_DOCKER_NETWORK="my-network"

docker start $CONTAINER_NAME \
    && echo "${IGreen}nginx is online${Color_Off}" \
    && exit

echo "${IBlue}Container does not exist yet. Pulling nginx${Color_Off}"

docker pull nginx:latest
echo "${IGreen}Pulled nginx Docker image${Color_Off}"

docker run -d -p $BIND_PORT:80 \
        --name $CONTAINER_NAME \
        --network  ${PERSONAL_DOCKER_NETWORK:-$DEFAULT_DOCKER_NETWORK} \
        -v $HOME/.dotfiles/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
        -v "$HOME/.dotfiles/nginx/home-page:/usr/share/nginx/html" \
        nginx:latest \
    && echo "${IGreen}nginx is online${Color_Off}" \
    && exit

echo "${IRed}Failed to initialize nginx${Color_Off}"
