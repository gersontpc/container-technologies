## Aula 4 - Docker Swarm

## Provisionando um Cluster Swarm na AWS

1. Acesse o Cloud9, no terminal clone o repositório da disciplina:

```shell
git clone https://github.com/gersontpc/container-technologies.git
cd container-technologies/Lab-04/infra
```

2. Logo em seguida instale o `tfenv` para utilizar o terraform

```shell
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zprofile
echo 'export PATH=$PATH:$HOME/.tfenv/bin' >> ~/.bashrc
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
```

3. Após a instalação iremos instalar a versão do terraform latest:

```shell
tfenv install latest
tfenv use latest
terraform --version
```

4. Crie o arquivo `terraform.tfvars` para passar o valor das variáveis obrigatórias

no conteúdo do arquivo, adicione o VPC ID:

```tfvars
vpc_id = "vpc-07c02b093d5189367"
```

5. após realizar o vpc iremos executar o comando `terraform init` para baixar os plugins.

Na sequência execute `terraform plan` e `terraform apply --auto-approve`

Output:
```shell
...
aws_security_group.swarm: Creating...
aws_security_group.swarm: Creation complete after 3s [id=sg-05d21b5bc730ff8cd]
aws_instance.manager[0]: Creating...
aws_instance.nodes[0]: Creating...
aws_instance.nodes[1]: Creating...
aws_instance.manager[0]: Still creating... [10s elapsed]
aws_instance.nodes[0]: Still creating... [10s elapsed]
aws_instance.nodes[1]: Still creating... [10s elapsed]
aws_instance.manager[0]: Still creating... [20s elapsed]
aws_instance.nodes[0]: Still creating... [20s elapsed]
aws_instance.nodes[1]: Still creating... [20s elapsed]
aws_instance.manager[0]: Still creating... [30s elapsed]
aws_instance.nodes[0]: Still creating... [30s elapsed]
aws_instance.nodes[1]: Still creating... [30s elapsed]
aws_instance.nodes[1]: Creation complete after 32s [id=i-07bc63693d93d490c]
aws_instance.manager[0]: Creation complete after 32s [id=i-0980de0e0d4587243]
aws_instance.nodes[0]: Still creating... [40s elapsed]
aws_instance.nodes[0]: Creation complete after 42s [id=i-09036eaf18c683cbb]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

mamager_public_ip = [
  [
    "172.31.24.82",
  ],
]
nodes_public_ip = [
  [
    "172.31.27.66",
    "172.31.86.208",
  ],
]
```
6. Acesse o console de EC2 Instances e terá 3 instâncias em execução `swarm-master`, `swarm-node-00` e `swarm-node-01`.


![swarm](img/swarm-01.png)

7. No outputs do terraform terá o `mamager_public_ip` e `nodes_public_ip`, copie esses IPs e cole no arquivo: `ansible/hosts`, conforme abaixo:

```ansible
[masters]
172.31.24.82

[workers]
172.31.27.66
172.31.86.208
```

8. Agora no Cloud9 iremos instalar o Ansible:

```shell
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible-core -y
```
Cheque se instalou tudo certo:

```shell
ansible-playbook --version
ansible-playbook [core 2.12.0]
```

9. Configurando a private key no `Cloud9`
No console do laboratório, clique na aba `Details` e em `Show`:

![swarm](img/swarm-02.png)

10. Em SSH Key, clique no botão `Show`

![swarm](img/swarm-03.png)

11. Copie a Private Key

![swarm](img/swarm-04.png)

10. No `Cloud9` acesse o terminal utilizando o vim e cole a chave

```shell
vim ~/.ssh/id_rsa
```
Pressione `i` de Insert, cole a chave

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAl7kmA4i2jSqslZNY4ZIKysh7JIsqLYct1FKxj6t1LZwd0sYl
A56T+aOzUe46ilvGeCtI/isqCuZreGlq+AxH8vTwF58wA0VBgEcNS0sVkAfoKcrD
X0efddXRG4dQvTkQaw1XOknQpSG67r8WfvD6lhMC/BagUaX1ojAxZKL98xfHJS4V
+Uo0VulKKCWQi97TwIffV3PWfAqNgTVx2ebQ53II0GRJQEbDLv1R9DQJWhFZhew/
qgYasBRHHolDeqR5cMzL0FEdkPgPBOx/yknsHLTMU13WWFse34SxEFh5JpHhhWG0
eUgBW2iAUPXrqkHtgQmbm5j5tG2e1orGgJkgswIDAQABAoIBAE5yR2paXHC+2L75
kWIH3Zadc7YgUi16EEMQgogTEaIEbxMUqfymGEJh1oyNDS2OaB6n2rS34qQCIRz/
/HPF/clrxVuhTfTS8Rv/IKuGZd6zh+Fb2gpAgP0vEVAXdbJwd8GyAyC7G6rVts5M
dLgrppTDva5TkI7GrSsvmco7z+vI2qmxFQgCzhTxvYJbxnkFOzXqxNzWGjBqCkGr
NYZhxSjHu7hi3risQ4IY1l3ejsHhh+lazfqX92EOebD1PKXLXA7fvfoN9mNQYKgD
xhQnNSF5KzODfIs2wQBBkNq9Mg4bD1Tpu9qxq0m5g8XTEJlg1InPIMtLgNxQCJjU
WX5NmCECgYEAyoHiYDOfH093cXCDeh6A8tW40ALpBFJvsvFOrugSqU+L+wGO02nO
cluouhMT+EypapXhP/j6pvHAsy8rVTUdQwb2pyahy0VeJSmjkhbqiPu7nptPpci+
pqUAFWmhvne1RSRKqr8Jq4q//054Re6BUUg+CHI6fCv9vtR/tzMdzMMCgYEAv80Z
azJFq9Ae/OHXMVbsU2GiK4F08QsWsn4mulmllt3EjSsseFOp1k+8Riy2mDUXDSxq
tcsf+Lu8eRD40W0vI0wvTOy+QRke5143e7/rU2ENY/0aRQeW4Jmw8JEVYw7sGlAs
hq0EstI/CllQTo2mE+zqaN+OCkaalXyhZrGN3VECgYEAhglmPuqsHdtJYcppG8Fo
9FJF21ixxuyRhk12GQr+nxZJvsAPOxvDS6ojidXq1+RWFnhR+TfhH/LP60oDUoiv
b5gCViyZ1qN5ZvuiiqWkYzrLunVuSHsQxdhcr8+VAS7Wyob07QM5cVOLNX9I2HC/
I3+/n3OMBnhPoamhRy8MQGUCgYA2Y1qJ4z+OcP3Yh9IV06hAHLd3zsXydEqDYvJo
dXNXTJunzE5X8KGAfCvPWm6MysE2oxm/Y1I1nkbbrcxg1q0/PSNMlPV+UDlLMpRZ
Kxr4EdVSPTttx7EpD2v1S67c4CZjb8iwh++FJclqjdkP7Wriy5PNGVeV4l+DdEvw
avjngQKBgQCPC5kO3JKZGQuC0gcENkilZYw2Rsr1h7oE20qppU7HmpvjFwsg/Uv4
ytLt7PbCqlHQiHciSzo7oI7noupoiiq0/SjRNQGezFgpUPICQLNouRi+tMhcbRMy
Nxro55/2tDvnFo868MryxC1Dtpbbm7aztXueRVzE+sYx4mlOQfQhZA==
-----END RSA PRIVATE KEY-----
```

11. Salve o arquivo e saia, digitando: `ESC` + `wq`

Exporte a variável de ambiente para não pedir checagem da Key:
```
export ANSIBLE_HOST_KEY_CHECKING=false
```

12. Agora iremos executar o Ansible para configurar nosso Cluster Docker Swarm

Entre no diretório do ansible:

```shell
cd ../ansible/
```

Execute o `ansible-playbook` para configurar o Cluster.

```shell
ansible-playbook -i hosts playbook.yml
```
Output:
```
PLAY [Init Swarm Master] *************************************************************************************************************************************************************************************

TASK [Swarm Init] ********************************************************************************************************************************************************************************************
changed: [172.31.24.82]

TASK [Get Worker Token] **************************************************************************************************************************************************************************************
changed: [172.31.24.82]

TASK [Show Worker Token] *************************************************************************************************************************************************************************************
ok: [172.31.24.82] => {
    "worker_token.stdout": "SWMTKN-1-5shuvkz3p2muss18wez1cjnaaud152o838z0sjkl0vj5nky3ci-1bi7x6oizgg5gbwxyw92kzzo9"
}

TASK [Master Token] ******************************************************************************************************************************************************************************************
changed: [172.31.24.82]

TASK [Show Master Token] *************************************************************************************************************************************************************************************
ok: [172.31.24.82] => {
    "master_token.stdout": "SWMTKN-1-5shuvkz3p2muss18wez1cjnaaud152o838z0sjkl0vj5nky3ci-ennc8sxtyfzvducu0jopo9nfs"
}

PLAY [Join Swarm Cluster] ************************************************************************************************************************************************************************************

TASK [Join Swarm Cluster as a Worker] ************************************************************************************************************************************************************************
changed: [172.31.86.208]
changed: [172.31.27.66]

TASK [Show Results] ******************************************************************************************************************************************************************************************
ok: [172.31.27.66] => {
    "worker.stdout": "This node joined a swarm as a worker."
}
ok: [172.31.86.208] => {
    "worker.stdout": "This node joined a swarm as a worker."
}

TASK [Show Errors] *******************************************************************************************************************************************************************************************
ok: [172.31.27.66] => {
    "worker.stderr": ""
}
ok: [172.31.86.208] => {
    "worker.stderr": ""
}

PLAY RECAP ***************************************************************************************************************************************************************************************************
172.31.24.82               : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
172.31.27.66               : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
172.31.86.208              : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

13. Conectando no Manager do Swarm

```shell
ssh 172.31.24.82
```

14. Listando os nós do cluster

```shell
docker node ls
ID                            HOSTNAME           STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
jhqrikifs8iv7pybzsoywb905 *   ip-172-31-24-82    Ready     Active         Leader           26.0.1
ufokvxs98uope1yion0rek4mv     ip-172-31-27-66    Ready     Active                          26.0.1
wuy3t64bt1ntd35kwybbiuzux     ip-172-31-86-208   Ready     Active                          26.0.1
```
15. Fazendo o deploy do `Portainer` para conseguir visualizar o ambiente atrevés de UI.


```compose
version: '3.2'

services:
  agent:
    image: portainer/agent:2.19.4
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
    networks:
      - agent_network
    deploy:
      mode: global
      placement:
        constraints: [node.platform.os == linux]

  portainer:
    image: portainer/portainer-ce:2.19.4
    command: -H tcp://tasks.agent:9001 --tlsskipverify
    ports:
      - "9443:9443"
      - "9000:9000"
      - "8000:8000"
    volumes:
      - portainer_data:/data
    networks:
      - agent_network
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: [node.role == manager]

networks:
  agent_network:
    driver: overlay
    attachable: true

volumes:
  portainer_data:
```

```shell
docker stack deploy -c portainer-agent-stack.yml portainer
```