{
  "random_seed": std.extVar('SEED'),
  "numpy_seed": std.extVar('SEED'),
  "pytorch_seed": std.extVar('SEED'),
  "vocabulary": {
    "non_padded_namespaces": []
  },
  "dataset_reader": {
      "type": "ucca_reader_conll2019",
      "features": ['pos_tags', 'deprels', 'bios', 'lexcat', 'ss', 'ss2'],
      "token_indexers": {
        "tokens": {
          "type": "bert-pretrained",
          "pretrained_model": std.extVar('BERT_PATH'),
          "do_lowercase": std.extVar('LOWER_CASE')=='TRUE'
        }
      },
      "action_indexers": {
        "actions": {
          "type": "single_id",
          "namespace": "actions"
        }
      },
      "pos_tag_indexers": {
          "pos_tags": {
              "type": "single_id",
              "namespace": "pos_tags"
          }
      },
      "arc_tag_indexers": {
        "arc_tags": {
          "type": "single_id",
          "namespace": "arc_tags"
        }
      },
  },
  "train_data_path": std.extVar('TRAIN_PATH'),
  "validation_data_path": std.extVar('DEV_PATH'),
  "model": {
    "type": "transition_parser_ucca",
    "text_field_embedder": {
      "tokens": {
        "type": "bert-pretrained",
        "pretrained_model": std.extVar('BERT_PATH'),
        "requires_grad": true,
        "top_layer_only": false
      },
      "embedder_to_indexer_map": {
        "tokens": ["tokens", "tokens-offsets", "tokens-type-ids"]
      },
      "allow_unmatched_keys": true
    },
    "mces_metric": {
        "type": "mces",
        "output_type": "f",
        "trace": 0,
        "cores": 10
    },
    "pos_tag_embedding": {
      "embedding_dim": 20,
      "vocab_namespace": "pos"
    },
    "action_embedding": {
      "embedding_dim": 50,
      "vocab_namespace": "actions"
    },
    "deprel_embedding": {
        "embedding_dim": 20,
        "vocab_namespace": "deprels"
    },
    "bios_embedding": {
        "embedding_dim": 20,
        "vocab_namespace": "bios"
    },
    "lexcat_embedding": {
        "embedding_dim": 20,
        "vocab_namespace": "lexcat"
    },
    "ss_embedding": {
        "embedding_dim": 20,
        "vocab_namespace": "ss"
    },
    "ss2_embedding": {
        "embedding_dim": 20,
        "vocab_namespace": "ss2"
    },
    "word_dim": 1024,
    "hidden_dim": 200,
    "action_dim": 50,
    "ratio_dim" : 1,
    "num_layers": 2,
    "recurrent_dropout_probability": 0.2,
    "layer_dropout_probability": 0.2,
    "same_dropout_mask_per_instance": true,
    "input_dropout": 0.2,
    "initializer": [
      ["p_.*weight", {"type": "xavier_uniform"}],
      ["p_.*bias", {"type": "zero"}],
      ["pempty_buffer_emb", {"type": "normal"}],
      ["proot_stack_emb", {"type": "normal"}],
      ["pempty_action_emb", {"type": "normal"}],
      ["pempty_stack_emb", {"type": "normal"}],
    ]
  },
  "iterator": {
    "type": "bucket",
    "sorting_keys": [["tokens", "num_tokens"]],
    "batch_size": std.parseInt(std.extVar('BATCH_SIZE')),
    "max_instances_in_memory": 1
  },
  "trainer": {
    "num_epochs": std.parseInt(std.extVar('EPOCHS')),
    "grad_norm": 5.0,
    "grad_clipping": 5.0,
    "patience": 5,
    "cuda_device": std.parseInt(std.extVar('CUDA_DEVICE')),
    "validation_metric": "+all-f",
    "optimizer": {
      "type": "adam",
      "parameter_groups": [
        [[".*bert.*"], {"lr": 5e-5}],
        [["^((?!bert).)*$"], {}]
      ],
      "betas": [0.9, 0.999],
      "lr": 1e-3
    },
    "learning_rate_scheduler": {
      "type": "slanted_triangular",
      "num_epochs": std.parseInt(std.extVar('EPOCHS')),
      "num_steps_per_epoch": 1000,
      "cut_frac": 0.1,
      "ratio": 32,
      "gradual_unfreezing": true,
      "discriminative_fine_tuning": true,
      "decay_factor": 1.0,
    },
    "num_serialized_models_to_keep": 50
  }
}
