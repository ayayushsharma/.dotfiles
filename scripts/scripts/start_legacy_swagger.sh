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

BIND_PORT=8199
CONTAINER_NAME="qlegacy_swagger_ui"
DEFAULT_DOCKER_NETWORK="my-network"

docker start $CONTAINER_NAME \
    && echo "${IGreen}Legacy Swagger UI is online${Color_Off}" \
    && exit

echo "${IBlue}Container does not exist yet. Pulling legacy swagger${Color_Off}"

docker pull docker.swagger.io/swaggerapi/swagger-editor
echo "Pulled Docker image for Legacy Swagger UI"
echo "${IGreen}Pulled Docker image${Color_Off}"

docker run -d -p $BIND_PORT:8080 \
        --name $CONTAINER_NAME \
        --network  ${PERSONAL_DOCKER_NETWORK:-$DEFAULT_DOCKER_NETWORK} \
    docker.swagger.io/swaggerapi/swagger-editor \
    && echo "${IGreen}Legacy Swagger UI is online${Color_Off}" \
    && exit

echo "${IRed}Failed to initialize swagger UI${Color_Off}"
