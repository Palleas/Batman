#!/bin/bash
AWS_FOLDER="$HOME/.aws"

mkdir -p $AWS_FOLDER || true

cp "$BUDDYBUILD_SECURE_FILES/aws-config" "$AWS_FOLDER/config"
cp "$BUDDYBUILD_SECURE_FILES/aws-credentials" "$AWS_FOLDER/credentials"
