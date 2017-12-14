#!/bin/bash

set -eo pipefail

curl -s https://codecov.io/bash | bash

  $BUDDYBUILD_WORKSPACE/Pods/Fabric/upload-symbols -a $CRASHLYTICS_API_KEY -p ios $BUDDYBUILD_PRODUCT_DIR
