# Settings section
# --------------------------------
jenkins_repo_remote=http://pkg.jenkins-ci.org/redhat/jenkins.repo
jenkins_repo_local=/etc/yum.repos.d/jenkins.repo
jenkins_rpm_key=https://jenkins-ci.org/redhat/jenkins-ci.org.key
jenkins_url_local=http://localhost:8080
jenkins_url_ucenter=http://updates.jenkins-ci.org
jenkins_cli_jar=/tmp/jenkins-cli.jar
jenkins_cli="java -jar $jenkins_cli_jar -s $jenkins_url_local"
timeZone="Europe/Vienna"


# download and install jenkins
# --------------------------------
echo "[$1]:Providing Jenkins!"
sudo wget -O $jenkins_repo_local $jenkins_repo_remote
sudo rpm --import $jenkins_rpm_key
sudo yum -y install jenkins
sudo service jenkins start


# Download the CLI tool
echo ">> Downloading jenkins cli into:" $jenkins_cli_jar
requested_file=$jenkins_url_local'/jnlpJars/jenkins-cli.jar'
echo "via: curl -L $requested_file -o $jenkins_cli_jar"
curl -L $requested_file -o $jenkins_cli_jar
# set the jenkins cli jar to executable
chmod +x $jenkins_cli_jar


# Perform necessary updates
## Update the timezone
echo ">> Updating timezone"
echo 'JAVA_ARGS="-Dorg.apache.commons.jelly.tags.fmt.timeZone='$timeZone'"'  >> /etc/default/jenkins

## Update the update center
echo ">> Updating update center"
requested_file=$jenkins_url_ucenter'/update-center.json'
postback_location=$jenkins_url_local'/updateCenter/byId/default/postBack'
echo "via: curl -L $requested_file | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- $postback_location"
curl -L $requested_file | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- $postback_location

## Update installed plugins
UPDATE_LIST=$( java -jar $jenkins_cli_jar -s $jenkins_url_local list-plugins | grep -e ')$' | awk '{ print $1 }' ); 
if [ ! -z "${UPDATE_LIST}" ]; then 
    echo Updating Jenkins Plugins: ${UPDATE_LIST}; 
    java -jar $jenkins_cli_jar -s $jenkins_url_local install-plugin ${UPDATE_LIST};
    java -jar $jenkins_cli_jar -s $jenkins_url_local safe-restart;
fi


# Install plugins
# --------------------------------
#via: java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 install-plugin git
echo ">> Installing plugins"
pwd
IFS=$'\r\n' GLOBIGNORE='*' command eval  'plugins=($(cat jenkins_plugins.txt))'

for plugin in "${plugins[@]}"; do
  echo ">> Installing $plugin"
  echo "via: "$jenkins_cli install-plugin "$plugin"
  $jenkins_cli install-plugin "$plugin"
done
echo ">> Plugins installed"

$jenkins_cli safe-restart
echo ">> Jenkins restarted"