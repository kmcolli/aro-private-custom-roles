.DEFAULT_GOAL := create

init:
	terraform init

create: init
	terraform plan -out aro.plan -auto-approve		                       \


	terraform apply aro.plan -auto-approve

destroy:
	terraform destroy \
	-var "pull_secret_path=~/Downloads/pull-secret.json" 

destroy.force:
	terraform destroy \
	-var "pull_secret_path=~/Downloads/pull-secret.json" -auto-approve

delete: destroy

help:
	@echo make [create|destroy]
