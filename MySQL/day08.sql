#练习1：测试变量的使用

#存储函数的练习

#0. 准备工作
CREATE DATABASE test16_var_cursor;

USE test16_var_cursor;

CREATE TABLE employees
AS
SELECT * FROM dbtest2.`employees`;

CREATE TABLE departments
AS
SELECT * FROM dbtest2.`departments`;

SET GLOBAL log_bin_trust_function_creators = 1;

#无参有返回
#1. 创建函数get_count(),返回公司的员工个数
DELIMITER //
CREATE FUNCTION get_count()
    RETURNS INT
BEGIN
    DECLARE emp_count INT DEFAULT 0;
    SELECT COUNT(*) INTO emp_count FROM employees;
    RETURN emp_count;
END //
DELIMITER ;

#调用
SELECT get_count();

#有参有返回
#2. 创建函数ename_salary(),根据员工姓名，返回它的工资
DELIMITER //
CREATE FUNCTION ename_salary(emp_firstname VARCHAR(50),emp_lastname VARCHAR(50))
    RETURNS DOUBLE
BEGIN
    DECLARE emp_salary DECIMAL(10,2) DEFAULT 0;
    SELECT salary INTO emp_salary
    FROM employees
    WHERE first_name = emp_firstname AND last_name = emp_lastname;
    RETURN emp_salary;
END //
DELIMITER ;

#调用
SELECT ename_salary('John','Chen');

#3. 创建函数dept_sal() ,根据部门名，返回该部门的平均工资
DELIMITER //
CREATE FUNCTION dept_sal(dept_name VARCHAR(50))
    RETURNS DOUBLE
BEGIN
    DECLARE avg_salary DECIMAL(10,2) DEFAULT 0;
    SELECT AVG(e.salary) INTO avg_salary
    FROM employees e
             JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = dept_name;
    RETURN avg_salary;
END //
DELIMITER ;

#调用
SELECT dept_sal('IT');

#4. 创建函数add_float()，实现传入两个float，返回二者之和
DELIMITER //
CREATE FUNCTION add_float(num1 FLOAT, num2 FLOAT)
    RETURNS FLOAT
BEGIN
    RETURN num1 + num2;
END //
DELIMITER ;

# 调用
SELECT add_float(3.14, 2.86);

#2. 流程控制

/*
分支：if \ case ... when \ case when ...
循环：loop \ while \ repeat
其它：leave \ iterate
*/

#1. 创建函数test_if_case()，实现传入成绩，如果成绩>90,返回A，如果成绩>80,返回B，如果成绩>60,返回C，否则返回D
#要求：分别使用if结构和case结构实现

#使用IF结构实现
DELIMITER //
CREATE FUNCTION test_if_case(score INT)
    RETURNS VARCHAR(1)
BEGIN
    DECLARE grade CHAR(1);

    IF score > 90 THEN
        SET grade = 'A';
    ELSEIF score > 80 THEN
        SET grade = 'B';
    ELSEIF score > 60 THEN
        SET grade = 'C';
    ELSE
        SET grade = 'D';
    END IF;

    RETURN grade;
END //
DELIMITER ;

#使用CASE结构实现
DELIMITER //
CREATE FUNCTION test_case_score(score INT)
    RETURNS VARCHAR(1)
BEGIN
    DECLARE grade CHAR(1);

    CASE
        WHEN score > 90 THEN SET grade = 'A';
        WHEN score > 80 THEN SET grade = 'B';
        WHEN score > 60 THEN SET grade = 'C';
        ELSE SET grade = 'D';
        END CASE;

    RETURN grade;
END //
DELIMITER ;

#调用测试
SELECT test_if_case(85), test_case_score(95);

#2. 创建存储过程test_if_pro()，传入工资值，如果工资值<3000,则删除工资为此值的员工，
# 如果3000 <= 工资值 <= 5000,则修改此工资值的员工薪资涨1000，否则涨工资500
DELIMITER //
CREATE PROCEDURE test_if_pro(IN salary_value DECIMAL(10,2))
BEGIN
    IF salary_value < 3000 THEN
        DELETE FROM employees WHERE salary = salary_value;
    ELSEIF salary_value >= 3000 AND salary_value <= 5000 THEN
        UPDATE employees SET salary = salary + 1000 WHERE salary = salary_value;
    ELSE
        UPDATE employees SET salary = salary + 500 WHERE salary = salary_value;
    END IF;
END //
DELIMITER ;

#3. 创建存储过程insert_data(),传入参数为 IN 的 INT 类型变量 insert_count,实现向admin表中
#批量插入insert_count条记录

#首先创建admin表
CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50),
                       password VARCHAR(50)
);

DELIMITER //
CREATE PROCEDURE insert_data(IN insert_count INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= insert_count DO
            INSERT INTO admin(username, password)
            VALUES (CONCAT('user_', i), CONCAT('pass_', i));
            SET i = i + 1;
        END WHILE;
END //
DELIMITER ;

#调用
CALL insert_data(5);

#3. 游标的使用

#创建存储过程update_salary()，参数1为 IN 的INT型变量dept_id，表示部门id；
#参数2为 IN的INT型变量change_sal_count，表示要调整薪资的员工个数。查询指定id部门的员工信息，
#按照salary升序排列，根据hire_date的情况，调整前change_sal_count个员工的薪资。

DELIMITER //
CREATE PROCEDURE update_salary(
    IN dept_id INT,
    IN change_sal_count INT
)
BEGIN
    #声明变量
    DECLARE emp_id INT;
    DECLARE emp_salary DECIMAL(10,2);
    DECLARE emp_hire_date DATE;
    DECLARE counter INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;

    #声明游标
    DECLARE emp_cursor CURSOR FOR
        SELECT employee_id, salary, hire_date
        FROM employees
        WHERE department_id = dept_id
        ORDER BY salary ASC;

    #声明结束处理程序
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    #打开游标
    OPEN emp_cursor;

    #循环读取游标数据
    read_loop: LOOP
        FETCH emp_cursor INTO emp_id, emp_salary, emp_hire_date;

        IF done OR counter >= change_sal_count THEN
            LEAVE read_loop;
        END IF;

        #根据hire_date调整薪资
        IF emp_hire_date < '2005-01-01' THEN
            UPDATE employees SET salary = salary * 1.1 WHERE employee_id = emp_id;
        ELSE
            UPDATE employees SET salary = salary * 1.05 WHERE employee_id = emp_id;
        END IF;

        SET counter = counter + 1;
    END LOOP;

    #关闭游标
    CLOSE emp_cursor;
END //
DELIMITER ;

#调用示例
CALL update_salary(50, 3);