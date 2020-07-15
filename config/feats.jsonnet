{
  "random_seed": std.extVar('SEED'),
  "numpy_seed": std.extVar('SEED'),
  "pytorch_seed": std.extVar('SEED'),
  "vocabulary": {
    "non_padded_namespaces": [
    ],
  },
  "dataset_reader": {
      "type": "ucca_reader_conll2019",
      "features": ['pos_tags', 'deprels', 'bios', 'lexcat', 'ss', 'ss2'],
      "token_indexers": {
        "tokens": {
          "type": "single_id",
          "namespace": "tokens",
          "lowercase_tokens": true,
        },
        "token_characters": {
          "type": "characters",
          "namespace": "token_characters",
        }
      },
      "lemma_indexers": {
        "lemmas": {
          "type": "single_id",
          "namespace": "lemmas"
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
    "action_embedding": {
      "embedding_dim": 50,
      "vocab_namespace": "actions"
    },
    "lemma_text_field_embedder": {
      "lemmas": {
        "type": "embedding",
        "vocab_namespace": "lemmas",
        "embedding_dim": 25,
        "trainable": false,
      }
    },
    "hidden_dim": 300,
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
    "batch_size": std.extVar('BATCH_SIZE')
  },
  "trainer": {
    "num_epochs": 200,
    "grad_norm": 5.0,
    "grad_clipping": 5.0,
    "patience": 15,
    "cuda_device": std.parseInt(std.extVar('CUDA_DEVICE')),
    "validation_metric": "+all-f",
    "optimizer": {
      "type": "adam",
      "betas": [0.9, 0.999],
      "lr": 1e-3
    },
    "num_serialized_models_to_keep": 1
  }
}
