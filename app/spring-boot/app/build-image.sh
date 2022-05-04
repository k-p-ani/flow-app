#/bin/bash

# login to push image registry
img login -u ${PUSH_IMAGE_REGISTRY_UNAME} -p ${PUSH_IMAGE_REGISTRY_PWD} ${PUSH_IMAGE_REGISTRY}
if [ $? -ne 0 ]; then
   echo "Failed to login to docker registry ${PUSH_IMAGE_REGISTRY}"
   exit 1
fi
echo "logged into the registry ${PUSH_IMAGE_REGISTRY}"
# check if application img is already available in the registry
img inspect docker://${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} > inspect.log 2>&1
error_count=$(grep -E "error|Error" -c inspect.log)
if [ $error_count -gt 0 ]; then
   touch app-deploy-flag.txt
fi
echo "inspection of image completed ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}"

#build image
img build -t ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} .
if [ $? -ne 0 ]; then
   echo "Failed to build application image ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}"
   exit 1
fi
echo "image ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} build completed" 
#push image
img push ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}
if [ $? -ne 0 ]; then
   echo "Failed to push application image ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION}"
   exit 1
fi

echo "image ${PUSH_IMAGE_REGISTRY}/${PUSH_IMAGE_REPO}/${PUSH_IMAGE_NAME}:${PUSH_IMAGE_VERSION} push completed" 