#排序查询的关键字 order by
#升序排序 ASC
#降序排序 DESC
# 按照salary从高到低的顺序显示员工信息
SELECT employee_id,last_name,salary FROM employees ORDER BY salary DESC;

# 按照salary从低到高的顺序显示员工信息
SELECT employee_id,last_name,salary FROM employees ORDER BY salary ASC;

# 如果在ORDER BY 后没有显式指名排序的方式的话，则默认按照升序排列。
SELECT employee_id,last_name,salary FROM employees ORDER BY salary;
SELECT employee_id,salary,salary * 12 "annual_sal" FROM employees ORDER BY annual_sal;
#WHERE 不可以用别名
#SELECT employee_id,salary,salary * 12 "annual_sal" FROM employees WHERE annual_sal > 81600;

SELECT employee_id,salary FROM employees
WHERE department_id IN (50,60,70)
ORDER BY department_id DESC;
#主次排序
SELECT employee_id,salary,department_id FROM employees
ORDER BY department_id DESC,salary ASC;
#分页查询的关键字 limit [记录的偏移量】，行数
#语法
#前10条记录：
#SELECT * FROM 表名 LIMIT 0,10;
#或者
#SELECT * FROM 表名 LIMIT 10;
#第11至20条记录：
#SELECT * FROM 表名 LIMIT 10,10;
#第21至30条记录：
#SELECT * FROM 表名 LIMIT 20,10;
SELECT employee_id,last_name FROM employees
LIMIT 0,20;
SELECT employee_id,last_name FROM employees
LIMIT 20,20;
SELECT employee_id,last_name FROM employees
LIMIT 40,20;
SELECT `employee_id`,`last_name`,`salary` FROM `employees`
WHERE salary > 6000 ORDER BY salary DESC
LIMIT 0,10;

SELECT `employee_id`,`last_name`,`salary` FROM `employees`
WHERE salary > 6000 ORDER BY salary DESC
LIMIT 10;

# 查询员工表，只显示第32 33条记录
SELECT `employee_id`,`last_name`,`salary` FROM `employees`
LIMIT 31,2;
#mysql8中的分页新特性:  LIMIT ... OFFSET ...
# limit 3 OFFSET 4 等价于 limit 4,3

# 查询员工表，只显示第32 33条记录  使用LIMIT ... OFFSET ...的格式实现
SELECT `employee_id`,`last_name`,`salary` FROM `employees`
LIMIT 2 OFFSET 31;
#查询员工表中工资最高的员工信息
SELECT `employee_id`,`last_name`,`salary` FROM `employees` ORDER BY salary DESC LIMIT 0,1;
SELECT `employee_id`,`last_name`,`salary` FROM `employees` ORDER BY salary DESC LIMIT 1;
SELECT `employee_id`,`last_name`,`salary` FROM `employees` ORDER BY salary DESC LIMIT 1 OFFSET 0;

# 1. 查询员工的姓名和部门号和年薪，按年薪降序,按姓名升序显示
SELECT last_name,`department_id`,`salary`*12 FROM employees ORDER BY `salary`*12 DESC,last_name ASC;

# 2. 选择工资不在 8000 到 17000 的员工的姓名和工资，按工资降序，显示第21到40位置的数据
SELECT last_name,salary FROM `employees` WHERE salary NOT BETWEEN 8000 AND 17000 ORDER BY salary DESC
LIMIT 20,20;

# 3. 查询邮箱中包含 e 的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT `employee_id`,`last_name`,`department_id`,`email` FROM `employees` WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC,department_id ASC;
-- 查询员工信息及其对应的部门信息还有地址信息
SELECT *
FROM employees
WHERE last_name = 'Abel';

SELECT * FROM `departments` WHERE `department_id` = 80;

SELECT * FROM `locations` WHERE `location_id` = 2500;

-- 查询员工信息及其对应的部门信息
-- 部门表总记录数27 员工表总记录数107
SELECT * FROM `employees`,`departments`; -- 交叉连接的方式产生的结果是一个笛卡尔乘积表(产生大量冗余 不正确的数据)

-- 多表查询的正确方式:基于笛卡尔乘积表 进行进一步的筛选和过滤，剩下的记录才是正确的记录。
-- 将两张表中的所有字段全部查询出来
SELECT * FROM `employees`,`departments`
WHERE `departments`.`department_id` = `employees`.`department_id`;
-- 查询部分字段
SELECT `employee_id`,last_name,`department_name` FROM `employees`,`departments`
WHERE `departments`.`department_id` = `employees`.`department_id`;
-- 在查询的时候，我们可以通过表名来指定字段
SELECT employees.`employee_id`,employees.last_name,departments.`department_name`
FROM `employees`,`departments`
WHERE `departments`.`department_id` = `employees`.`department_id`;
-- 如果表的名字太长,我们也可以给表取别名
SELECT e.`employee_id`,e.`last_name`,d.`department_name` FROM `employees` AS e,`departments` AS d
WHERE e.`department_id` = d.`department_id`;

-- 一旦给表取了别名之后，where后面也可以跟别名  下面这种写法报错的
SELECT e.`employee_id`,e.`last_name`,d.`department_name` FROM `employees` AS e,`departments` AS d
WHERE employees.`department_id` = departments.`department_id`;
-- 还可以给查询字段取别名
SELECT e.`employee_id` AS "员工编号",
       e.`last_name` AS "员工名称",
       d.`department_name` AS "部门名称"
FROM `employees` AS e,`departments` AS d
WHERE e.`department_id` = d.`department_id`;

--  查询员工信息及其对应的部门信息及其对应的地址信息
SELECT e.`employee_id`,e.`last_name`,d.`department_name`,l.`city`,l.`street_address` FROM `employees` AS e,`departments` AS d,`locations` AS l
WHERE e.`department_id` = d.`department_id`
  AND d.`location_id` = l.`location_id`;
SELECT e.`employee_id`,e.`last_name`,d.`department_name`,l.`city`,l.`street_address` FROM `employees` AS e,`departments` AS d,`locations` AS l
WHERE e.`department_id` = d.`department_id`AND d.`location_id` = l.`location_id`AND e.employee_id=109;
SELECT employees.`employee_id`,employees.`last_name`,job_grades.`grade_level` FROM `employees`,`job_grades`
WHERE employees.`salary` >= job_grades.`lowest_sal` AND employees.`salary` <= job_grades.`highest_sal`;

SELECT employees.`employee_id`,employees.`last_name`,job_grades.`grade_level` FROM `employees`,`job_grades`
WHERE employees.`salary` BETWEEN job_grades.`lowest_sal` AND job_grades.`highest_sal`;

-- 自连接 一张表自己和自己匹配
-- 自连接的使用前提： 同一张表中一个字段的值引用了另一个字段的值
-- 需求: 查询员工信息及其对应的上级领导信息
SELECT emp.`employee_id`,emp.`last_name`,mgr.`last_name` FROM `employees` AS emp,`employees` AS mgr
WHERE emp.`manager_id` = mgr.`employee_id`

-- 内连接 只查询两张表中匹配的记录，任何不匹配的记录都会被过滤掉。
-- 隐式内连接 查询员工信息及其对应的部门信息
SELECT `employee_id`,last_name,`department_name` FROM `employees`,`departments`
WHERE `departments`.`department_id` = `employees`.`department_id`;

-- 显式内连接  表1 inner join 表2  on 条件
SELECT emp.`employee_id`,emp.`last_name`,dept.`department_name` FROM `employees` AS emp INNER JOIN `departments` AS dept
                                                                                                   ON emp.`department_id` = dept.`department_id`;
-- inner关键字可以省略的
SELECT emp.`employee_id`,emp.`last_name`,dept.`department_name` FROM `employees` AS emp JOIN `departments` AS dept
                                                                                             ON emp.`department_id` = dept.`department_id`;
-- 内连接 只查询两张表中匹配的记录，任何不匹配的记录都会被过滤掉。
-- 隐式内连接 查询员工信息及其对应的部门信息
SELECT `employee_id`,last_name,`department_name` FROM `employees`,`departments`
WHERE `departments`.`department_id` = `employees`.`department_id`;

-- 显式内连接  表1 inner join 表2  on 条件
SELECT emp.`employee_id`,emp.`last_name`,dept.`department_name` FROM `employees` AS emp INNER JOIN `departments` AS dept
                                                                                                   ON emp.`department_id` = dept.`department_id`;
-- inner关键字可以省略的
SELECT emp.`employee_id`,emp.`last_name`,dept.`department_name` FROM `employees` AS emp JOIN `departments` AS dept
                                                                                             ON emp.`department_id` = dept.`department_id`;

-- 查询员工信息及其对应的部门信息和对应的地址信息
SELECT e.`employee_id`,e.`last_name`,d.`department_name`,l.`city` FROM `employees` AS e JOIN `departments` AS d ON e.`department_id` = d.`department_id`
                                                                                        JOIN `locations` AS l ON l.`location_id` = d.`location_id`;


-- 作业
-- 1. 查询员工的姓名和部门号和年薪，按年薪降序,按姓名升序显示
SELECT
    last_name AS 姓名,
    department_id AS 部门号,
    salary * 12 AS 年薪
FROM employees
ORDER BY 年薪 DESC, 姓名 ASC;

-- 2. 选择工资不在 8000 到 17000 的员工的姓名和工资，按工资降序，显示第21到40位置的数据
SELECT
    last_name AS 姓名,
    salary AS 工资
FROM employees
WHERE salary NOT BETWEEN 8000 AND 17000
ORDER BY 工资 DESC
LIMIT 20 ,20;

-- 3. 查询邮箱中包含 e 的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT
    *
FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC, department_id ASC;

-- 1. 显示所有员工的姓名，部门号和部门名称。
SELECT
    emp.last_name AS 员工姓名,
    emp.department_id AS 部门号,
    dept.department_name AS 部门名称
FROM employees emp
         LEFT JOIN departments dept ON emp.department_id = dept.department_id;

-- 2. 查询90号部门员工的job_id和90号部门的location_id
SELECT
    emp.job_id AS 职位ID,
    dept.location_id AS 位置ID
FROM employees emp
         JOIN departments dept ON emp.department_id = dept.department_id
WHERE dept.department_id = 90;

-- 3. 选择所有有奖金的员工的 last_name , department_name , location_id , city
SELECT
    emp.last_name,
    dept.department_name,
    loc.location_id,
    loc.city
FROM employees emp
         JOIN departments dept ON emp.department_id = dept.department_id
         JOIN locations loc ON dept.location_id = loc.location_id
WHERE emp.commission_pct IS NOT NULL;

-- 4. 选择city在Toronto工作的员工的 last_name , job_id , department_id , department_name
-- 第一种写法:
SELECT
    emp.last_name,
    emp.job_id,
    emp.department_id,
    dept.department_name
FROM employees emp
         JOIN departments dept ON emp.department_id = dept.department_id
         JOIN locations loc ON dept.location_id = loc.location_id
WHERE loc.city = 'Toronto';

-- 第二种写法:
SELECT
    e.last_name,
    e.job_id,
    e.department_id,
    d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.city = 'Toronto';

-- 5. 查询员工所在的部门名称、部门地址、姓名、工作、工资，其中员工所在部门的部门名称为’Executive’
SELECT
    dept.department_name AS 部门名称,
    loc.street_address AS 部门地址, -- 假设地址字段是 street_address
    emp.last_name AS 姓名,
    emp.job_id AS 工作,
    emp.salary AS 工资
FROM employees emp
         JOIN departments dept ON emp.department_id = dept.department_id
         JOIN locations loc ON dept.location_id = loc.location_id
WHERE dept.department_name = 'Executive';

-- 6. 选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
SELECT
    emp.last_name AS 员工姓名,
    emp.employee_id AS 员工号,
    manager.last_name AS 管理者姓名,
    manager.employee_id AS 管理者号
FROM employees emp
         LEFT JOIN employees manager ON emp.manager_id = manager.employee_id;

-- 7. 查询哪些部门没有员工
SELECT
    dept.department_id,
    dept.department_name
FROM departments dept
         LEFT JOIN employees emp ON dept.department_id = emp.department_id
WHERE emp.employee_id IS NULL;

-- 8. 查询哪个城市没有部门
SELECT
    loc.location_id,
    loc.city
FROM locations loc
         LEFT JOIN departments dept ON loc.location_id = dept.location_id
WHERE dept.department_id IS NULL;

-- 9. 查询部门名为 Sales 或 IT 的员工信息
SELECT
    emp.*
FROM employees emp
         JOIN departments dept ON emp.department_id = dept.department_id
WHERE dept.department_name IN ('Sales', 'IT');


