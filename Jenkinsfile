pipeline {
    agent { label 'windows' } 
    options { 
        timestamps() 
    }
    environment {
        VERSION_SUFFIX = "${(env.BRANCH_NAME == 'master' ? '' : env.BRANCH_NAME) + env.BUILD_NUMBER}"
    }
    stages {
        stage('Clean') {
            steps {
                bat 'IF EXIST nupkgs RMDIR /S /Q nupkgs'
            }
        }
        stage('Build') {
            steps {
                bat 'dotnet build src/NTextCat.netcore.sln'
            }
        }
        stage('Pack') {
            steps {
                echo 'Packing it with suffix "%VERSION_SUFFIX%"'
                bat 'dotnet pack --version-suffix %VERSION_SUFFIX% --include-source --include-symbols -c Release -o ../../nupkgs ./src/NTextCat.netcore.sln'
            }
        }
        stage('Artifacts') {
            steps {
                archiveArtifacts artifacts: 'nupkgs/*.nupkg', fingerprint: true
            }
        }
        stage('Push') {
            steps {
                withCredentials([string(credentialsId: 'nugetorg_api_key', variable: 'NUGET_API_KEY')]) {
                    bat 'mkdir nupkgs\\symbols'
                    bat 'move nupkgs\\*.symbols.nupkg nupkgs\\symbols'
                    bat 'dotnet nuget push nupkgs\\*.nupkg -k %NUGET_API_KEY% -s https://api.nuget.org/v3/index.json'
                    
                    // https://www.symbolsource.org is unresponsible
                    // bat 'dotnet nuget push nupkgs\\symbols\\*.nupkg -k %NUGET_API_KEY%
                }
            }
        }
    }
}