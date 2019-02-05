.PHONY: help clean deploy deploy-buildspec deploy-stack validate-stack zip-buildspec
.DEFAULT_GOAL := help

REGION ?= us-east-1
STACK_NAME = hypergraphical-cfn

help:
	@echo "clean               remove deployment artifacts"
	@echo "deploy              deploy hypergraphical-cfn"
	@echo "deploy-buildspec    deploy buildspec.zip to Amazon S3"
	@echo "deploy-stack        deploy CloudFormation stack"
	@echo "validate-stack      validate CloudFormation stack"
	@echo "zip-buildspec       zip buildspec.yml"

clean:
	rm -f buildspec.zip

deploy: deploy-buildspec deploy-stack

deploy-buildspec: clean zip-buildspec
	aws s3api put-object \
	--body buildspec.zip \
	--bucket hypergraphical-buildspec \
	--key buildspec.zip

deploy-stack: validate-stack
	aws cloudformation deploy \
	--stack-name test-hypergraphical-cfn \
	--template-file template.yaml \
	--capabilities CAPABILITY_IAM \
	--region "${REGION}"; \
	EXIT_CODE=$$?; \
	if [ "$$EXIT_CODE" == 255 ]; then \
		exit 0; \
	fi;

validate-stack:
	aws cloudformation validate-template \
	--template-body file://template.yaml

zip-buildspec:
	zip -FS buildspec.zip buildspec.yml
