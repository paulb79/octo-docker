# Data Science Python Environment in Docker
Docker environment for working with data analysis

To run the environment pull from hub.docker.com

docker pull paulb79/anaconda

The environment is designed for laptops to provide a local capability to perform data analytics in a secure and self contained environment which is identical between devices and users. 

In order to keep the size of the image down but offer a familiar environment this build provides anaconda with support for Python 3.6 (default) and Python 2.7. 

Tools included: 
* Python 3 & Python 2
* Stanford Named Entity Recogniser
* Java-jdk

## To Run
Running the docker file in a useful way requires the mount of volumes. The volumes anticipated for this task include: 
1. Data volume contiaining the data you wish to work with
2. Source code volume containing the code you wish to run
3. Output volume to write data output to 

The result is a rather complex looking command however if you cut-copy-paste it should do what you need. 

NB: Please remember to edit DIRECTORY_OF_DATA, SOURCECODE & RESULTS as you require. 

docker run -i -t -v ~/DIRECTORY_OF_DATA:/opt/datasource -v ~/SOURCECODE:/opt/wip -v ~/RESULTS:/opt/results -p 8888:8888 paulb79/ananconda /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root"


If the command is succesful you'll see a url which has a long strong of characters appended to this, copy this entire string and paste it into your browser to access Jupyter notebooks. 