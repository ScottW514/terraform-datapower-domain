# Generate Terraform documentation and format examples
tfdocs:
	terraform fmt -recursive .
	terraform-docs -c .terraform-docs.yml .

# Declare phony targets to avoid conflicts with files of the same name
.PHONY: tfdocs
