ARG IMAGE
ARG WORKSPACE

# 使用官方基础镜像
FROM 684288478426.dkr.ecr.us-east-1.amazonaws.com/verl:ngc-cu124-vllm0.8.5-sglang0.4.6-mcore0.12.0-te2.3-install-aws-20250601


# # 安装系统依赖
RUN apt-get update && apt-get install -y \
    git wget s3fs build-essential gcc g++ sudo \
    && rm -rf /var/lib/apt/lists/*


ENV NCCL_DEBUG=INFO
ENV NCCL_P2P_DISABLE=1
ENV NCCL_IB_DISABLE=1
ENV NCCL_SHM_DISABLE=1
ENV NCCL_ASYNC_ERROR_HANDLING=1
ENV RAY_IGNORE_UNHANDLED_ERRORS=1
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH


# 设置工作目录
WORKDIR /workspace

ENV CC=/usr/bin/gcc
ENV TRITON_CACHE_DIR=/tmp/triton_cache

# 复制项目文件到容器中
COPY . .

# 安装 Python 依赖
RUN bash scripts/setup_conda.sh

RUN bash scripts/setup_ragen.sh

RUN eval "$($HOME/miniconda3/bin/conda shell.bash hook)" && \
    conda activate ragen && \
    bash scripts/setup_webshop.sh

RUN ray start --head --port=6379


# 设置默认命令
CMD ["sh", "-c", "bash train_3b.sh"]