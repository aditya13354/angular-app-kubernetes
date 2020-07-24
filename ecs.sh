TASK_FAMILY=ccf-auto
SERVICE_NAME=ccf-auto
NEW_DOCKER_IMAGE="890838507098.dkr.ecr.us-east-1.amazonaws.com/ccf-automation:${BUILD_NUMBER}"
#NEW_DOCKER_IMAGE=890838507098.dkr.ecr.us-east-1.amazonaws.com/ccf-automation:51
echo $NEW_DOCKER_IMAGE
echo $buildNumber
CLUSTER_NAME=ccf-auto
OLD_TASK_DEF=$(aws ecs describe-task-definition --task-definition $TASK_FAMILY --region us-east-1)
NEW_TASK_DEF=$(echo $OLD_TASK_DEF | jq --arg NDI $NEW_DOCKER_IMAGE '.taskDefinition.containerDefinitions[0].image=$NDI')
FINAL_TASK=$(echo $NEW_TASK_DEF | jq '.taskDefinition|{family: .family, volumes: .volumes, containerDefinitions: .containerDefinitions}')
aws ecs register-task-definition --family $TASK_FAMILY --region us-east-1 --cli-input-json "$(echo $FINAL_TASK)"
aws ecs update-service --service $SERVICE_NAME --task-definition $TASK_FAMILY --cluster $CLUSTER_NAME --region us-east-1
