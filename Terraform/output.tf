output "Scylla_Node_A" {
    value = "ssh -i ${var.Key_Pair_Name}.pem ubuntu@${aws_instance.scylla_node_a.public_ip}"
}

output "Scylla_Node_B" {
    value = "ssh -i ${var.Key_Pair_Name}.pem ubuntu@${aws_instance.scylla_node_b.public_ip}"
}

output "Scylla_Node_C" {
    value = "ssh -i ${var.Key_Pair_Name}.pem ubuntu@${aws_instance.scylla_node_c.public_ip}"
}