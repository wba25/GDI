/*


------------------------------------------
|           Definição de tipos           |
------------------------------------------
*/
--APAGAR TIPOS
DROP TYPE tp_consultorio FORCE;
DROP TYPE tp_medico FORCE;
DROP TYPE tp_endereco FORCE;
DROP TYPE tp_fones FORCE;
DROP TYPE tp_fone FORCE;
DROP TYPE tp_paciente FORCE;
DROP TYPE tp_produto FORCE;
DROP TYPE tp_exame FORCE;
DROP TYPE tp_agenda_exame FORCE;
DROP TYPE tp_medicamento FORCE;
DROP TYPE tp_recepcionista FORCE;
DROP TYPE tp_laboratorio FORCE;
DROP TYPE tp_nt_supervisionados FORCE;
DROP TYPE tp_nt_produto FORCE;


--APAGAR TABELAS
DROP TABLE tb_medico CASCADE CONSTRAINT;
DROP TABLE tb_paciente CASCADE CONSTRAINT;
DROP TABLE tb_recepcionista CASCADE CONSTRAINT;
DROP TABLE tb_consulta CASCADE CONSTRAINT;
DROP TABLE tb_agenda_exame CASCADE CONSTRAINT;
DROP TABLE tb_laboratorio CASCADE CONSTRAINT;
DROP TABLE tb_prescreve CASCADE CONSTRAINT;
DROP TABLE tb_medicamento CASCADE CONSTRAINT;
DROP TABLE tb_exame CASCADE CONSTRAINT;
DROP TABLE tb_lista_medicos CASCADE CONSTRAINT;




-- ENDEREÇO
CREATE OR REPLACE TYPE tp_endereco AS OBJECT (
    cep number(8),    
    logradouro varchar2(200),
    numero varchar2(10),
    bairro varchar2(200),
    cidade varchar2(100),
    estado char(2)
);
/


-- TELEFONE
CREATE OR REPLACE TYPE tp_fone AS OBJECT (
    numero VARCHAR2(14)
);
/


-- ARRAY DE TELEFONES
CREATE OR REPLACE TYPE tp_fones AS VARRAY(4) OF tp_fone;
/




-- CONSULTÓRIO
CREATE OR REPLACE TYPE tp_consultorio AS OBJECT (
    --crm REF tp_medico,
    numero varchar2(10)
);
/

-- MEDICO
CREATE OR REPLACE TYPE tp_medico AS OBJECT (
    crm number(10),
    nome varchar2(200),
    fones tp_fones,
    endereco tp_endereco,
    consultorio tp_consultorio
);
/


-- NESTED TABLE para MEDICO
CREATE TYPE tp_nt_supervisionados AS TABLE OF REF tp_medico;
/


-- Atualizando MEDICO
ALTER TYPE tp_medico ADD ATTRIBUTE (superv tp_nt_supervisionados) CASCADE;


-- PRODUTO
CREATE OR REPLACE TYPE tp_produto AS OBJECT
(
   id NUMBER(3),
   nome VARCHAR2(200),
   preco NUMBER(5,2)
)
NOT FINAL;
/


-- MEDICAMENTO
CREATE OR REPLACE TYPE tp_medicamento UNDER tp_produto
(
  dose VARCHAR2(10),
  validade DATE
);
/


-- EXAME
CREATE OR REPLACE TYPE tp_exame UNDER tp_produto ();
/


CREATE TYPE tp_nt_produto AS TABLE OF REF tp_produto;
/


-- PACIENTE
CREATE OR REPLACE TYPE tp_paciente AS OBJECT (
    cpf varchar2(14),
    nome varchar2(200),
    sexo char(1), 
    data_nascimento date,
    plano_de_saude varchar2(100),
    fones tp_fones,
    endereco tp_endereco,
    produtos tp_nt_produto
);
/


--CONSULTA
CREATE OR REPLACE TYPE tp_consulta AS OBJECT (
    medico REF tp_medico,
    paciente REF tp_paciente,
    data_hora TIMESTAMP,
    descricao varchar2(300),
    diagnostico varchar2(500)
);
/


-- RECEPCIONISTA
CREATE OR REPLACE TYPE tp_recepcionista AS OBJECT (
    id number(3),
    nome varchar2(200),
    telefone tp_fones,
    endereco tp_endereco
);
/


-- LABORATORIO
CREATE OR REPLACE TYPE tp_laboratorio AS OBJECT (
   id NUMBER(3),
   nome varchar2(200),
   laboratorio_endereco tp_endereco,
   laboratorio_telefone tp_fones
);
/






-- Atualiza Produto
--ALTER TYPE tp_paciente ADD ATTRIBUTE (produto REF tp_produto) CASCADE;
--/


-- PRESCREVE
CREATE OR REPLACE TYPE tp_prescreve AS OBJECT (
   medico REF tp_medico,
   paciente REF tp_paciente,
   produto REF tp_produto,
   data_hora timestamp
);
/


-- AGENDA EXAME
CREATE OR REPLACE TYPE tp_agenda_exame AS OBJECT (
    exame REF tp_exame,
    laboratorio REF tp_laboratorio,
    recepcionista REF tp_recepcionista,
    data_hora timestamp
);
/






/*
--------------------------------------------
|           Definição de tabelas           |
--------------------------------------------
*/


-- MEDICO
CREATE TABLE tb_medico OF tp_medico (
    crm NOT NULL,
    nome NOT NULL,
    PRIMARY KEY(crm)
) NESTED TABLE superv STORE AS tb_lista_medicos;


-- PACIENTE
CREATE TABLE tb_paciente OF tp_paciente (
    cpf NOT NULL,
    nome NOT NULL,
    sexo NOT NULL, 
    data_nascimento NOT NULL,
    plano_de_saude NOT NULL,
    PRIMARY KEY (cpf)
)NESTED TABLE produtos STORE AS tb_lista_produto;


-- RECEPCIONISTA
CREATE TABLE tb_recepcionista OF tp_recepcionista (
    id PRIMARY KEY,
    nome NOT NULL
);


-- LABORATORIO
CREATE TABLE tb_laboratorio OF tp_laboratorio (
   id PRIMARY KEY,
   nome NOT NULL,
   laboratorio_endereco NOT NULL,
   laboratorio_telefone NOT NULL
);




-- MEDICAMENTO
CREATE TABLE tb_medicamento OF tp_medicamento
(
  id PRIMARY KEY,
  nome NOT NULL,
  preco NOT NULL,
  dose NOT NULL,
  validade NOT NULL
);


-- EXAME
CREATE TABLE tb_exame OF tp_exame (
    id PRIMARY KEY,
  nome NOT NULL,
  preco NOT NULL
);


-- PRESCREVE
CREATE TABLE tb_prescreve OF tp_prescreve (
   medico WITH ROWID REFERENCES tb_medico,
   paciente WITH ROWID REFERENCES tb_paciente,
   --produto WITH ROWID REFERENCES tb_produto,
   PRIMARY KEY (data_hora) -- tipo REF não pode ser PK
);




-- AGENDA EXAME
CREATE TABLE tb_agenda_exame OF tp_agenda_exame (
    exame WITH ROWID REFERENCES tb_exame NOT NULL,
    laboratorio WITH ROWID REFERENCES tb_laboratorio NOT NULL,
    recepcionista WITH ROWID REFERENCES tb_recepcionista NOT NULL,
    PRIMARY KEY (data_hora)
);


-- CONSULTA
CREATE TABLE tb_consulta OF tp_consulta (
    medico WITH ROWID REFERENCES tb_medico NOT NULL,
    paciente WITH ROWID REFERENCES tb_paciente NOT NULL,
    data_hora NOT NULL
);








/*
------------------------------------------
|               Povoamento               |
------------------------------------------
*/






-- MEDICAMENTO
INSERT INTO tb_medicamento values (1,'Levofloxacina',99.99,'250mg',TO_DATE('27/08/2022', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (2,'Ciprofloxacina',49.99,'500mg',TO_DATE('02/03/2022', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES(3,'Ciprofloxacina',69.99,'250mg',TO_DATE('12/04/2018', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (4,'Cefepima',39.99,'1g',TO_DATE('16/02/2017', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (5,'Penicilina Benzatina',5.99,'250mi Und.',TO_DATE('20/01/2016', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (6,'Ibuprofeno',14.99,'50mg/ml',TO_DATE('04/04/2015', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento values (7,'Ibuprofeno',24.99,'100mg/ml',TO_DATE('22/11/2022', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (8,'Dipirona',14.99,'500mg',TO_DATE('28/10/2022', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento values (9,'Paracetamol',44.99,'100mg',TO_DATE('28/10/2023', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (10,'Paracetamol',54.99,'250mi Und',TO_DATE('11/04/2022', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento values (11,'Tansulosina',14.99,'200mg',TO_DATE('20/07/2020', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (12,'Terazosina',24.99,'100mi Und',TO_DATE('13/08/2021', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (13,'Finasterida',3.99,'500mg',TO_DATE('10/01/2020', 'DD-MM-YYYY'));


INSERT INTO tb_medicamento VALUES (14,'Nifedipina',19.99,'1g',TO_DATE('24/01/2019', 'DD-MM-YYYY'));


-- EXAME
INSERT INTO  tb_exame VALUES (tp_exame(23,'Cintilografia Renal', 999.99));
INSERT INTO  tb_exame VALUES (tp_exame(22,'Litotripsia extracorpórea', 999.99));
INSERT INTO  tb_exame VALUES (tp_exame(21,'USG de vias urinárias', 19.99));
INSERT INTO  tb_exame VALUES (tp_exame(20,'Cultura da secreção genital', 299.99));
INSERT INTO  tb_exame VALUES (tp_exame(19,'Urocultura', 199.99));
INSERT INTO  tb_exame VALUES (tp_exame(18,'Sumário de Urina', 100.99));
INSERT INTO  tb_exame VALUES (tp_exame(17,'Hemograma', 10.99));
INSERT INTO  tb_exame VALUES (tp_exame(15,'Sorologia VDRL', 109.99));
INSERT INTO  tb_exame VALUES (tp_exame(16,'Sorologia FTA-ABS', 79.99));




-- PACIENTE
INSERT INTO tb_paciente VALUES (tp_paciente('56071103541','Rana W. Garcia','F',TO_DATE('04/03/1973', 'DD-MM-YYYY'),'Hapvida',tp_fones(tp_fone('11986718597')), tp_endereco(25698381,'Vel Avenue','7833','Diamantina','Ribeirão Preto','SP'),tp_nt_produto((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=8),
  (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=1))));
INSERT INTO tb_paciente VALUES (tp_paciente('12130599361','Cade Q. Alston','M',TO_DATE('17/11/1912', 'DD-MM-YYYY'),'Hapvida',tp_fones(tp_fone('11981338155')), tp_endereco(58051550,'Scelerisque St.','2328','Suvaco da Ovelha','Ribeirão Preto','SP'),tp_nt_produto((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=7),
(SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=3))));
INSERT INTO tb_paciente VALUES (tp_paciente('68804766912','Daquan H. Dillon','M',TO_DATE('06/01/1913', 'DD-MM-YYYY'),'Hapvida',tp_fones(tp_fone('11998446495')), tp_endereco(88700443,'Lorem Rd.','1385','Suvaco da Ovelha','Ribeirão Preto','SP'),
  tp_nt_produto ((SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=19),(SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=4))));
INSERT INTO tb_paciente VALUES (tp_paciente('76764741465','Lewis Q. Swanson','M',TO_DATE('26/06/1959', 'DD-MM-YYYY'),'Hapvida',tp_fones(tp_fone('11981106371')), tp_endereco(44980216,'Arcu Av.','2900','Diamantina','Ribeirão Preto','SP'),
tp_nt_produto ((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=5),(SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=15),(SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=16),
(SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=17),(SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=18))));
INSERT INTO tb_paciente VALUES (tp_paciente('68736002407','Herman F. Stanton','M',TO_DATE('07/01/1979', 'DD-MM-YYYY'),'Hapvida',tp_fones(tp_fone('11990233896')), tp_endereco(99130382,'Amet Av.','2854','Diamantina','Ribeirão Preto','SP'),
tp_nt_produto((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=12))));
INSERT INTO tb_paciente VALUES (tp_paciente('38007269003','Demetria M. Ellis','F',TO_DATE('11/01/1951', 'DD-MM-YYYY'),'SUS',tp_fones(tp_fone('11984023798')), tp_endereco(11883050,'Consectetuer Avenue','7515','Diamantina','Ribeirão Preto','SP'),NULL));
INSERT INTO tb_paciente VALUES (tp_paciente('32745616585','Chase U. Allen','M',TO_DATE('25/05/1942', 'DD-MM-YYYY'),'SUS',tp_fones(tp_fone('11993040635')), tp_endereco(19440992,'Vulputate, Rd.','1175','Suvaco da Ovelha','Ribeirão Preto','SP'), NULL));
INSERT INTO tb_paciente VALUES (tp_paciente('67638519969','Arthur T. Williams','M',TO_DATE('12/01/1962', 'DD-MM-YYYY'),'SUS',tp_fones(tp_fone('11987325554')), tp_endereco(48762266,'Est Avenue','9178','neguinho da beija-flor','Ribeirão Preto','SP'),
tp_nt_produto ((SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=21),(SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=22),(SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=23),
(SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=13),(SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=6))));
INSERT INTO tb_paciente VALUES (tp_paciente('43190124155','Xaviera I. Finley','F',TO_DATE('03/05/1960', 'DD-MM-YYYY'),'SUS',tp_fones(tp_fone('11994184660')), tp_endereco(47486951,'Placerat Rd.','9070','Porto de Galinhas','Cabo de Santo Agostinho','PE'),NULL));
INSERT INTO tb_paciente VALUES (tp_paciente('60516668469','Jessica V. Shaw','F',TO_DATE('27/01/1910', 'DD-MM-YYYY'),'SUS',tp_fones(tp_fone('11994292901')), tp_endereco(98464431,'P.O. Box Fringilla Rd.','552','São Luiz','Ribeirão Preto','SP'),
tp_nt_produto ((SELECT TREAT (REF(E) AS REF tp_produto) FROM tb_exame E WHERE E.ID=20))));
INSERT INTO tb_paciente VALUES (tp_paciente('76132992813','Amelo G. Calderon','M',TO_DATE('26/01/1933', 'DD-MM-YYYY'),'Unimed',tp_fones(tp_fone('11997035338')), tp_endereco(83607257,'Lectus Road','1965','São Luiz','Ribeirão Preto','SP'),NULL));
INSERT INTO tb_paciente VALUES (tp_paciente('17063339739','Branden Z. Roberson','M',TO_DATE('31/05/1990', 'DD-MM-YYYY'),'Unimed',tp_fones(tp_fone('11987598376')), tp_endereco(42050398,'Quam. Av.','9313','Capitão Guile ','Ribeirão Preto','SP'),
tp_nt_produto((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=2),(SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=14))));
INSERT INTO tb_paciente VALUES (tp_paciente('94490687865','Merrill V. Romero','F',TO_DATE('26/10/1960', 'DD-MM-YYYY'),'Unimed',tp_fones(tp_fone('11995944122')), tp_endereco(14009728,'Nec Av.','6065','Capitão Guile ','Ribeirão Preto','SP'),tp_nt_produto((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=9))));
INSERT INTO tb_paciente VALUES (tp_paciente('72006753375','Ivy T. Ware','M',TO_DATE('08/01/1966', 'DD-MM-YYYY'),'Unimed',tp_fones(tp_fone('11990244873')), tp_endereco(89884055,'Turpis Street','4214','Capitão Guile ','Ribeirão Preto','SP'),NULL));
INSERT INTO tb_paciente VALUES (tp_paciente('92623243718','Ivory I. Kennedy','M',TO_DATE('18/01/1959', 'DD-MM-YYYY'),'Unimed',tp_fones(tp_fone('11980674521')), tp_endereco(20100835,'Sed Street','4656','Suvaco da Ovelha','Ribeirão Preto','SP'),tp_nt_produto((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=10))));
INSERT INTO tb_paciente VALUES (tp_paciente('79698560587','Alexandra Q. Dunlap','M',TO_DATE('09/02/1937', 'DD-MM-YYYY'),'Unimed',tp_fones(tp_fone('11992255039')), tp_endereco(95111873,'Ac Av.','2422','Capitão Guile','Ribeirão Preto','SP'), tp_nt_produto((SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.ID=11))));




-- MEDICO
INSERT INTO tb_medico  VALUES (tp_medico(543251289,'Fatima P. Sandoval',tp_fones(tp_fone('11906883609')),tp_endereco(19862746,'Consequat St.','5517','Bubu','Carapicuíba','SP'),tp_consultorio('5'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(979052725,'Morgan U. Herrera',tp_fones(tp_fone('11983544792')),tp_endereco(19872628,'Ap A Street','7694','São Jerum','Piracicaba','SP'),tp_consultorio('6'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(269105343,'Jillian Q. Dunlap',tp_fones(tp_fone('11961959561')),tp_endereco(19783513,'Facilisis Ave','2943','Bubu','Divinópolis','RJ'),tp_consultorio('7'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(237819555,'Galena L. Noble',tp_fones(tp_fone('11919410802')),tp_endereco(19435780,'Ac St.','4636','Planeta','Campinas','CE'),tp_consultorio('8'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(107292259,'Hiram M. Valenzuela',tp_fones(tp_fone('11906581184')),tp_endereco(19696674,'Nulla St.','4017','Santa Rosa','Niterói','MG'),tp_consultorio('9'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(787894499,'Rachel O. Prince',tp_fones(tp_fone('11991285102')),tp_endereco(19812649,'Et St.','3375','São Carlos','Petrópolis','MG'),tp_consultorio('10'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(153691371,'Kuame V. Parker',tp_fones(tp_fone('11930063633')),tp_endereco(19390314,'Lacus. Rd.','4701','Vila Nova','Salvador','SP'),tp_consultorio('11'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(414422955,'Orson H. Chan',tp_fones(tp_fone('11997864600')),tp_endereco(19606164,'Quisque Street','8210','São Carlos','Osasco','MG'),tp_consultorio('12'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(990141915,'India F. Fisher',tp_fones(tp_fone('11991654388')),tp_endereco(19219572,'Aliquet. Ave','8696','Minas Garadas','Divinópolis','SP'),tp_consultorio('13'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(502722310,'Mary F. Fleming',tp_fones(tp_fone('11956957584')),tp_endereco(19385099,'Elit','7102','Riso Sombrio','Gravataí','SP'),tp_consultorio('14'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(315205071,'Liberty F. Sweet',tp_fones(tp_fone('11909687133')),tp_endereco(19640668,'Hymenaeos. Rd.','2983','Rio Branco','Mauá','PA'),tp_consultorio('15'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(491612822,'Desirae P. Montgomery',tp_fones(tp_fone('11978783872')),tp_endereco(19090967,'Metus St.','1988','Planeta','Mauá','MG'),tp_consultorio('16'),NULL));
INSERT INTO tb_medico  VALUES (tp_medico(368899445,'Stuart Q. Hodge', tp_fones(tp_fone('11974771422')), tp_endereco(19424329,'Justo Rd.','7745','Del Porto','Castanhal','PR'),tp_consultorio('1'),tp_nt_supervisionados((SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 979052725), (SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 787894499), (SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 237819555))));
INSERT INTO tb_medico  VALUES (tp_medico(598726773,'Bo M. Ochoa', tp_fones(tp_fone('11962400839')), tp_endereco(19696674,'Nulla St.','4017','Santa Rosa','Niterói','MG'),tp_consultorio('2'),tp_nt_supervisionados((SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 315205071),(SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 491612822),(SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 502722310),(SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 414422955))));
INSERT INTO tb_medico  VALUES (tp_medico(103612340,'Wilma S. Love', tp_fones(tp_fone('11919628564')),tp_endereco(19727574,'Montes, St.','1696','Aparecida','Goiânia','SP'),tp_consultorio('3'),tp_nt_supervisionados((SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 153691371),(SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 990141915))));
INSERT INTO tb_medico  VALUES (tp_medico(167943687,'Wayne U. Lucas', tp_fones(tp_fone('11939796912')),tp_endereco(19780174,'P.O. Box Id Street','2249','Planalto','Guarulhos','PA'),tp_consultorio('4'),tp_nt_supervisionados((SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 543251289),(SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 107292259),(SELECT REF(m1) FROM tb_medico m1 WHERE m1.crm = 269105343))));




-- RECEPCIONISTA
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(766,'Tobias G. Payne', tp_fones(tp_fone('11981546846')), tp_endereco(04394980,'Ap Orci, Rd.','7332','bora bora','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(783,'Joan K. Mcclure', tp_fones(tp_fone('11953040116')), tp_endereco(99694914,'P.O. Box 631, 9041 Dictum. St.','4028','ze da rocha','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(534,'Thaddeus O. Floyd', tp_fones(tp_fone('11949527192')), tp_endereco(09469342,'Ap #156-3421 Sed St.','5992','neguinho da beija-flor','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(429,'Hiroko P. Strong', tp_fones(tp_fone('11982112721')), tp_endereco(22011493,'4601 Sodales Ave','3812','neguinho da beija-flor','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(272,'Conan S. Young', tp_fones(tp_fone('11972627954')), tp_endereco(60904613,'5313 Rutrum Av.','9437','neguinho da beija-flor','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(341,'Calista M. Miles', tp_fones(tp_fone('11914878995')), tp_endereco(87876758,'P.O. Box 957, 7777 Duis Road','6101','neguinho da beija-flor','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(638,'Rhiannon F. Huffman', tp_fones(tp_fone('11932335739')), tp_endereco(88468311,'4908 Dis Rd.','4448','amor e mio','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(136,'Florence I. Webster', tp_fones(tp_fone('11996053276')), tp_endereco(41618970,'Ap #436-9900 Vitae Ave','5715','amor e mio','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(630,'Wenndy U. Dotson', tp_fones(tp_fone('11956025384')), tp_endereco(01527203,'Ap #576-8057 Non, Rd.','5200','amor e mio','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(418,'Azagal E. William', tp_fones(tp_fone('11965434602')), tp_endereco(87561054,'8998 Semper Av.','5597','amor e mio','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(57,'Cartman L. Black', tp_fones(tp_fone('11912342704')), tp_endereco(94458896,'973-5657 Mauris Road','260','amor e mio','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(910,'Carly N. Woodward', tp_fones(tp_fone('11934513883')), tp_endereco(46053982,'Ap #290-7759 Amet Avenue','8448','caca de ovelha','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(130,'Kenny R. Dawson', tp_fones(tp_fone('11916448347')), tp_endereco(94887770,'Ap #748-4728 Sem, Rd.','4733','caca de ovelha','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(402,'McKenzie Q. Dale', tp_fones(tp_fone('11974949848')), tp_endereco(46556331,'3729 Neque St.','4237','caca de ovelha','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(184,'Eden X. Whitaker', tp_fones(tp_fone('11912797858')), tp_endereco(24261888,'P.O. Box 696, 6688 Tellus Ave','6358','caca de ovelha','Ribeirão Preto','SP')));
INSERT INTO tb_recepcionista VALUES (tp_recepcionista(629,'Osob S. Shelton', tp_fones(tp_fone('11919356526')), tp_endereco(12298647,'Ap #696-8880 Suspendisse Ave','1789','caca de ovelha','Ribeirão Preto','SP')));


-- LABORATORIO
INSERT INTO tb_laboratorio 
SELECT 1,'Laboratório Freeman',tp_endereco(14085020,'Floriano Peixoto','537','Vila dos Jacarandás','Olinda','PE'),tp_fones(tp_fone('8121564478'),tp_fone('8121564479'))
FROM dual;


INSERT INTO tb_laboratorio 
SELECT 2,'Laboratório Flowers',tp_endereco(14085540,'Marechal Deodoro','145','Vila dos Jabuticabais','Olinda','PE'),tp_fones(tp_fone('8121324553'), tp_fone('8121546698'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 3,'Laboratório Greene',tp_endereco(14085470,'Conde de Assumar','98','Jardim das Laranjeiras','Recife','PE'),tp_fones(tp_fone('8121770400'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 4,'Laboratório Soto', tp_endereco(14085180,'Rua da Palmeira','133','Vale do Beberibe','Recife','PE'),tp_fones(tp_fone('8121234674'), tp_fone('8121567256'), tp_fone('8121225777'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 5,'Laboratório Bolton', tp_endereco(14085660,'Rua das Mangas','32','Vale do Capibaribe','Recife','PE'),tp_fones(tp_fone('8121668436'))
FROM dual;


INSERT INTO tb_laboratorio 
SELECT 6,'Laboratório Moore', tp_endereco(14085890,'Rua do Açúcar','58','Várzea Grande','Recife','PE'), tp_fones(tp_fone('8121255685'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 7,'Laboratório Hernandez', tp_endereco(14085034,'Princesa Isabel','29','Vila dos Mamoeiros', 'Olinda','PE'),tp_fones(tp_fone('8121864773'),tp_fone('8121217008'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 8,'Laboratório Knowles', tp_endereco(14085045,'Joaquim Nabuco','72','Mártir da Cruz', 'Recife','PE'),tp_fones(tp_fone('8121356709'),tp_fone('8121435785'),tp_fone('8121563289'),tp_fone('8121468903'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 9,'Laboratório Calhoun', tp_endereco(14085666,'Castro Alves','54','Conciliação','Recife','PE'),tp_fones(tp_fone('8121113528'),tp_fone('8121743399'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 10,'Laboratório Ramsey',tp_endereco(14085875,'Dom Pedro II','26','Mártir da Cruz', 'Recife','PE'),tp_fones(tp_fone('8121224290'),tp_fone('8121244270'),tp_fone('8121347801'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 11,'Laboratório Richardson', tp_endereco(14085082,'Rua das Rosas','451','Jardim Verde','Olinda','PE'),tp_fones(tp_fone('8121335689'),tp_fone('8121246982'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 12,'Laboratório Stafford',tp_endereco(14085017,'Rua das Sete','30','Porto Largo','Recife','PE'),tp_fones(tp_fone('8121234765'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 13,'Laboratório Rosa', tp_endereco(14085342,'Rua do Cascalho','451','Largo do Rosário','Recife','PE'),tp_fones(tp_fone('8121557230'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 14,'Laboratório Meyers', tp_endereco(14085165,'Rua do Mel','44','Jardim das Carambolas','Olinda','PE'),tp_fones(tp_fone('8121156789'))
FROM dual;


INSERT INTO tb_laboratorio
SELECT 15,'Laboratório Odom', tp_endereco(14085731,'Rua das Janelas','62','Fundição','Recife','PE'),tp_fones(tp_fone('8121233861'),tp_fone('8121444770'))
FROM dual;




-- PRESCREVE


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =103612340),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='79698560587'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =1), 
    TIMESTAMP '2017-01-12 05:14:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =368899445),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='79698560587'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =1), 
    TIMESTAMP '2017-03-30 07:00:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =167943687),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='92623243718'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =2),
    TIMESTAMP '2017-03-30 08:16:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =167943687),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='92623243718'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =3),
    TIMESTAMP '2017-04-12 06:20:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =167943687),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='92623243718'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =3), 
  TIMESTAMP '2016-09-10 06:17:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =979052725),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='92623243718'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =4),
    TIMESTAMP '2017-01-04 06:14:19')
); 


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =979052725),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='72006753375'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =5), 
  TIMESTAMP '2016-09-04 07:15:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =979052725),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='72006753375'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =6), 
    TIMESTAMP '2015-08-07 05:17:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =979052725),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='94490687865'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =6),
    TIMESTAMP '2016-09-06 08:45:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =237819555),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='17063339739'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =6),
    TIMESTAMP '2015-09-06 09:45:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =598726773),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='17063339739'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =7), 
    TIMESTAMP '2016-09-06 10:45:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =598726773),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='76132992813'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =8),
    TIMESTAMP '2015-09-06 10:45:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =598726773),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='76132992813'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =8),
    TIMESTAMP '2016-05-07 11:45:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =598726773),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='60516668469'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =9), 
    TIMESTAMP '2016-04-07 09:45:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =787894499),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='60516668469'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_medicamento M WHERE M.id =14), 
    TIMESTAMP '2015-04-12 08:14:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =153691371),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='43190124155'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =14), 
    TIMESTAMP '2015-04-04 07:47:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =787894499),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='67638519969'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =17), 
    TIMESTAMP '2016-12-07 05:47:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =787894499),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='67638519969'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =17), 
    TIMESTAMP '2016-12-07 23:47:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =414422955),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='32745616585'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =2),
    TIMESTAMP '2015-11-07 09:03:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =414422955),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='32745616585'), 
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =17), 
    TIMESTAMP '2015-11-30 17:03:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =990141915),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='32745616585'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =18),
    TIMESTAMP '2016-11-30 14:09:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =990141915),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='32745616585'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =19), 
    TIMESTAMP '2016-10-27 12:01:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =990141915),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='38007269003'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =20),
    TIMESTAMP '2015-10-27 05:02:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =502722310),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='38007269003'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =23),
    TIMESTAMP '2015-10-22 08:04:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =502722310),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='38007269003'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =23),
    TIMESTAMP '2016-09-15 10:08:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =787894499),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='68736002407'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =23), 
    TIMESTAMP '2016-08-15 11:09:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =315205071),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='68736002407'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =23),
     TIMESTAMP '2016-07-16 08:09:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =315205071),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='68736002407'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =21),
     TIMESTAMP '2016-09-17 08:09:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =315205071),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='76764741465'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id = 21),
     TIMESTAMP '2016-09-18 09:32:19')
);
INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =315205071),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='68804766912'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =12),
    TIMESTAMP '2016-05-19 10:35:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =315205071),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='68804766912'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =12),
    TIMESTAMP '2016-04-22 07:55:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =315205071),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='68804766912'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =20),
    TIMESTAMP '2015-05-25 08:57:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =237819555),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='12130599361'),
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =19),
    TIMESTAMP '2015-07-27 09:58:19')
);


INSERT INTO tb_prescreve VALUES(
   tp_prescreve(
    (SELECT REF(M) FROM tb_medico M WHERE M.crm =787894499),
    (SELECT REF(PC)  FROM tb_paciente PC WHERE PC.cpf ='56071103541'), 
    (SELECT TREAT (REF(M) AS REF tp_produto) FROM tb_exame M WHERE M.id =17),
    TIMESTAMP '2015-05-19 15:59:19')
);


-- AGENDA EXAME
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 15), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 1),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 766), TIMESTAMP '2017-04-12 21:51:24.42'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 16), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 2),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 783), TIMESTAMP '2017-01-12 22:50:24.45'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 17), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 3),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 534), TIMESTAMP '2017-04-10 22:51:24.30'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 18), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 4),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 429), TIMESTAMP '2017-02-12 22:51:24.10'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 19), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 5),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 272), TIMESTAMP '2017-04-08 22:51:24.34'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 20), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 6),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 341), TIMESTAMP '2017-04-12 17:51:24.67'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 21), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 7),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 638), TIMESTAMP '2017-04-12 14:51:24.55'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 22), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 8),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 136), TIMESTAMP '2017-04-10 20:51:24.32'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 23), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 9),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 630), TIMESTAMP '2017-04-12 22:48:50.12'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 17), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 2),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 766), TIMESTAMP '2017-01-12 10:51:24.42'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 15), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 4),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 136), TIMESTAMP '2017-02-20 08:51:24.42'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 20), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 5),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 136), TIMESTAMP '2017-04-03 13:51:24.42'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 22), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 7),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 57), TIMESTAMP '2017-03-01 10:51:24.42'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 15), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 3),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 910), TIMESTAMP '2017-01-30 21:51:24.42'));
INSERT INTO tb_agenda_exame VALUES (tp_agenda_exame((SELECT REF(ex) FROM tb_exame ex WHERE ex.id = 20), (SELECT REF(lab) FROM tb_laboratorio lab WHERE lab.id = 6),(SELECT REF(r) FROM tb_recepcionista r WHERE r.id = 910), TIMESTAMP '2017-03-18 21:51:24.42'));


-- CONSULTA


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-10 06:17:19', 'consulta diagnóstica', 'Quadro de Gonorréia'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 543251289 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-01-12 05:14:19', 'consulta diagnóstica', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 103612340 AND tb_p.cpf = '79698560587';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-03-30 07:00:19', 'consulta diagnóstica', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 368899445 AND tb_p.cpf = '79698560587';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-03-30 08:16:19', 'consulta de acompanhamento', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 167943687 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-04-12 06:20:19', 'consulta diagnóstica', 'Quadro de Cistite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 167943687 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-10 06:17:19', 'consulta diagnóstica', 'Quadro de Gonorréia'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 543251289 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-01-04 06:14:19', 'consulta de acompanhamento', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 543251289 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-04 07:15:19', 'consulta de acompanhamento', 'Quadro de Sífilis Primária'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 979052725 AND tb_p.cpf = '72006753375';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-08-07 05:17:19', 'consulta de acompanhamento', 'Quadro de Infecção'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 979052725 AND tb_p.cpf = '72006753375';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-06 08:45:19', 'consulta de acompanhamento', 'Quadro de Infecção'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 979052725 AND tb_p.cpf = '94490687865';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-09-06 09:45:19', 'consulta diagnóstica', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 269105343 AND tb_p.cpf = '17063339739';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-06 10:45:19', 'consulta de acompanhamento', 'Quadro de Infecção'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 598726773 AND tb_p.cpf = '17063339739';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-09-06 10:45:19', 'consulta de acompanhamento', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 598726773 AND tb_p.cpf = '76132992813';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-05-07 11:45:19', 'consulta diagnóstica', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 598726773 AND tb_p.cpf = '76132992813';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-05-07 11:45:19', 'consulta diagnóstica', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 598726773 AND tb_p.cpf = '76132992813';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-04-07 09:45:19', 'consulta de acompanhamento', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 107292259 AND tb_p.cpf = '60516668469';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-04-12 08:14:19', 'consulta diagnóstica', 'Quadro de Litíase Urinária'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 787894499 AND tb_p.cpf = '60516668469';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-04-04 07:47:19', 'consulta diagnóstica', 'Quadro de Litíase Urinária'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 153691371 AND tb_p.cpf = '43190124155';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-12-07 05:47:19', 'consulta diagnostica', 'Suspeita de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 787894499 AND tb_p.cpf = '67638519969';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-12-07 23:47:19', 'consulta diagnóstica', 'Suspeita de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 787894499 AND tb_p.cpf = '67638519969';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-11-07 09:03:19', 'consulta diagnóstica', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 414422955 AND tb_p.cpf = '32745616585';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-11-30 17:03:19', 'consulta diagnóstica', 'Suspeita de Cistite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 414422955 AND tb_p.cpf = '32745616585';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-11-30 14:09:19', 'consulta diagnóstica', 'Suspeita de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 990141915 AND tb_p.cpf = '32745616585';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-10-27 12:01:19', 'consulta diagnóstica', 'Suspeita de Gonorréia'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 990141915 AND tb_p.cpf = '32745616585';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-10-27 05:02:19', 'consulta diagnóstica', 'Suspeita de Gonorréia'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 990141915 AND tb_p.cpf = '38007269003';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-10-22 08:04:19', 'consulta de acompanhamento', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 502722310 AND tb_p.cpf = '38007269003';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-15 10:08:19', 'consulta diagnóstica', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 502722310 AND tb_p.cpf = '38007269003';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-08-15 11:09:19', 'consulta diagnóstica', 'Suspeita de Anomalia Renal'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 787894499 AND tb_p.cpf = '68736002407';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-07-16 08:09:19', 'consulta diagnóstica', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 315205071 AND tb_p.cpf = '68736002407';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-17 08:09:19', 'consulta diagnóstica', 'Suspeita de Litíase'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 315205071 AND tb_p.cpf = '68736002407';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-09-18 09:32:19', 'consulta de acompanhamento', 'Quadro de Litíase'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 315205071 AND tb_p.cpf = '76764741465';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-05-19 10:35:19', 'consulta de acompanhamento', 'Quadro de Hiperplasia Prostática Benigna'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 315205071 AND tb_p.cpf = '68804766912';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2016-04-22 07:55:19', 'consulta diagnóstica', 'Quadro de Hiperplasia Prostática Benigna'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 315205071 AND tb_p.cpf = '68804766912';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-05-25 08:57:19', 'consulta diagnóstica', 'Quadro de Gonorréia'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 315205071 AND tb_p.cpf = '68804766912';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-07-27 09:58:19', 'consulta diagnóstica', 'Suspeita de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 237819555 AND tb_p.cpf = '12130599361';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2015-05-19 15:59:19', 'consulta de acompanhamento', 'Suspeita de Cistite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 787894499 AND tb_p.cpf = '56071103541';


--consultas que não preescreveram produtos:


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-02-13 08:00:00', 'consulta de acompanhamento', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 103612340 AND tb_p.cpf = '79698560587';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-04-15 08:00:19', 'consulta de acompanhamento', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 368899445 AND tb_p.cpf = '79698560587';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-04-10 09:15:21', 'consulta de acompanhamento', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 167943687 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-03-05 07:28:16', 'consulta de acompanhamento', 'Quadro de Cistite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 167943687 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-10-10 06:17:19', 'consulta de acompanhamento', 'Quadro de Gonorréia'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 543251289 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-02-07 06:25:18', 'consulta de acompanhamento', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 543251289 AND tb_p.cpf = '92623243718';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-04-05 09:45:00', 'consulta diagnóstica', 'Quadro de Infecção'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 979052725 AND tb_p.cpf = '94490687865';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-02-01 13:45:19', 'consulta diagnóstica', 'Quadro de Infecção'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 598726773 AND tb_p.cpf = '17063339739';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-03-08 15:00:03', 'consulta diagnóstica', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 598726773 AND tb_p.cpf = '76132992813';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-03-07 08:45:19', 'consulta diagnóstica', 'Quadro de Infecção Urinária - ITU'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 107292259 AND tb_p.cpf = '60516668469';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-04-25 09:00:00', 'consulta de acompanhamento', 'Quadro de Litíase Urinária'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 787894499 AND tb_p.cpf = '60516668469';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-04-30 07:47:19', 'consulta de acompanhamento', 'Quadro de Litíase Urinária'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 153691371 AND tb_p.cpf = '43190124155';


INSERT INTO tb_consulta
SELECT    REF(tb_m), REF(tb_p), TIMESTAMP '2017-12-08 10:03:19', 'consulta de acompanhamento', 'Quadro de Pielonefrite'
FROM    tb_medico tb_m, tb_paciente tb_p
WHERE   tb_m.crm = 414422955 AND tb_p.cpf = '32745616585';
