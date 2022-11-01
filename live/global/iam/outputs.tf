output "iam_arn"{
    value = aws_iam_role.eks.arn
}

output "policy_1" {
    value = aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy
}

output "policy_2" {
    value = aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController
}

output "node_arn"{
    value = aws_iam_role.ng.arn
}

output "wn_policy"{
    value = aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy
}

output "cni_policy"{
    value = aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy
}

output "cont_policy"{
    value = aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly
}