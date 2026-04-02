# 1. 创建数据库dbtest11
CREATE DATABASE dbtest11;

# 2. 运行以下脚本创建表my_employees
USE dbtest11;
CREATE TABLE my_employees (
                              id INT(10),
                              first_name VARCHAR(10),
                              last_name VARCHAR(10),
                              userid VARCHAR(10),
                              salary DOUBLE(10,2)
);

CREATE TABLE users(
                      userid VARCHAR(10),
                      department_id INT(4)
);

# 3. 显示表my_employees的结构
DESC my_employees;
# 4. 向my_employees表中插入下列数据
INSERT INTO my_employees VALUES (1, 'patel', 'Ralph', 'Rpatel', 895);
INSERT INTO my_employees VALUES (2, 'Dancs', 'Betty', 'Bdancs', 860);
INSERT INTO my_employees VALUES (3, 'Biri', 'Ben', 'Bbiri', 1100);
INSERT INTO my_employees VALUES (4, 'Newman', 'Chad', 'Cnewman', 750);
INSERT INTO my_employees VALUES (5, 'Ropeburn', 'Audrey', 'Aropebur', 1550);

INSERT INTO users VALUES ('Rpatel', 10);
INSERT INTO users VALUES ('Bdancs', 10);
INSERT INTO users VALUES ('Bbiri', 20);
INSERT INTO users VALUES ('Cnewman', 30);
INSERT INTO users VALUES ('Aropebur', 40);

# 6. 将3号员工的last_name修改为“drelxer”
UPDATE my_employees SET last_name = 'drelxer' WHERE id = 3;

# 7. 将所有工资少于900的员工的工资修改为1000
UPDATE my_employees SET salary = 1000 WHERE salary < 900;

# 8. 将userid为Bbiri的users表和my_employees表的记录全部删除
DELETE FROM users WHERE userid = 'Bbiri';
DELETE FROM my_employees WHERE userid = 'Bbiri';

# 9. 删除my_employees、users表所有数据
DELETE FROM my_employees;
DELETE FROM users;

# 10. 检查所作的修正
SELECT * FROM my_employees;
SELECT * FROM users;

# 11. 清空表my_employees
TRUNCATE TABLE my_employees;

#练习2
#1. 使用现有数据库dbtest11
USE dbtest11;

#2. 创建表格pet
CREATE TABLE pet (
                     name VARCHAR(20),
                     owner VARCHAR(20),
                     species VARCHAR(20),
                     gender CHAR(1),
                     birth DATE,
                     death DATE
);
#3. 添加记录
INSERT INTO pet VALUES
                    ('Fluffy', 'Harold', 'cat', 'f', '1993-02-04', NULL),
                    ('Claws', 'Gwen', 'cat', 'm', '1994-03-17', NULL),
                    ('Buffy', 'Harold', 'dog', 'f', '1989-05-13', NULL),
                    ('Fang', 'Benny', 'dog', 'm', '1990-08-27', NULL),
                    ('Whistler', 'Gwen', 'bird', 'f', '1997-12-09', NULL),
                    ('Slim', 'Benny', 'snake', 'm', '1996-04-29', '1997-08-03'),
                    ('Puffball', 'Diane', 'hamster', 'f', '1999-03-30', NULL);

#4. 添加字段:主人的生日owner_birth DATE类型。
ALTER TABLE pet ADD owner_birth DATE;

#5. 将名称为Claws的猫的主人改为kevin
UPDATE pet SET owner = 'kevin' WHERE name = 'Claws' AND species = 'cat';

#6. 将没有死的狗的主人改为duck
UPDATE pet SET owner = 'duck' WHERE species = 'dog' AND death IS NULL;

#7. 查询没有主人的宠物的名字；
SELECT name FROM pet WHERE owner IS NULL;
#8. 查询已经死了的cat的姓名，主人，以及去世时间；
SELECT name, owner, death FROM pet WHERE species = 'cat' AND death IS NOT NULL;

#9. 删除已经死亡的狗
DELETE FROM pet WHERE species = 'dog' AND death IS NOT NULL;
#10. 查询所有宠物信息
SELECT * FROM pet;
#练习3
#1. 使用已有的数据库dbtest11
USE dbtest11;
#2. 创建表employee，并添加记录
CREATE TABLE employee (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          emp_name VARCHAR(15),
                          sex CHAR(1),
                          addr VARCHAR(50),
                          salary DOUBLE,
                          mgr_id INT -- 假设为上级员工ID
);

INSERT INTO employee(emp_name, sex, addr, salary, mgr_id) VALUES
                                                              ('张三', '男', '北京', 1200, 3),
                                                              ('李四', '男', '上海', 1300, 3),
                                                              ('王五', '男', '广州', 900, 3),
                                                              ('赵六', '女', '深圳', 1500, 1),
                                                              ('小明', '男', '杭州', 1400, 1),
                                                              ('刘明', '女', '成都', 1250, 3),
                                                              ('小兰', '女', '西安', 1350, 2);

#3. 查询出薪资在1200~1300之间的员工信息。
SELECT * FROM employee WHERE salary BETWEEN 1200 AND 1300;

#4. 查询出姓“刘”的员工的工号，姓名，家庭住址。
SELECT id, emp_name, addr FROM employee WHERE emp_name LIKE '刘%';
#5. 将“李四”的家庭住址改为“广东韶关”
UPDATE employee SET addr = '广东韶关' WHERE emp_name = '李四';
#6. 查询出名字中带“小”的员工
SELECT * FROM employee WHERE emp_name LIKE '%小%';

# 约束的课后练习

#练习1：
CREATE DATABASE test04_emp;

USE test04_emp;

CREATE TABLE emp2(
                     id INT,
                     emp_name VARCHAR(15)
);

CREATE TABLE dept2(
                      id INT,
                      dept_name VARCHAR(15)
);

#1.向表emp2的id列中添加PRIMARY KEY约束

ALTER TABLE emp2 ADD CONSTRAINT pk_emp_id PRIMARY KEY(id);

#2.向表dept2的id列中添加PRIMARY KEY约束
ALTER TABLE dept2 ADD CONSTRAINT pk_dept_id PRIMARY KEY(id);
#3.向表emp2中添加列dept_id，并在其中定义FOREIGN KEY约束，与之相关联的列是dept2表中的id列。
ALTER TABLE emp2 ADD COLUMN dept_id INT;
ALTER TABLE emp2 ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY(dept_id) REFERENCES dept2(id);

#练习2：

#1. 创建数据库test04_company
CREATE DATABASE IF NOT EXISTS test04_company CHARACTER SET 'utf8';

USE test04_company;

#2. 按照下表给出的表结构在test04_company数据库中创建两个数据表offices和employees

CREATE TABLE IF NOT EXISTS offices(
                                      officeCode INT(10) PRIMARY KEY ,
                                      city VARCHAR(50) NOT NULL,
                                      address VARCHAR(50) ,
                                      country VARCHAR(50) NOT NULL,
                                      postalCode VARCHAR(15),
                                      CONSTRAINT uk_off_poscode UNIQUE(postalCode)

);

DESC offices;

CREATE TABLE employees(
                          employeeNumber INT PRIMARY KEY AUTO_INCREMENT,
                          lastName VARCHAR(50) NOT NULL,
                          firstName VARCHAR(50) NOT NULL,
                          mobile VARCHAR(25) UNIQUE,
                          officeCode INT(10) NOT NULL,
                          jobTitle VARCHAR(50) NOT NULL,
                          birth DATETIME NOT NULL,
                          note VARCHAR(255),
                          sex VARCHAR(5),
                          CONSTRAINT fk_emp_offcode FOREIGN KEY (officeCode) REFERENCES offices(officeCode)

);

DESC employees;

#3. 将表employees的mobile字段修改到officeCode字段后面
ALTER TABLE employees MODIFY mobile VARCHAR(25) UNIQUE AFTER officeCode;

#4. 将表employees的birth字段改名为employee_birth
ALTER TABLE employees CHANGE birth employee_birth DATETIME NOT NULL;
#5. 修改sex字段，数据类型为CHAR(1)，非空约束
ALTER TABLE employees MODIFY sex CHAR(1) NOT NULL;
#6. 删除字段note
ALTER TABLE employees DROP COLUMN note;

#7. 增加字段名favoriate_activity，数据类型为VARCHAR(100)
ALTER TABLE employees ADD favoriate_activity VARCHAR(100);

#8. 将表employees名称修改为employees_info
RENAME TABLE employees TO employees_info;

