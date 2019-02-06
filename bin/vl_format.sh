find ../VinliSDK -type f -name *.[hm] -exec ./clang-format-3.8-custom -i -style=file {} +
find ../VinliSDK -type f -name *.pch -exec ./clang-format-3.8-custom -i -style=file {} +