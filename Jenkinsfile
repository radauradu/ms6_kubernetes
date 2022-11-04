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
def env_list2 = ["live/dev/eks", "live/dev/network"]

node("linux"){
    stage("apply/destroy"){
        checkout scm
         /*withCredentials([string(credentialsId: params.AWS_ACCESS_KEY, variable: 'AWS_ACCESS_KEY_ID'), 
                          string(credentialsId: params.AWS_SECRET_KEY, variable: 'AWS_SECRET_ACCESS_KEY')]) { */
           withCredentials([string(credentialsId: 'rr_access_key', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'rr_secret_key', variable: 'AWS_SECRET_ACCESS_KEY')]) {               
             docker.image('hashicorp/terraform').withRun('-e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY" -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY"') { c ->
                 docker.image('hashicorp/terraform').inside('--entrypoint ""') {

                    if(params.ACTION == 'Apply') {
                        for(String item : env_list) {
                            sh '''
                            cd '''+item+'''
                            echo "Current directory: $(pwd)"
                            terraform init
                            terraform plan -out=plan'''
                            env.PLAN = input message: 'Do you want to implement plan?', parameters: [choice(name: 'PLAN', choices: ['YES', 'NO'], description: 'Implement plan')]
                             if (env.PLAN == 'YES') {
                                 sh '''
                                 cd '''+item+'''
                                 terraform apply plan
                                 '''
                                 }
                        }
                    }

                    if(params.ACTION == 'Destroy') {
                        for(String item : env_list2) {
                            sh '''
                            cd '''+item+'''
                            echo "Current directory: $(pwd)"
                            terraform init
                            terraform plan -destroy -out=plan'''
                            env.PLAN = input message: 'Do you want to destroy everything?', parameters: [choice(name: 'PLAN', choices: ['YES', 'NO'], description: 'Get rid of everything')]
                             if (env.PLAN == 'YES') {
                                 sh '''
                                 cd '''+item+'''
                                 terraform apply plan
                                 '''             

                        }
                    }
    }
}
}
}
}
}
           