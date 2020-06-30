NAME = EKS-Accelerator


skeleton:
	python3 skeleton/skeleton.py 

clean:
	rm -rf ps-eks-accelerator/content/*

#http://localhost:1313/ps-eks-accelerator/
run-docs: ## Run in development mode
	cd ps-eks-accelerator && hugo serve -D

docs: ## Build the site
	cd ps-eks-accelerator && hugo -t learn -d public --gc --minify --cleanDestinationDir