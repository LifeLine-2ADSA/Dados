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
        CONSTRAINT fkEmpresaWUser FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa),
        CONSTRAINT ckCargo CHECK (cargo IN('TI', 'Saúde'))
);

CREATE TABLE maquina(
	idMaquina INT AUTO_INCREMENT PRIMARY KEY,
    nomeMaquina VARCHAR(30),
    ip VARCHAR(20),
	macAddress VARCHAR(20),
    sistemaOperacional VARCHAR(45),
    maxCpu DOUBLE,
	maxRam DOUBLE,
    maxDisco DOUBLE,
    maxDispositivos INT,
    fkUsuario INT,
    CONSTRAINT fkMU FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario)
)auto_increment = 500;

CREATE TABLE postagem (
	idPostagem INT AUTO_INCREMENT,
    titulo VARCHAR(45),
    conteudo VARCHAR(1000), 
    tag VARCHAR(45),
    fkUsuario INT,
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
    consumoDispositivos INT,
    CONSTRAINT fkMaquinaWRegistro FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
    PRIMARY KEY(idRegistro, fkMaquina)
) auto_increment=400;

CREATE TABLE limitador(
	idLimitador INT AUTO_INCREMENT,
    fkMaquina INT,
    CONSTRAINT fkML FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
    limiteCpu DOUBLE,
	limiteRam DOUBLE,
    limiteDisco DOUBLE,
	limiteDispositivos INT,
    PRIMARY KEY(idLimitador,fkMaquina)
);

CREATE TABLE alerta(
	idAlerta INT AUTO_INCREMENT,
    dataAlerta DATETIME,
    fkRegistro INT,
    CONSTRAINT fkRegistroWAlerta FOREIGN KEY (fkRegistro) REFERENCES registro(idRegistro),
    PRIMARY KEY(idAlerta,fkRegistro)
)auto_increment=700;


show tables;

-- Criação de trigger para tabela alerta
/*
DELIMITER $$

CREATE TRIGGER trg_check_limits
AFTER INSERT ON registro
FOR EACH ROW
BEGIN
    -- Declara variáveis para armazenar os limites
    DECLARE v_limiteCpu DOUBLE DEFAULT 0;
    DECLARE v_limiteRam DOUBLE DEFAULT 0;
    DECLARE v_limiteDisco DOUBLE DEFAULT 0;
    DECLARE v_limiteDispositivos INT DEFAULT 0;
    DECLARE v_hasLimit BOOLEAN DEFAULT FALSE;

    -- Tenta recuperar os limites da tabela limitador para a máquina correspondente
    SELECT limiteCpu, limiteRam, limiteDisco, limiteDispositivos INTO v_limiteCpu, v_limiteRam, v_limiteDisco, v_limiteDispositivos
    FROM limitador
    WHERE fkMaquina = NEW.fkMaquina;

    -- Define v_hasLimit se algum limite foi efetivamente recuperado
    SET v_hasLimit = (v_limiteCpu IS NOT NULL AND v_limiteRam IS NOT NULL AND v_limiteDisco IS NOT NULL AND v_limiteDispositivos IS NOT NULL);

    -- Verifica se algum limite foi ultrapassado e insere um alerta se necessário
    IF v_hasLimit AND (NEW.consumoCpu > v_limiteCpu OR NEW.consumoRam > v_limiteRam OR NEW.consumoDisco > v_limiteDisco OR NEW.consumoDispositivos > v_limiteDispositivos) THEN
        INSERT INTO alerta(dataAlerta, fkRegistro)
        VALUES(NOW(), NEW.idRegistro);
    END IF;
END$$

DELIMITER ;
*/


-- Inserindo dados mokados nas tabelas
INSERT INTO empresa (nome, cnpj, logradouro, email, telefone, matriz) VALUES 
('Tech Innovations', '12345678901234', 'Rua dos Inventores, 100', 'contato@techinnovations.com', '11987654321', NULL),
('Soluções Inteligentes', '23456789012345', 'Av. dos Pioneiros, 250', 'suporte@solucoesint.com', '21987654321', 100),
('Dev Dreams', '34567890123456', 'Rua da Tecnologia, 400', 'info@devdreams.com', '31987654321', 100),
('Web Creators', '45678901234567', 'Alameda dos Desenvolvedores, 550', 'contact@webcreators.com', '41987654321', NULL),
('Data Science Corp', '56789012345678', 'Via dos Analistas, 700', 'support@datasciencecorp.com', '51987654321', 103);

INSERT INTO usuario (nome, endereco, telefone, cargo, senha, email, cpf, fkEmpresa) VALUES 
('João Silva', 'Rua dos Usuários, 123', '11912345678', 'Saúde', 'senha123', 'joao@techinnovations.com', '12345678901', 100),
('Maria Oliveira', 'Av. dos Testadores, 456', '21987654321', 'TI', 'senha456', 'maria@solucoesint.com', '23456789012', 100),
('Carlos Pereira', 'Alameda dos Programadores, 789', '31987654321', 'TI', 'senha789', 'carlos@devdreams.com', '34567890123', 102),
('Ana Costa', 'Rua da Inovação, 101', '41987654321', 'Saúde', 'senha012', 'ana@webcreators.com', '45678901234', 102),
('Roberto Nascimento', 'Av. dos Desenvolvedores, 202', '51987654321', 'Saúde', 'senha345', 'roberto@datasciencecorp.com', '56789012345', NULL);

INSERT INTO maquina (nomeMaquina, ip, macAddress, sistemaOperacional, maxCpu, maxRam, maxDisco, maxDispositivos, fkUsuario) VALUES 
('PC-Joao', '192.168.1.1','bc:19:8e:84:21:78', 'Windows Server 2019', 2.3, 8.0, 500.0, 10, 1),
('Pc Casa', '10.20.30.40','ac:19:8e:84:21:71', 'Ubuntu 20.04', 3.5, 16.0, 1024.0, 20, 2),
('Notebook Empresa', '172.16.0.1','dc:19:8e:84:71:78', 'Red Hat Enterprise Linux 8', 2.9, 32.0, 2048.0, 30, 3),
('Notebook Casa', '192.168.2.1','ab:19:8e:84:21:78', 'Windows 10 Pro', 3.7, 64.0, 256.0, 5, 4),
('Notebook Casa', '10.0.0.1','ay:19:8e:84:21:78', 'Debian 10', 2.5, 4.0, 512.0, 15, 5);


INSERT INTO postagem (titulo, conteudo, tag, fkUsuario) VALUES 
('Nova Tecnologia', 'Conteúdo sobre nova tecnologia...', 'RAM', 1),
('Inovação no Mercado', 'Analisando a inovação no mercado atual...', 'RAM', 2),
('Segurança da Informação', 'Importância da segurança da informação...', 'CPU', 3),
('Big Data no dia a dia', 'Como o Big Data afeta nosso dia a dia...', 'DISCO', 4),
('Inteligência Artificial', 'O futuro da IA...', 'CPU', 5);


INSERT INTO registro (dataHora, fkMaquina, consumoDisco, consumoRam, consumoCpu, consumoDispositivos) VALUES 
('2024-04-11 10:00:00', 500, 120.0, 2.5, 1.2, 5),
('2024-04-11 11:00:00', 501, 256.0, 4.0, 1.8, 16),
('2024-04-11 12:00:00', 502, 512.0, 8.0, 1.5, 4),
('2024-04-11 13:00:00', 503, 128.0, 3.2, 1.4, 0),
('2024-04-11 14:00:00', 504, 1024.0, 16.0, 3.0, 12);


-- INSERT INTO limitador (fkMaquina, limiteCpu, limiteRam, limiteDisco, limiteDispositivos)
SELECT 
    idMaquina,
    maxCpu * 0.8,  -- Reduzindo o limite de CPU em 20%
    maxRam * 0.8,  -- Reduzindo o limite de RAM em 20%
    maxDisco * 0.8,  -- Reduzindo o limite de disco em 20%
    FLOOR(maxDispositivos * 0.8)  -- Reduzindo o número de dispositivos em 20% e arredondando para baixo
FROM maquina;


-- Consultando dados
-- Consulta para visualizar usuários e suas respectivas empresas
SELECT u.idUsuario, u.nome AS NomeUsuario, u.email, e.nome AS NomeEmpresa, e.email AS EmailEmpresa
FROM usuario u
LEFT JOIN empresa e ON u.fkEmpresa = e.idEmpresa;

-- Consulta para visualizar máquinas e informações do usuário associado
SELECT m.idMaquina,m.macAddress , m.ip, m.sistemaOperacional, m.nomeMaquina, u.nome AS NomeUsuario, u.cargo
FROM maquina m
JOIN usuario u ON m.fkUsuario = u.idUsuario;

-- Consulta para visualizar postagens, autores e máquinas
SELECT p.titulo, p.conteudo, p.tag, u.nome AS Autor
FROM postagem p
JOIN usuario u ON p.fkUsuario = u.idUsuario;

-- Consulta para visualizar o registro de uso de uma máquina
SELECT m.idMaquina, m.ip, r.dataHora, r.consumoCpu, r.consumoRam, r.consumoDisco, r.consumoDispositivos
FROM registro r JOIN maquina m ON r.fkMaquina = m.idMaquina;

-- Consulta para visualizar empresas e suas matrizes
SELECT e1.nome AS Empresa, e2.nome AS Matriz
FROM empresa e1
LEFT JOIN empresa e2 ON e1.matriz = e2.idEmpresa;

-- Consulta limite de cada maquina
SELECT * FROM limitador JOIN maquina ON fkMaquina = idMaquina;

SELECT * FROM alerta;
INSERT INTO maquina (nomeMaquina, fkUsuario) VALUES ("Carlos back-end", 1);

-- Inserindo dados para ultrapassar os limites e acionar o trigger
/*
INSERT INTO registro (dataHora, fkMaquina, consumoDisco, consumoRam, consumoCpu, consumoDispositivos) VALUES 
('2024-04-11 10:00:00', 500,520.0, 7.5, 1.2, 5);
select * from alerta;
*/
