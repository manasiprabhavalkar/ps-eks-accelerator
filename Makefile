NAME = EKS-Accelerator


########
# HUGO #
########

# Used for quickly making a bunch of .md files
skeleton:
	python3 skeleton/skeleton.py 

# Clean out prob build
clean:
	rm -rf ps-eks-accelerator/public/*

#http://localhost:1313/ps-eks-accelerator/
dev: build ## Run in development mode
	cd ps-eks-accelerator && hugo serve -D

# Used to make the .js and html before serving
build: ## Build the site
	cd ps-eks-accelerator && hugo -t learn -d public --gc --minify --cleanDestinationDir

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