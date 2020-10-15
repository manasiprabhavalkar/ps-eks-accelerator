NAME = Aqua


########
# HUGO #
########

# Used for quickly making a bunch of .md files
skeleton:
	python3 skeleton/skeleton.py 

# Clean out prob build
clean:
	rm -rf ps-eks-accelerator/public/*
	rm -rf aqua/public/*

#http://localhost:1313/aqua/
dev: build ## Run in development mode
	cd aqua && hugo serve -D

# Used to make the .js and html before serving
build: ## Build the site
#	cd ps-eks-accelerator && hugo -t learn -d public --gc --minify --cleanDestinationDir
	cd aqua && hugo -t learn -d public --gc --minify --cleanDestinationDir

#########
# Build #
#########

compose:
	docker-compose up

create-ecr:
	cd robot-shop/ && ./create-ecr.sh

### Change Account ID in makefiles before running
build-all:
	cd robot-shop/ && ./build-all.sh


#########
# Deploy #
#########

deploy:
	kubectl apply -f robot-shop/K8s/kubectl/templates/

delete:
	kubectl delete -f robot-shop/K8s/kubectl/templates/

#############
# Terraform #
#############

terraform-up:
	cd robot-shop/K8s/terraform && terraform init && terraform plan
