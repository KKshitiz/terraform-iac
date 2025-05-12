# Generate master password
resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_rds_cluster_parameter_group" "db_cluster_parameter_group" {
  name        = "${var.environment}-${var.project_name}-db-cluster-parameter-group"
  family      = "aurora-postgresql16"
  description = "${var.environment}-${var.project_name}-db-cluster-parameter-group"
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "${var.environment}-${var.project_name}-db-parameter-group"
  family      = "aurora-postgresql16"
  description = "${var.environment}-${var.project_name}-db-parameter-group"

  # parameter {
  #   name  = "rds.force_ssl"
  #   value = "0"
  # }
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.environment}-${var.project_name}-rds-"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  # ingress {
  #   from_port       = 5432
  #   to_port         = 5432
  #   protocol        = "tcp"
  #   security_groups = [var.eks_nodes_security_group_id]
  # }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.environment}-rds"
  }
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "${var.environment}-${var.project_name}-aurora-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.environment}-aurora-db-subnet-group"
  }
}


# Master credentials secret
resource "aws_secretsmanager_secret" "db_master_credentials" {
  name = "${var.environment}-${var.project_name}-rds-master-credentials"

  tags = {
    Type = "master"
  }
}

resource "aws_secretsmanager_secret_version" "db_master_credentials" {
  secret_id = aws_secretsmanager_secret.db_master_credentials.id
  secret_string = jsonencode({
    username = var.database_username
    password = random_password.master_password.result
    host     = aws_rds_cluster.db_cluster.endpoint
    port     = aws_rds_cluster.db_cluster.port
    database = var.database_name
  })

  depends_on = [aws_rds_cluster.db_cluster]
}

resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier = "${var.environment}-${var.project_name}-db-cluster"
  engine             = "aurora-postgresql"
  engine_version     = var.rds_engine_version
  storage_encrypted  = true
  apply_immediately  = true

  database_name   = var.database_name
  master_username = var.database_username
  master_password = random_password.master_password.result
  port            = 5432

  skip_final_snapshot = true
  # final_snapshot_identifier = "snapshot-${var.environment}-db-cluster"
  # performance_insights_enabled = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_cluster_parameter_group.name
  db_subnet_group_name            = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids          = [aws_security_group.rds.id]
}

resource "aws_rds_cluster_instance" "db_cluster_instance" {
  count          = var.rds_instance_count
  instance_class = var.rds_instance_class
  engine         = "aurora-postgresql"
  engine_version = var.rds_engine_version


  identifier              = "${var.environment}-${var.project_name}-db-cluster-instance-${count.index}"
  cluster_identifier      = aws_rds_cluster.db_cluster.id
  db_parameter_group_name = aws_db_parameter_group.db_parameter_group.name
}
