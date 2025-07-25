set -e


python train.py system.CUDA_VISIBLE_DEVICES=\"0,1,2,3,4,5,6,7\" \
    actor_rollout_ref.rollout.rollout_filter_ratio=0.5 \
    trainer.experiment_name=sokoban-ppo-rolloutfilter0.5-qwen2.5-14B \
    trainer.nnodes=2
    