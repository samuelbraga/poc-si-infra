resource "aws_security_group" "worker_group" {
  name_prefix = "sg_worker_group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }
}

resource "aws_security_group" "all_worker" {
  name_prefix = "sg_all_worker"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }
}