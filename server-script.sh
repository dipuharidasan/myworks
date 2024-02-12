sudo yum  install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install maven -y
if [ -d "addressbook" ]
then 
  echo "repo is cloned and exists"
  cd /home/ec2-user/myworks
  git pull origin main
else
  echo "repo is not there"
 git clone https://github.com/dipuharidasan/myworks.git
 cd /home/ec2-user/myworks
fi
 mvn package
 sudo yum install docker -y
 sudo systemctl start docker
