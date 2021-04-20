resource "aws_ec2_transit_gateway" "sample" {
  count                           = var.create_transit_gateway ? 1 : 0
  description                     = format("%s Transit Gateway", var.id)
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  tags                            = var.tags
}

resource "aws_ec2_transit_gateway_route" "example" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id
}
resource "aws_ec2_transit_gateway_route_table" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
}

# Allow traffic from the VPC attachments to the Transit Gateway

resource "aws_ec2_transit_gateway_route_table_association" "example" {
  for_each                       = var.create_transit_gateway_route_table_association_and_propagation && var.config != null ? var.config : {}
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}
resource "aws_ec2_transit_gateway_route_table_propagation" "example" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
}


# VPC attachment

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = [aws_subnet.example.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.example.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags               = {
    Name             = "tgw-att-vpc2"
    scenario         = "var.scenario"
}
depends_on = ["aws_ec2_transit_gateway.test-tgw"]
}