import axios from 'axios';

async function ec2MetaData() {
    const url = 'http://169.254.169.254/latest/meta-data';

    const instanceId = (await axios.get(`${url}/instance-id`)).data;
    const mac = (await axios.get(`${url}/mac`)).data;
    const ip = (await axios.get(`${url}/public-ipv4`)).data;
    const hostname = (await axios.get(`${url}/hostname`)).data;

    const vpcId = (await axios.get(`${url}/network/interfaces/macs/${mac}/vpc-id`)).data;
    const vpcBlock = (await axios.get(`${url}/network/interfaces/macs/${mac}/vpc-ipv4-cidr-block`)).data;
    const subnetId = (await axios.get(`${url}/network/interfaces/macs/${mac}/subnet-id`)).data;
    const subnetBlock = (await axios.get(`${url}/network/interfaces/macs/${mac}/subnet-ipv4-cidr-block`)).data;

    return {
        instanceId,
        mac,
        ip,
        hostname,

        vpc: {
            vpcId,
            vpcBlock,
            subnetId,
            subnetBlock
        }
    };
}

export {
    ec2MetaData
};