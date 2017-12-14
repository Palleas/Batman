#!/bin/bash

set -eo pipefail

curl -s https://codecov.io/bash | bash

find $BUDDYBUILD_PRODUCT_DIR -name "*.dSYM" | xargs \
  -I \{\} $BUDDYBUILD_WORKSPACE/Pods/Fabric/upload-symbols \
  -a $CRASHLYTICS_API_KEY \
  -p ios \{\}
