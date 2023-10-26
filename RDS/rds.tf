resource "aws_db_instance" "myRDS" {
  engine = "mysql"
  engine_version = "8.0.27"
  allocated_storage = 20
  instance_class = "db.t3.micro"
  storage_type = "gp2"
  identifier = "mydb"
  username = "admin"
  password = "password#123"
  publicly_accessible = true # default it is false, for public access
  skip_final_snapshot = true # default it is false, for taking the snapshots

  tags = {
    Name = "myrdsdb"
  }
}