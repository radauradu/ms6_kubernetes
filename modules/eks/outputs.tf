output "endpoint" {
  value = aws_eks_cluster.student-rr-ms6.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.student-rr-ms6.certificate_authority[0].data
}