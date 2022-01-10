#!/usr/bin/env bash

echo -e "\n\n\nWaiting for instance to be ready ...\n\n\n"
sleep 60

while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo -e "Waiting...";
    sleep 5;
done;

cd $HOME

echo -e "\n\n\nUpdate software ...\n\n\n"
sudo apt-get update && sudo apt-get upgrade -y

echo -e "\n\n\nInstall node.js ...\n\n\n"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs gcc g++ make
sudo npm install npm@latest -g
sudo npm install pm2@latest -g

echo -e "\n\n\nSet environment variables ...\n\n\n"
touch ntier.sh
if ! [[ -z "$NTIER_API_URL" ]]; then
cat << EOF >> ntier.sh
export NTIER_API_URL=${NTIER_API_URL}
EOF
fi
if ! [[ -z "$NTIER_DB_HOST" ]]; then
cat << EOF >> ntier.sh
export NTIER_DB_HOST=${NTIER_DB_HOST}
export NTIER_DB_SCHEMA=${NTIER_DB_SCHEMA}
export NTIER_DB_USERNAME=${NTIER_DB_USERNAME}
export NTIER_DB_PASSWORD=${NTIER_DB_PASSWORD}
EOF
fi
sudo chmod +x ntier.sh
sudo mv ntier.sh /etc/profile.d/

echo -e "\n\n\nInstalling and running application ...\n\n\n"
echo $APP_NAME
cd $APP_NAME
npm install
npm run build
pm2 start process.yml
pm2 save
cd ../

echo -e "\n\n\nEnable our application on startup ...\n\n\n"
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup ubuntu -u ubuntu --hp /home/ubuntu
