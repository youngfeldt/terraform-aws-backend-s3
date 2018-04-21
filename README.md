# Module to create terraform remote backend in S3 with state locking

## Inputs

 Variable               | Type    |  Purpose          
:----------------------|:--------:| :----------------------
create\_s3_bucket   | boolean | create s3 bucket ? { default = false } # Assumes bucket already exists from other backend stores. Setting true will cause bucket to be created.
tf_backend_s3_bucket| string  | Bucket housing terraform state files
s3\_key             | string  | name of key where state is kept.  (ie "dev/tf.state", or "prod/tf.state", "dev/data-tier/tf.state", etc..)
dynamodb\_state\_lock\_table  | string | Name of dynamoDB table to use for state locking


## Usage
###### ** Note: Assumes AWS credentials are in effect (either configured or in ENV )

**FIRST**   
Include in main.tf:  

```
module s3_backend {
    source = "youngfeldt/backend-s3/aws"  
    version = ">= 1.0.0"
    create_s3_bucket = < true | false >
    tf_backend_s3_bucket = "${var.s3_bucket_name}"  
    dynamodb_state_lock_table = "${var.dynamodb_state_table_name}"  
    s3_key = "${project_name}"/${statefile_name}"  
}  
```  
Example: *with hardcoded values*  

```
module s3_backend {
	source = "youngfeldt/backend-s3/aws"
	version = ">= 1.0.0"  
	
	create_s3_bucket = false
	tf_backend_s3_bucket = "my-uniq-terrraform-state-bucket-name"
	dynamodb_state_lock_table = "dev_tf_lock"
	s3_key = "dev/tf.state"
}
```

**THEN**  

 Command                              |       Comment          
 :----------------------------------  | :----------------------  
  **terraform init**                  | Initialize and get modules  
  **terraform plan**                  | As usual..  
  **terraform apply \-auto\-approve** | -auto-approve to avoid prompt about creating resources  
  **terraform init -force-copy**	     | Transition state to backend use flag *-force-copy* to avoid prompt to copy existing local state to backend.  


 
#### To revert to local terraform state:
1. Comment out the backend module
2. Run **terraform init** 
3. Answer "yes" to copying state back from S3.

 