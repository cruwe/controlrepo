node('master') {

  env.PATH = '/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin'

  stage 'Checkout'

  checkout scm

  stage('Prepare environment') {

    parallel(
      'get_info': {
        sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
      },
      'install_gems': {
        sh '''#!/bin/bash -l
                set -x
                set -o pipefail

                rvm use 2.2

                bundle install --path $HOME/.gem
                bundle update
            '''
      },
//        'build_docker_image': {
//          sh '''#!/bin/bash -l
//                set -x
//                set -o pipefail
//
//                docker build --rm -t <whateverweneed> .
//            '''
//        }
    )
  }

  stage('Validate syntax') {

    parallel(
      'check_erb': {
        try {
          sh '''#!/bin/bash -l
               rvm use 2.2
               bundle exec rake check_erb
               '''
        } catch (err) {
        } finally {
        }
      },
      'check_pp': {
        try {
          sh '''#!/bin/bash -l
                rvm use 2.2
                bundle exec rake check_pp
                '''
        } catch (err) {
        } finally {
        }
      },
      'check_rb': {
        try {
          sh '''#!/bin/bash -l
                rvm use 2.2
                bundle exec rake check_rb
                '''
        } catch (err) {
        } finally {
        }
      },
      'check_hiera': {
        try {
          sh '''#!/bin/bash -l
              rvm use 2.2
              bundle exec rake check_hiera
          '''
        } catch (err) {
        } finally {
        }
      }
    )
  }

  stage('Validate style') {

    parallel(
      'rubocop': {
        try {
          sh '''#!/bin/bash -l
                rvm use 2.2
                bundle exec rake rubocop
             '''
        } catch (err) {
        } finally {
          // NOTICE: https://searchcode.com/codesearch/view/90551087/
          // NOTICE: line 1031 for API doc - could not find sth better, cjr@
          // WARNING: trend graphs are not available for failing projects
          // WARNING: https://issues.jenkins-ci.org/browse/JENKINS-28479
          // TODO: name for link is suboptimal
          step(
            [
              $class                     : "hudson.plugins.checkstyle.CheckStylePublisher",
              canRunOnFailed             : true,
              failedTotalAll             : '5',
              healthy                    : "95",
              pattern                    : "reports/xml/rubocop-checkstyle.xml",
              unhealthy                  : "80",
              unstableTotalAll           : '3',
              usePreviousBuildAsReference: true,
            ]
          )
        }
      },
      'puppet_lint': {
        try {
          sh '''#!/bin/bash -l
              set -e
              set -o pipefail
              rvm use 2.2

              mkdir -p reports/console
              bundle exec rake lint | tee reports/console/puppet-lint.txt
           '''
        } catch (err) {
        }
        finally {
          // WARNING: trend graphs are not available for failing projects
          // WARNING: https://issues.jenkins-ci.org/browse/JENKINS-28479
          step(
            [
              $class                     : 'WarningsPublisher',
              canComputeNew              : false,
              canResolveRelativePaths    : false,
              canRunOnFailed             : true,
              defaultEncoding            : '',
              excludePattern             : '',
              failedTotalAll             : '50',
              healthy                    : '',
              includePattern             : '',
              messagesPattern            : '',
              parserConfigurations       :
                [
                  [
                    pattern   : 'reports/console/puppet-lint.txt',
                    parserName: 'Puppet-Lint',
                  ]
                ],
              unHealthy                  : '',
              unstableTotalAll           : '25',
              usePreviousBuildAsReference: true,
            ]
          )
        }
      },
      'yaml_lint': {
        try {
          sh '''#!/bin/bash -l
              set -e
              set -o pipefail

              mkdir -p reports/console
              yamllint -f parsable -c .yamllint hieradata | tee reports/console/yaml-lint.txt
           '''
        } catch (err) {
        }
        finally {
          // WARNING: trend graphs are not available for failing projects
          // WARNING: https://issues.jenkins-ci.org/browse/JENKINS-28479
          // NOTICE: the yaml-lint parser is a custom parser created by
          // NOTICE: the profiles::infraci::jenkins::warnpublishers resource
          step(
            [
              $class                     : 'WarningsPublisher',
              canComputeNew              : false,
              canResolveRelativePaths    : false,
              canRunOnFailed             : true,
              defaultEncoding            : '',
              excludePattern             : '',
              failedTotalAll             : '50',
              healthy                    : '',
              includePattern             : '',
              messagesPattern            : '',
              parserConfigurations       :
                [
                  [
                    pattern   : 'reports/console/yaml-lint.txt',
                    parserName: 'yaml-lint',
                  ]
                ],
              unHealthy                  : '',
              unstableTotalAll           : '25',
              usePreviousBuildAsReference: true,
            ]
          )
        }
      },
      'metadata_lint': {
        sh '''#!/bin/bash -l
              set -e
              set -o pipefail

              rvm use 2.2
              bundle exec rake metadata_lint
           '''
      }
    )
  }
//
//  stage('Integrate') {
//    try{
//      sh '''#!/bin/bash -l
//            set -e
//            set -o pipefail
//
//            ssh-agent
//            ssh_agent_pid_tmp=$!
//            echo $ssh_agent_pid_tmp
//
//            SSH_AGENT_PID=$(find /tmp/ssh-* -type s | awk -F'.' '{print $NF}')
//            SSH_AUTH_SOCK=$(find /tmp/ssh-* -type s)
//            export SSH_AGENT_PID
//            export SSH_AUTH_SOCK
//
//            bundle exec kitchen create gogs-centos-7-docker
//            ssh-add ./.kitchen/docker_id_rsa
//            bundle exec kitchen converge gogs-centos-7-docker
//            bundle exec kitchen verify gogs-centos-7-docker
//            # kill $ssh_agent_pid_tmp
//         '''
//    } catch (err){
//
//    } finally {
//      sh '''#!/bin/bash -l
//            set -e
//            set -o pipefail
//
//            bundle exec kitchen destroy gogs-centos-7-docker
//            pkill ssh-agent
//         '''
//
//    }
//  }
}
