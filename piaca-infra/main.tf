# ============================================================
# PROVIDER
# Define qual cloud será usada e em qual região.
# us-east-1 = Norte da Virgínia (mais barata e com mais serviços)
# ============================================================
provider "aws" {
  region = "us-east-1"
}

# ============================================================
# KEY PAIR
# Registra sua chave pública SSH na AWS para poder conectar
# na instância via: ssh -i ~/.ssh/id_ed25519 ec2-user@<IP>
# O arquivo .pub nunca expõe sua chave privada.
# ============================================================
resource "aws_key_pair" "key" {
  key_name   = "piaca-key"
  public_key = file("C:/Users/estev/.ssh/id_ed25519.pub")
}

# ============================================================
# SECURITY GROUP
# Funciona como um firewall virtual da instância.
# Define quais portas aceitam tráfego de entrada (ingress)
# e saída (egress).
# ============================================================
resource "aws_security_group" "sg" {
  name = "piaca-sg"

  # Permite tráfego HTTP (porta 80) de qualquer IP.
  # Necessário para o Traefik receber requisições da internet.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite SSH (porta 22) SOMENTE do seu IP pessoal.
  # Isso evita ataques de força bruta de bots na internet.
  # Troque pelo seu IP atual se ele mudar (IP dinâmico).
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["189.6.248.124/32"]
  }

  # Permite TODO tráfego de saída (downloads, git clone, etc).
  # protocol "-1" significa qualquer protocolo.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ============================================================
# EC2 INSTANCE
# A máquina virtual que vai rodar sua aplicação.
# ============================================================
resource "aws_instance" "ec2" {
  # AMI = imagem do sistema operacional.
  # ami-0c02fb55956c7d316 = Amazon Linux 2 (us-east-1).
  # ATENÇÃO: AMIs são regionais, essa só funciona em us-east-1.
  ami = "ami-0c02fb55956c7d316"

  # t3.micro = 2 vCPUs + 1GB RAM. Elegível ao free tier.
  instance_type = "t3.micro"

  # Associa o key pair criado acima para acesso SSH.
  key_name = aws_key_pair.key.key_name

  # Garante que a instância receba um IP público para ser
  # acessível pela internet.
  associate_public_ip_address = true

  # Associa o security group criado acima à instância.
  vpc_security_group_ids = [aws_security_group.sg.id]

  # ----------------------------------------------------------
  # USER DATA
  # Script bash executado automaticamente como root na
  # primeira inicialização da instância. Roda UMA única vez.
  # Para re-executar, é necessário destruir e recriar a EC2.
  # Logs disponíveis em: /var/log/cloud-init-output.log
  # ----------------------------------------------------------
  user_data = <<EOF
#!/bin/bash

# Atualiza todos os pacotes do sistema operacional.
yum update -y

# Instala o Docker via amazon-linux-extras.
# IMPORTANTE: No Amazon Linux 2, "yum install docker" NÃO
# funciona corretamente. O comando correto é esse abaixo.
amazon-linux-extras install docker -y

# Inicia o serviço Docker imediatamente.
systemctl start docker

# Habilita o Docker para iniciar automaticamente após reboot.
systemctl enable docker

# Adiciona o usuário padrão "ec2-user" ao grupo "docker".
# Isso permite rodar "docker" sem precisar de "sudo".
# OBS: só tem efeito em novos logins SSH, não na sessão atual.
usermod -aG docker ec2-user

# Instala o Docker Compose v2 como binário standalone.
curl -L https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose

# Torna o binário executável.
chmod +x /usr/local/bin/docker-compose

# Cria um symlink em /usr/bin para garantir que o comando
# fique disponível no PATH de todos os usuários.
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Instala o Git para clonar o repositório.
yum install -y git

# Entra no diretório home do ec2-user.
cd /home/ec2-user

# Clona o repositório do projeto na pasta "app".
git clone https://github.com/estevamcabral/PIACA.git app

# Entra na pasta clonada.
cd app

# Sobe todos os containers definidos no docker-compose.yml.
# -d = modo detached (roda em background, não bloqueia o boot).
# Roda como root aqui, então não precisa do grupo docker.
docker-compose up -d
EOF

  tags = {
    Name = "piaca-test"
  }
}

# ============================================================
# OUTPUT
# Exibe o IP público da instância no terminal após o apply.
# Use esse IP para acessar a aplicação no navegador
# ou conectar via SSH.
# ============================================================
output "ip" {
  value = aws_instance.ec2.public_ip
}
