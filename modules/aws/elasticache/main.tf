resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "${var.environment}-${var.project_name}-cache-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_security_group" "elasticache_sg" {
  name        = "${var.environment}-${var.project_name}-elasticache-security-group"
  description = "Allow Redis traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379 # Redis port
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.environment}-${var.project_name}-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379

  apply_immediately = true

  subnet_group_name  = aws_elasticache_subnet_group.cache_subnet_group.name
  security_group_ids = [aws_security_group.elasticache_sg.id]
}
