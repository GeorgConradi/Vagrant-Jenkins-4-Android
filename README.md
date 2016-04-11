# Vagrant-Jenkins-4-Android
Vagrant recipe to set up a Jenkins box for continuous integration of Android projects

1. Download and install latest Vagrant version
2. Install the your desired Vagrant provider
3. run `vagrant up`

Known issues:

1. During initial setup several warnings or errors may occur regarding jenkins-cli being not available
  * This will result in Plugin Updates and some Plugins itself not being installed
  * run `vagrant provision` 1-2 times and errors should disappear and updates as well as the additional plugins itself should be installed
