# Use an official ubuntu image as a parent image
FROM ubuntu:18.04

# Set the working directory to /deploy
WORKDIR /deploy

# Copy the current directory contents into the container at /deploy
COPY . /deploy/

# Install required ubuntu packages
RUN apt-get update && \
    apt-get install -y gnupg curl wget unzip gcc g++ make && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash && \
    apt-get install -y nodejs && \
    npm install npm@latest -g

# Install hasicorp packer and terraform
RUN wget https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_linux_amd64.zip && \
    unzip packer_1.3.3_linux_amd64.zip && \
    mv packer /usr/local/bin/ && \
    rm packer_1.3.3_linux_amd64.zip && \
    wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip && \
    unzip terraform_0.11.11_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_0.11.11_linux_amd64.zip

# Test
CMD packer --version && terraform --version && node --version
