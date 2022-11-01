data "terraform_remote_state" "network" {
    backend = "s3"
    config = {
        bucket = "rr-s3-bucket-ms6-tfstate"
        key = "modules/network/terraform.tfstate"
        region = "eu-central-1"
    }
}

data "terraform_remote_state" "iam" {
    backend = "s3"
    config = {
        bucket = "rr-s3-bucket-ms6-tfstate"
        key = "live/global/iam/terraform.tfstate"
        region = "eu-central-1"
    }
}





resource "aws_eks_cluster" "student-rr-ms6" {
  name     = "student-rr_eks_ms6"
  role_arn = data.terraform_remote_state.iam.outputs.iam_arn

  vpc_config {
    subnet_ids = [data.terraform_remote_state.network.outputs.subnets_public, data.terraform_remote_state.network.outputs.subnets_private] 
    
    #[aws_subnet.example1.id, aws_subnet.example2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    data.terraform_remote_state.iam,
    data.terraform_remote_state.iam,
  ]
}
#node group

resource "aws_eks_node_group" "student-rr_eks_ng" {
  cluster_name    = aws_eks_cluster.student-rr-ms6.name
  node_group_name = "rr-ng-ms6"
  node_role_arn   = data.terraform_remote_state.iam.outputs.node_arn
  subnet_ids      = data.terraform_remote_state.network.outputs.subnets_priv
 

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    data.terraform_remote_state.iam,
    data.terraform_remote_state.iam,
    data.terraform_remote_state.iam,
  ]
}

terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "aws_eks_cluster_auth" "eks_cluster"{
  name = aws_eks_cluster.student-rr-ms6.id
}

provider "kubectl" {
  host                   = aws_eks_cluster.student-rr-ms6.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.student-rr-ms6.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
  load_config_file       = false
}

resource "kubectl_manifest" "test" {
    force_new = true
    yaml_body = <<YAML
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::721078768257:role/student-rr-eks-node-group-ms6
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::721078768257:user/adelin.popa
      username: adelin.popa
      groups:
        - system:masters
    - userarn: arn:aws:iam::721078768257:user/bogdan.cimpeanu
      username: bogdan.cimpeanu
      groups:
        - system:masters
    - userarn: arn:aws:iam::721078768257:user/bogdan.socaciu
      username: bogdan.socaciu
      groups:
        - system:masters
    - userarn: arn:aws:iam::721078768257:user/radu.marin
      username: radu.marin
      groups:
        - system:masters
    - userarn: arn:aws:iam::721078768257:user/marius.ghebuta
      username: marius.ghebuta
      groups:
        - system:masters
    - userarn: arn:aws:iam::721078768257:user/radu.radau
      username: radu.radau
      groups:
        - system:masters            
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
YAML
}


/*

map_users = [
    {
      userarn  = "arn:aws:iam::721078768257:user/adelin.popa"
      username = "adelin.popa"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::721078768257:user/bogdan.cimpeanu"
      username = "bogdan.cimpeanu"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::721078768257:user/bogdan.socaciu"
      username = "bogdan.socaciu"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::721078768257:user/marius.ghebuta"
      username = "marius.ghebuta"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::721078768257:user/radu.marin"
      username = "radu.marin"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::721078768257:user/radu.radau"
      username = "radu.radau"
      groups   = ["system:masters"]
    }
    */