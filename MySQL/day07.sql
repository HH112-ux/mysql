CREATE TABLE emps
AS
SELECT * FROM dbtest2.employees;

DESC emps;
#练习一
#1. 使用表emps创建视图employee_vu
CREATE VIEW employee_vu AS
SELECT LAST_NAME, EMPLOYEE_ID, DEPARTMENT_ID
FROM emps;

#2. 显示视图的结构
DESC employee_vu;

#3. 查询视图中的全部内容
SELECT * FROM employee_vu;

#4. 将视图中的数据限定在部门号是80的范围内
CREATE OR REPLACE VIEW employee_vu AS
SELECT LAST_NAME, EMPLOYEE_ID, DEPARTMENT_ID
FROM emps
WHERE DEPARTMENT_ID = 80;
#练习二
#1. 创建视图emp_v1,查询电话号码以'011'开头的员工姓名和工资、邮箱
CREATE VIEW emp_v1 AS
SELECT first_name, salary, email
FROM emps
WHERE phone_number LIKE '011%';

#2. 修改视图 emp_v1 查询电话号码以'011'开头且邮箱中包含e字符的员工姓名和邮箱、电话号码
CREATE OR REPLACE VIEW emp_v1 AS
SELECT first_name, email, phone_number
FROM emps
WHERE phone_number LIKE '011%' AND email LIKE '%e%';


#3. 向 emp_v1 插入一条记录，是否可以？
#不可以
#4. 修改emp_v1中员工的工资，每人涨薪1000
UPDATE emps
SET salary = salary + 1000
WHERE phone_number LIKE '011%' AND email LIKE '%e%';
#5. 删除emp_v1中姓名为Olsen的员工
DELETE FROM emps
WHERE first_name = 'Olsen'
  AND phone_number LIKE '011%'
  AND email LIKE '%e%';

#6. 创建视图emp_v2，查询部门的最高工资高于12000的部门id和其最高工资
CREATE VIEW emp_v2 AS
SELECT department_id, MAX(salary) as max_salary
FROM emps
GROUP BY department_id
HAVING MAX(salary) > 12000;

#7. 向 emp_v2 中插入一条记录，是否可以？
#不可以，因为这个视图涉及聚合函数和分组，不能直接插入

#8. 删除刚才的emp_v2 和 emp_v1
DROP VIEW IF EXISTS emp_v2, emp_v1;



#0.准备工作
CREATE DATABASE test15_pro_func;
USE test15_pro_func;

#1. 创建存储过程insert_user(),实现传入用户名和密码，插入到admin表中
CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50),
                       password VARCHAR(50)
);

DELIMITER //
CREATE PROCEDURE insert_user(IN p_username VARCHAR(50), IN p_password VARCHAR(50))
BEGIN
    INSERT INTO admin(username, password) VALUES(p_username, p_password);
END //
DELIMITER ;

#调用
CALL insert_user('john', '123456');

#2. 创建存储过程get_phone(),实现传入女神编号，返回女神姓名和女神电话
CREATE TABLE beauty(
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       NAME VARCHAR(15) NOT NULL,
                       phone VARCHAR(15) UNIQUE,
                       birth DATE
);

INSERT INTO beauty(NAME,phone,birth)
VALUES
    ('朱茵','13201233453','1982-02-12'),
    ('孙燕姿','13501233653','1980-12-09'),
    ('田馥甄','13651238755','1983-08-21'),
    ('邓紫棋','17843283452','1991-11-12'),
    ('刘若英','18635575464','1989-05-18'),
    ('杨超越','13761238755','1994-05-11');

DELIMITER //
CREATE PROCEDURE get_phone(IN p_id INT, OUT p_name VARCHAR(15), OUT p_phone VARCHAR(15))
BEGIN
    SELECT NAME, phone INTO p_name, p_phone
    FROM beauty
    WHERE id = p_id;
END //
DELIMITER ;

#调用
CALL get_phone(1, @name, @phone);
SELECT @name, @phone;

#3. 创建存储过程date_diff()，实现传入两个女神生日，返回日期间隔大小
DELIMITER //
CREATE PROCEDURE date_diff(IN date1 DATE, IN date2 DATE, OUT diff_days INT)
BEGIN
    SELECT DATEDIFF(date1, date2) INTO diff_days;
END //
DELIMITER ;

#调用
CALL date_diff('1990-01-01', '1985-01-01', @days);
SELECT @days;

#4. 创建存储过程format_date(),实现传入一个日期，格式化成xx年xx月xx日并返回
DELIMITER //
CREATE PROCEDURE format_date(IN input_date DATE, OUT formatted_date VARCHAR(50))
BEGIN
    SELECT CONCAT(YEAR(input_date), '年', MONTH(input_date), '月', DAY(input_date), '日')
    INTO formatted_date;
END //
DELIMITER ;

#调用
CALL format_date('2023-05-20', @formatted);
SELECT @formatted;
#5. 创建存储过程beauty_limit()，根据传入的起始索引和条目数，查询女神表的记录
DELIMITER //
CREATE PROCEDURE beauty_limit(IN start_index INT, IN num_items INT)
BEGIN
    SELECT * FROM beauty LIMIT start_index, num_items;
END //
DELIMITER ;

#调用
CALL beauty_limit(0, 3);

#6. 传入a和b两个值，最终a和b都翻倍并返回
DELIMITER //
CREATE PROCEDURE double_values(INOUT a INT, INOUT b INT)
BEGIN
    SET a = a * 2;
    SET b = b * 2;
END //
DELIMITER ;

#调用
SET @x = 5, @y = 10;
CALL double_values(@x, @y);
SELECT @x, @y;

#7. 删除题目5的存储过程
DROP PROCEDURE IF EXISTS beauty_limit;

#8. 查看题目6中存储过程的信息
SHOW CREATE PROCEDURE double_values;


#0. 准备工作
USE test15_pro_func;

CREATE TABLE employees
AS
SELECT * FROM dbtest2.`employees`;

CREATE TABLE departments
AS
SELECT * FROM dbtest2.`departments`;

SET GLOBAL log_bin_trust_function_creators = 1;

#1. 创建函数get_count(),返回公司的员工个数
DELIMITER //
CREATE FUNCTION get_count()
    RETURNS INT
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE emp_count INT DEFAULT 0;
    SELECT COUNT(*) INTO emp_count FROM employees;
    RETURN emp_count;
END //
DELIMITER ;
SELECT get_count();

#2. 创建函数ename_salary(),根据员工姓名，返回它的工资
DELIMITER //
CREATE FUNCTION ename_salary(emp_name VARCHAR(50))
    RETURNS DECIMAL(10,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE emp_salary DECIMAL(10,2) DEFAULT 0;
    SELECT salary INTO emp_salary
    FROM employees
    WHERE first_name = emp_name;
    RETURN emp_salary;
END //
DELIMITER ;

SELECT ename_salary('Steven');

#3. 创建函数dept_sal() ,根据部门名，返回该部门的平均工资
DELIMITER //
CREATE FUNCTION dept_sal(dept_name VARCHAR(50))
    RETURNS DECIMAL(10,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE avg_salary DECIMAL(10,2) DEFAULT 0;
    SELECT AVG(e.salary) INTO avg_salary
    FROM employees e
             JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = dept_name;
    RETURN avg_salary;
END //
DELIMITER ;

SELECT dept_sal('IT');

#4. 创建函数add_float()，实现传入两个float，返回二者之和
DELIMITER //
CREATE FUNCTION add_float(num1 FLOAT, num2 FLOAT)
    RETURNS FLOAT
    DETERMINISTIC
BEGIN
    RETURN num1 + num2;
END //
DELIMITER ;

SELECT add_float(3.14, 2.86);