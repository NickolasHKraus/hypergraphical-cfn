.PHONY: help clean deploy
.PHONY: deploy-buildspec deploy-lambda deploy-stack validate-stack zip-buildspec zip-lambda
.DEFAULT_GOAL := help

REGION ?= us-east-1
STACK_NAME = hypergraphical-cfn

help:
	@echo "clean               remove deployment artifacts"
	@echo "deploy              deploy hypergraphical-cfn"
	@echo "deploy-buildspec    deploy buildspec.zip to Amazon S3"
	@echo "deploy-lambda       deploy lambda_function.zip to Amazon S3"
	@echo "deploy-stack        deploy CloudFormation stack"
	@echo "validate-stack      validate CloudFormation stack"
	@echo "zip-buildspec       zip buildspec.yml"
	@echo "zip-lambda          create AWS Lambda deployment package"

clean:
	rm -f buildspec.zip
	rm -f lambda_function.zip
	rm -rf package

deploy: deploy-buildspec deploy-lambda deploy-stack

deploy-buildspec: clean zip-buildspec
	aws s3api put-object \
	--body buildspec.zip \
	--bucket hypergraphical-buildspec \
	--key buildspec.zip

deploy-lambda: clean zip-lambda
	aws s3api put-object \
	--body lambda_function.zip \
	--bucket hypergraphical-lambda \
	--key lambda_function.zip

deploy-stack: validate-stack
	aws cloudformation deploy \
	--stack-name ${STACK_NAME} \
	--template-file cloudformation/template.yaml \
	--capabilities CAPABILITY_IAM \
	--region ${REGION}; \
	EXIT_CODE=$$?; \
	if [ "$$EXIT_CODE" == 255 ]; then \
		exit 0; \
	fi;

validate-stack:
	aws cloudformation validate-template \
	--template-body file://cloudformation/template.yaml

zip-buildspec:
	zip -FS buildspec.zip codebuild/buildspec.yml

zip-lambda:
	mkdir -p package
	pip3 install -r lambda/requirements.txt -t package
	cp -R lambda/lambda_function package
	cd package; \
	zip -9 --exclude '*dist-info*' '*__pycache__*' -r ../lambda_function.zip *;
