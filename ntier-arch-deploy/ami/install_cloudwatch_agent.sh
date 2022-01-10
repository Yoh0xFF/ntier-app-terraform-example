#!/usr/bin/env bash

cd $HOME

echo -e "\n\n\nInstalling aws cloud watch agent ...\n\n\n"
sudo apt-get install -y wget
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb


echo -e "\n\n\nConfiguring aws cloud watch agent ...\n\n\n"
cat << EOF > cloudwatch_agent_config.json
{
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/home/ubuntu/.pm2/logs/$APP_NAME-error-*.log",
                        "log_group_name": "$APP_NAME",
                        "log_stream_name": "error"
                    },
                    {
                        "file_path": "/home/ubuntu/.pm2/logs/$APP_NAME-out-*.log",
                        "log_group_name": "$APP_NAME",
                        "log_stream_name": "console"
                    }
                ]
            }
        }
    }
}
EOF
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 \
    -c file:$HOME/cloudwatch_agent_config.json -s
sudo systemctl enable amazon-cloudwatch-agent.service
sudo systemctl start amazon-cloudwatch-agent.service
