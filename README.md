# octo-docker
Docker environment for working with data analysis

To run the environment pull from dockerhub

docker pull paulb79/octo-jdk-scala-python3

The environment is designed for laptops to provide a local capability to perform data analytics in a secure and self contained environment which is identical between devices and users. 

Tools included: 
* Python3
* Scala
* SBT
* git
* Java 8


docker run -it --name devtest -v ~/dev/bdec/test-data/allen-p/test:/opt/octo paulb79/octo-jdk-scala-python3:latest /bin/bash