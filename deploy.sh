#!/bin/bash

# ====== 配置变量 ======
REGION="us-east-1"
SOURCE_ECR_ACCOUNT="763104351884"
TARGET_ECR_ACCOUNT="350694149704"
DOCKER_IMAGE_TAG="ragen"
RANDOM_TAG=$(date +%Y%m%d%H%M%S)  # 时间戳作为随机 tag
TARGET_TAG="qwen2.5_ragen"

# ====== 登录两个 ECR 仓库 ======
echo "Logging into ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${SOURCE_ECR_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 350694149704.dkr.ecr.us-east-1.amazonaws.com
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 684288478426.dkr.ecr.us-east-1.amazonaws.com
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 684288478426.dkr.ecr.us-west-2.amazonaws.com

# ====== 构建 Docker 镜像 ======
echo "====Building Docker image ${DOCKER_IMAGE_TAG}:${RANDOM_TAG}===="
sudo docker build -t ${DOCKER_IMAGE_TAG}:${RANDOM_TAG} .

# # ====== 测试运行 ======
# echo "Running test container..."
docker run --rm -it --shm-size=2g --gpus all ${DOCKER_IMAGE_TAG}:${RANDOM_TAG}

# ====== 打标签并推送到目标仓库 ======
REMOTE_IMAGE="350694149704.dkr.ecr.us-east-1.amazonaws.com/mfivelib:${TARGET_TAG}"
# REMOTE_IMAGE="505298742591.dkr.ecr.us-east-1.amazonaws.com/summer-intern/whx:${TARGET_TAG}"

echo "Tagging image for push: $REMOTE_IMAGE"
docker tag ${DOCKER_IMAGE_TAG}:${RANDOM_TAG} $REMOTE_IMAGE

echo "Pushing image to ECR..."
docker push $REMOTE_IMAGE

echo "Done! Image pushed as: $REMOTE_IMAGE"
