<?xml version='1.1' encoding='UTF-8'?>
<project>
  <actions/>
  <description>Job eSchool backend</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty plugin="gitlab-plugin@1.5.11">
      <gitLabConnection></gitLabConnection>
    </com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty>
    <com.sonyericsson.rebuild.RebuildSettings plugin="rebuild@1.30">
      <autoRebuild>false</autoRebuild>
      <rebuildDisabled>false</rebuildDisabled>
    </com.sonyericsson.rebuild.RebuildSettings>
    <hudson.plugins.throttleconcurrents.ThrottleJobProperty plugin="throttle-concurrents@2.0.1">
      <maxConcurrentPerNode>0</maxConcurrentPerNode>
      <maxConcurrentTotal>0</maxConcurrentTotal>
      <categories class="java.util.concurrent.CopyOnWriteArrayList"/>
      <throttleEnabled>false</throttleEnabled>
      <throttleOption>project</throttleOption>
      <limitOneJobWithMatchingParams>false</limitOneJobWithMatchingParams>
      <paramsToUseForLimit></paramsToUseForLimit>
    </hudson.plugins.throttleconcurrents.ThrottleJobProperty>
  </properties>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.9.3">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>https://github.com/IF-090Java/eSchool.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.plugins.sonar.SonarRunnerBuilder plugin="sonar@2.8.1">
      <project></project>
      <properties>sonar.projectKey=my:backend
sonar.projectName=My backend 
sonar.projectVersion=1.0
sonar.sources=.
sonar.exclusions=**/*.java</properties>
      <javaOpts></javaOpts>
      <additionalArguments></additionalArguments>
      <jdk>(Inherit From Job)</jdk>
      <task></task>
    </hudson.plugins.sonar.SonarRunnerBuilder>
    <hudson.tasks.Maven>
      <targets>clean package</targets>
      <mavenName>Maven_name</mavenName>
      <usePrivateRepository>false</usePrivateRepository>
      <settings class="jenkins.mvn.DefaultSettingsProvider"/>
      <globalSettings class="jenkins.mvn.DefaultGlobalSettingsProvider"/>
      <injectBuildVariables>false</injectBuildVariables>
    </hudson.tasks.Maven>
    <jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin plugin="publish-over-ssh@1.20.1">
      <delegate>
        <consolePrefix>SSH: </consolePrefix>
        <delegate plugin="publish-over@0.22">
          <publishers>
            <jenkins.plugins.publish__over__ssh.BapSshPublisher plugin="publish-over-ssh@1.20.1">
              <configName>jenkins</configName>
              <verbose>false</verbose>
              <transfers>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory></remoteDirectory>
                  <sourceFiles>**/*.jar</sourceFiles>
                  <excludes></excludes>
                  <removePrefix>/target</removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand>sudo yum install -y kubectl
sudo cp /workdir/jenkins/application.properties /home/centos
</execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
              </transfers>
              <useWorkspaceInPromotion>false</useWorkspaceInPromotion>
              <usePromotionTimestamp>false</usePromotionTimestamp>
            </jenkins.plugins.publish__over__ssh.BapSshPublisher>
          </publishers>
          <continueOnError>false</continueOnError>
          <failOnError>false</failOnError>
          <alwaysPublishFromMaster>false</alwaysPublishFromMaster>
          <hostConfigurationAccess class="jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin" reference="../.."/>
        </delegate>
      </delegate>
    </jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin>
    <jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin plugin="publish-over-ssh@1.20.1">
      <delegate>
        <consolePrefix>SSH: </consolePrefix>
        <delegate plugin="publish-over@0.22">
          <publishers>
            <jenkins.plugins.publish__over__ssh.BapSshPublisher plugin="publish-over-ssh@1.20.1">
              <configName>jenkins</configName>
              <verbose>false</verbose>
              <transfers>
                <jenkins.plugins.publish__over__ssh.BapSshTransfer>
                  <remoteDirectory></remoteDirectory>
                  <sourceFiles></sourceFiles>
                  <excludes></excludes>
                  <removePrefix></removePrefix>
                  <remoteDirectorySDF>false</remoteDirectorySDF>
                  <flatten>false</flatten>
                  <cleanRemote>false</cleanRemote>
                  <noDefaultExcludes>false</noDefaultExcludes>
                  <makeEmptyDirs>false</makeEmptyDirs>
                  <patternSeparator>[, ]+</patternSeparator>
                  <execCommand>docker build -t app1 .
gcloud auth activate-service-account --key-file ${activate_key}
docker tag app1  gcr.io/${project}/app1:latest
gcloud docker -- push gcr.io/${project}/app1:latest
gcloud config set compute/zone ${region}
gcloud container clusters get-credentials my-gke-cluster
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=${activate_key}
kubectl create secret generic cloudsql-db-credentials --from-literal=username=root --from-literal=password=${user_password}
kubectl apply -f /workdir/kubernetes/deployment_backend.yml
kubectl apply -f /workdir/kubernetes/service_backend.yml</execCommand>
                  <execTimeout>120000</execTimeout>
                  <usePty>false</usePty>
                  <useAgentForwarding>false</useAgentForwarding>
                </jenkins.plugins.publish__over__ssh.BapSshTransfer>
              </transfers>
              <useWorkspaceInPromotion>false</useWorkspaceInPromotion>
              <usePromotionTimestamp>false</usePromotionTimestamp>
            </jenkins.plugins.publish__over__ssh.BapSshPublisher>
          </publishers>
          <continueOnError>false</continueOnError>
          <failOnError>false</failOnError>
          <alwaysPublishFromMaster>false</alwaysPublishFromMaster>
          <hostConfigurationAccess class="jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin" reference="../.."/>
        </delegate>
      </delegate>
    </jenkins.plugins.publish__over__ssh.BapSshBuilderPlugin>
  </builders>
  <publishers>
    <hudson.plugins.ws__cleanup.WsCleanup plugin="ws-cleanup@0.37">
      <patterns class="empty-list"/>
      <deleteDirs>false</deleteDirs>
      <skipWhenFailed>false</skipWhenFailed>
      <cleanWhenSuccess>true</cleanWhenSuccess>
      <cleanWhenUnstable>true</cleanWhenUnstable>
      <cleanWhenFailure>true</cleanWhenFailure>
      <cleanWhenNotBuilt>true</cleanWhenNotBuilt>
      <cleanWhenAborted>true</cleanWhenAborted>
      <notFailBuild>false</notFailBuild>
      <cleanupMatrixParent>false</cleanupMatrixParent>
      <externalDelete></externalDelete>
      <disableDeferredWipeout>false</disableDeferredWipeout>
    </hudson.plugins.ws__cleanup.WsCleanup>
  </publishers>
  <buildWrappers/>
</project>