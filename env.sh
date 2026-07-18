# Source this inside the SDK docker container to build ESP-AT against the
# ESP8266_RTOS_SDK baked into the image (IDF_PATH), without build.py and
# without cloning esp-idf into the project.
#
#   source env.sh
#   idf.py -DIDF_TARGET=esp8266 build
#
# Re-source after any `idf.py fullclean` / `rm -rf build` (it recreates
# build/module_info.json, which the factory_param.bin generator reads).

# Trust the bind-mounted repos (container runs as root, host files are uid 1000).
git config --global --add safe.directory '*'

export ESP_AT_PROJECT_PLATFORM=PLATFORM_ESP8266
export ESP_AT_MODULE_NAME=ESP8266_ESP01S      # -> module_config/module_esp8266_esp01s
export ESP_AT_PROJECT_PATH="$(pwd)"
export SILENCE=0

# build.py normally writes this; the customized_partitions component reads
# platform/module from it to generate factory_param.bin. We bypass build.py,
# so create it here.
mkdir -p build
cat > build/module_info.json <<EOF
{"platform": "${ESP_AT_PROJECT_PLATFORM}", "module": "${ESP_AT_MODULE_NAME}", "silence": ${SILENCE}}
EOF

echo "ESP-AT env ready: module=$ESP_AT_MODULE_NAME, IDF_PATH=$IDF_PATH"
echo "Build with: idf.py -DIDF_TARGET=esp8266 build"
