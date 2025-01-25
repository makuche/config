-- run :help llama_config for config params or check out the repo
-- To start the server, run the following:
-- llama-server -hfr ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF \
-- --hf-file qwen2.5-coder-3b-q8_0.gguf \
-- --port 8012 -ngl 99 -fa -ub 1024 -b 1024 -dt 0.1 --ctx-size 0 --cache-reuse 256
return {
  'ggml-org/llama.vim',
}
