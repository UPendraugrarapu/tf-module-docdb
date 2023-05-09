resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.env}-docdb"
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = data.aws_ssm_parameter.user.value
  master_password         = data.aws_ssm_parameter.pass.value
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  db_subnet_group_name    = aws_docdb_subnet_group.main.name
  kms_key_id              = data.aws_kms_key.key.arn
  storage_encrypted       = var.storage_encrypted
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.no_of_instances
  identifier         = "${var.env}-docdb-${count.index}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.instnace_class
}

resource "aws_docdb_subnet_group" "main" {
  name       = "${var.env}-docdb"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags, 
    {Name = "${var.env}-subnet-group"}
    )
}
resource "aws_ssm_parameter" "docdb_url" {
  name  = var.parameters[count.index].name
  type  = var.parameters[count.index].type
  value = "mongodb://${data.aws_ssm_parameter.user.value}:${data.aws_ssm_parameter.pass.value}@dev-docdb.cluster-cfwwsa38t5dt.us-east-1.docdb.amazonaws.com:27017/?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
}
resource "aws_ssm_parameter" "docdb_endpoint" {
  name  = var.parameters[count.index].name
  type  = var.parameters[count.index].type
  value = var.parameters[count.index].value
}
resource "aws_ssm_parameter" "docdb_user" {
  name  = var.parameters[count.index].name
  type  = var.parameters[count.index].type
  value = var.parameters[count.index].value
}
resource "aws_ssm_parameter" "docdb_pass" {
  name  = var.parameters[count.index].name
  type  = var.parameters[count.index].type
  value = var.parameters[count.index].value
}