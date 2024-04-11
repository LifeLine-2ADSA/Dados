-- drop database lifeline;
CREATE DATABASE lifeline;
USE lifeline;

-- Criando tabelas 
CREATE TABLE empresa (
	idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    cnpj CHAR(14),
    logradouro VARCHAR(100),
    email VARCHAR(45),
    telefone CHAR(11),
    matriz INT,
    CONSTRAINT fkEmpresaWEmpresa FOREIGN KEY (matriz) REFERENCES empresa(idEmpresa)
)auto_increment = 100;

CREATE TABLE usuario(
		idUsuario INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(45),
        endereco VARCHAR(100),
        telefone CHAR(11),
        cargo VARCHAR(45),
        senha VARCHAR(45),
        email VARCHAR (45),
        cpf CHAR(11),
        fkEmpresa INT,
        CONSTRAINT fkEmpresaWUser FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE maquina(
	idMaquina INT AUTO_INCREMENT PRIMARY KEY,
    ip VARCHAR(20),
    sistemaOperacional VARCHAR(45),
    limiteCpu DOUBLE,
    limiteRam DOUBLE,
    limiteDisco DOUBLE,
    qtdDispositivosConectados INT
)auto_increment = 500;

CREATE TABLE usuario_maquina(
	idUsuarioMaquina INT AUTO_INCREMENT,
    fkMaquina INT,
    fkUsuario INT,
    nomeMaquina VARCHAR(45),
    CONSTRAINT fkMaquinaWUsuario FOREIGN KEY (fkMaquina) references maquina(idMaquina),
    CONSTRAINT fkUsuarioWMaquina FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario),
    PRIMARY KEY(idUsuarioMaquina, fkMaquina, fkUsuario)
) auto_increment = 200;

CREATE TABLE postagem (
	idPostagem INT AUTO_INCREMENT,
    titulo VARCHAR(45),
    conteudo VARCHAR(1000), 
    tag VARCHAR(45),
    fkUsuario INT,
    fkMaquina INT,
    CONSTRAINT fkMaquinaWPostagem FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
    CONSTRAINT fkPostagemWUser FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario),
    PRIMARY KEY (idPostagem, fkUsuario)
)auto_increment=300;

CREATE TABLE registro(
	idRegistro INT AUTO_INCREMENT,
    dataHora DATETIME,
    fkMaquina INT,
    consumoDisco DOUBLE,
    consumoRam DOUBLE,
    consumoCpu DOUBLE,
    totalDispositivosConectados INT,
    CONSTRAINT fkMaquinaWRegistro FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
    PRIMARY KEY(idRegistro, fkMaquina)
) auto_increment=400;

/*
CREATE TABLE alerta(
	idAlerta INT AUTO_INCREMENT,
);
*/

show tables;

-- Inserindo dados mokados nas tabelas
INSERT INTO empresa (nome, cnpj, logradouro, email, telefone, matriz) VALUES 
('Tech Innovations', '12345678901234', 'Rua dos Inventores, 100', 'contato@techinnovations.com', '11987654321', NULL),
('Soluções Inteligentes', '23456789012345', 'Av. dos Pioneiros, 250', 'suporte@solucoesint.com', '21987654321', 100),
('Dev Dreams', '34567890123456', 'Rua da Tecnologia, 400', 'info@devdreams.com', '31987654321', 100),
('Web Creators', '45678901234567', 'Alameda dos Desenvolvedores, 550', 'contact@webcreators.com', '41987654321', NULL),
('Data Science Corp', '56789012345678', 'Via dos Analistas, 700', 'support@datasciencecorp.com', '51987654321', 103);

INSERT INTO maquina (ip, sistemaOperacional, limiteCpu, limiteRam, limiteDisco, qtdDispositivosConectados) VALUES 
('192.168.1.1', 'Windows Server 2019', 2.3, 8.0, 500.0, 10),
('10.20.30.40', 'Ubuntu 20.04', 3.5, 16.0, 1024.0, 20),
('172.16.0.1', 'Red Hat Enterprise Linux 8', 2.9, 32.0, 2048.0, 30),
('192.168.2.1', 'Windows 10 Pro', 3.7, 64.0, 256.0, 5),
('10.0.0.1', 'Debian 10', 2.5, 4.0, 512.0, 15);

INSERT INTO usuario (nome, endereco, telefone, cargo, senha, email, cpf, fkEmpresa) VALUES 
('João Silva', 'Rua dos Usuários, 123', '11912345678', 'Profissional da saúde', 'senha123', 'joao@techinnovations.com', '12345678901', 100),
('Maria Oliveira', 'Av. dos Testadores, 456', '21987654321', 'Profissional de TI', 'senha456', 'maria@solucoesint.com', '23456789012', 100),
('Carlos Pereira', 'Alameda dos Programadores, 789', '31987654321', 'Profissional de TI', 'senha789', 'carlos@devdreams.com', '34567890123', 102),
('Ana Costa', 'Rua da Inovação, 101', '41987654321', 'Profissional da saúde', 'senha012', 'ana@webcreators.com', '45678901234', 102),
('Roberto Nascimento', 'Av. dos Desenvolvedores, 202', '51987654321', 'Profissional da saúde', 'senha345', 'roberto@datasciencecorp.com', '56789012345', NULL);

INSERT INTO usuario_maquina (fkMaquina, fkUsuario, nomeMaquina) VALUES 
(500, 1, 'Maquina-Joao'),
(501, 2, 'Maquina-Maria'),
(502, 3, 'Maquina-Carlos'),
(503, 4, 'Maquina-Ana'),
(504, 5, 'Maquina-Roberto');


INSERT INTO postagem (titulo, conteudo, tag, fkUsuario, fkMaquina) VALUES 
('Nova Tecnologia', 'Conteúdo sobre nova tecnologia...', 'RAM', 1, 500),
('Inovação no Mercado', 'Analisando a inovação no mercado atual...', 'RAM', 2, 501),
('Segurança da Informação', 'Importância da segurança da informação...', 'CPU', 3, 502),
('Big Data no dia a dia', 'Como o Big Data afeta nosso dia a dia...', 'DISCO', 4, 503),
('Inteligência Artificial', 'O futuro da IA...', 'CPU', 5, 504);


INSERT INTO registro (dataHora, fkMaquina, consumoDisco, consumoRam, consumoCpu, totalDispositivosConectados) VALUES 
('2024-04-11 10:00:00', 500, 120.0, 2.5, 1.2, 8),
('2024-04-11 11:00:00', 501, 256.0, 4.0, 1.8, 16),
('2024-04-11 12:00:00', 502, 512.0, 8.0, 2.5, 24),
('2024-04-11 13:00:00', 503, 128.0, 3.2, 1.4, 4),
('2024-04-11 14:00:00', 504, 1024.0, 16.0, 3.0, 12);


-- Consultando dados
-- Consulta para visualizar usuários e suas respectivas empresas
SELECT u.idUsuario, u.nome AS NomeUsuario, u.email, e.nome AS NomeEmpresa, e.email AS EmailEmpresa
FROM usuario u
LEFT JOIN empresa e ON u.fkEmpresa = e.idEmpresa;

-- Consulta para visualizar máquinas e informações do usuário associado
SELECT m.idMaquina, m.ip, m.sistemaOperacional, um.nomeMaquina, u.nome AS NomeUsuario, u.cargo
FROM maquina m
JOIN usuario_maquina um ON m.idMaquina = um.fkMaquina
JOIN usuario u ON um.fkUsuario = u.idUsuario;

-- Consulta para visualizar postagens, autores e máquinas
SELECT p.titulo, p.conteudo, p.tag, u.nome AS Autor, m.*
FROM postagem p
JOIN usuario u ON p.fkUsuario = u.idUsuario
JOIN maquina m ON p.fkMaquina = m.idMaquina;

-- Consulta para visualizar o registro de uso de uma máquina
SELECT m.idMaquina, m.ip, r.dataHora, r.consumoCpu, r.consumoRam, r.consumoDisco, r.totalDispositivosConectados
FROM registro r
JOIN maquina m ON r.fkMaquina = m.idMaquina;

-- Consulta para visualizar empresas e suas matrizes
SELECT e1.nome AS Empresa, e2.nome AS Matriz
FROM empresa e1
LEFT JOIN empresa e2 ON e1.matriz = e2.idEmpresa;
