# RAGEN re-implementation


## (Optional) Preliminary Set Up on Greenland

If you are working on ASG, skip this step.

```bash
# Download the Miniconda installer script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

# Install to $HOME/miniconda3 in batch mode
bash ~/miniconda.sh -b -p $HOME/miniconda3

# Activate conda (only in the current shell)
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"

# Accept the ToS for the main channel:
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main

conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# (Optional) Add conda to your default shell startup
conda init

# Reload shell config
source ~/.bashrc
```

## Install RAGEN

```bash
git clone https://github.com/WillDreamer/RAGEN.git
cd RAGEN

# Setup and download the dataset
bash scripts/setup_ragen.sh
```

## Run on Sokoban

```bash
conda activate ragen

## Install models
python -c "import transformers; transformers.pipeline('text-generation', model='Qwen/Qwen2.5-0.5B-Instruct')"

export WANDB_ENTITY="RL_Reasoning"
export EXP_NAME=RAGEN_Sokoban 
export WANDB_PROJECT="${WANDB_ENTITY}_${EXP_NAME}"
export WANDB_API_KEY="ba70fcbc92808cc7a1750dd80ac3908295e6854f"

# run ppo by default
python train.py 
# if you want to use other environments, override the config-name

# Override configuration parameters for Sokoban environment
# This example sets the rollout filter ratio to 0.25
# You can also find this example in `train_all.sh`
python train.py \
    trainer.experiment_name=sokoban-ppo-rolloutfilter0.25 \
    actor_rollout_ref.rollout.rollout_filter_ratio=0.25
```
For example, you can edit config/base.yaml to change the default parameters for your experiments, or create new custom environment settings at config/envs.yaml. This approach is particularly useful when you want to maintain different configurations for various experimental setups.

## (optional) Ray cluster on Greenland
```bash

# 启动head
conda activate ragen
ray start --head --port=6379

# 加入node
conda activate ragen
ray start --address='10.0.168.252:6379'

# check
ray status

# 安装tmux
sudo apt install -y tmux

```


