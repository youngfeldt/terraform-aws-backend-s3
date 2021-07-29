# 
Terraform S3 backend with state locking

# NOTE: This module works with Terraform Versions < 0.11.15

## Inputs

 Variable               | Type    |  Purpose          
:----------------------|:--------:| :----------------------
backend_dynamodb_lock_table  | string | Name of dynamoDB table to use for state locking
backend_s3_bucket| string  | Name of bucket housing terraform state files
create_dynamodb_lock_table | boolean | { default = fase } create dynamodb table for state locking ? # Setting true will cause table to be created.
create_s3_bucket   | boolean | { default = fase } create s3 bucket ? # Setting true will cause bucket to be created.    
s3\_key             | string  | name of key where state is kept.  (ie "dev/tf.state", or "prod/tf.state", "dev/data-tier/tf.state", etc..)

## Usage

###### ** Note: Assumes AWS credentials are in effect (either configured or in ENV )

**FIRST**
Include in main.tf:  

```
module s3_backend {
    source = "youngfeldt/backend-s3/aws"  
    version = ">= 1.0.0"
    backend_s3_bucket           = "${var.s3_bucket_name}"  
    backend_dynamodb_lock_table = "${var.dynamodb_state_table_name}"  
    create_dynamodb_lock_table  = < true | false >
    create_s3_bucket            = < true | false >
    s3_key                      = "${project_name}"/${statefile_name}"  
}  
```
Example: *with hardcoded values*  

```
module s3_backend {
	source  = "youngfeldt/backend-s3/aws"
	version = ">= 1.0.0"
	backend_s3_bucket           = "my-uniq-terrraform-state-bucket-name"
	backend_dynamodb_lock_table = "backend_tf_lock"
    create_dynamodb_lock_table  = false
	create_s3_bucket            = false
	s3_key                      = "dev/frontend"
}
```

**THEN**  

 Command                              |       Comment          
 :----------------------------------  | :----------------------  
  **terraform init**                  | Initialize and get modules  
  **terraform plan**                  | As usual..  
  **terraform apply \-auto\-approve** | -auto-approve to avoid prompt about creating resources  
  **terraform init -force-copy**	     | Transition state to backend use flag *-force-copy* to avoid prompt to copy existing local state to backend.  
.

#### To revert to local terraform state:
1. Comment out the backend module
2. Run **terraform init** 
3. Answer "yes" to copying state back from S3.

## Todo:
* Implement option for bucket encryption
