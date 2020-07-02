NAME = EKS-Accelerator

# Used for quickly making a bunch of .md files
skeleton:
	python3 skeleton/skeleton.py 

# Clean out prob build
clean:
	rm -rf ps-eks-accelerator/public/*

#http://localhost:1313/ps-eks-accelerator/
dev: ## Run in development mode
	cd ps-eks-accelerator && hugo serve -D

# Used to make the Prod version
prod: ## Build the site
	cd ps-eks-accelerator && hugo -t learn -d public --gc --minify --cleanDestinationDir