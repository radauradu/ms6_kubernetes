properties([
    parameters([
        password( name: 'AWS_ACCESS_KEY', 
                defaultValue: '', 
                description: 'AWS Credentials: AWS access key ID'),
        password( name: 'AWS_SECRET_KEY', 
                defaultValue: '', 
                description: 'AWS Credentials: AWS secret access key'),
        string( name: 'GIT_URL',
                defaultValue: 'https://github.com/radauradu/ms6_kubernetes',
                description: 'The github repository link'),
        string( name: 'GIT_BRANCH',
                defaultValue: 'master',
                description: 'The github branch link'),
        choice( name: 'ENV', 
                choices: ['live/dev/network', 'live/dev/eks', 'live/global/iam'], 
                description: 'Choose deployment environment (OBS: deploy `network` and `iam` before `EKS`)'),
        choice( name: 'ACTION', 
                choices: ['Apply', 'Destroy'], 
                description: 'Choose the required action for infrastructure')        
    ])
])

def env_list = ["live/global/iam", "live/dev/network", "live/dev/eks"]

node("linux"){
    stage("apply/destroy"){
        checkout scm
         withCredentials([string(credentialsId: params.AWS_ACCESS_KEY, variable: 'AWS_ACCESS_KEY_ID'), 
                          string(credentialsId: params.AWS_SECRET_KEY, variable: 'AWS_SECRET_ACCESS_KEY')]) {
             docker.image('hashicorp/terraform').withRun('-e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY" -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY"') { c ->
                 docker.image('hashicorp/terraform').inside('--entrypoint ""') {
    }
}
}
    }