# 1.显示系统时间
SELECT NOW() AS system_time
FROM DUAL;

# 2.查询员工号，姓名，工资，以及工资提高百分之20%后
SELECT employee_id, last_name, salary, salary * 1.2 AS "new salary"
FROM employees;
# 3.将员工的姓名按首字母排序，并写出姓名的长度
SELECT last_name, CHAR_LENGTH(last_name) AS name_length
FROM employees ORDER BY LEFT(last_name, 1);

# 4.查询员工id,last_name,salary
SELECT CONCAT(employee_id, ',', last_name, ',', salary)
    AS OUT_PUT
FROM employees;

# 5.查询公司各员工工作的年数、工作的天数，并按工作年数的降序排序
SELECT last_name,
       DATEDIFF(CURDATE(), hire_date) / 365 AS years_worked,
       DATEDIFF(CURDATE(), hire_date) AS days_worked
FROM employees
ORDER BY years_worked DESC;
# 6.查询员工姓名，hire_date , department_id
SELECT last_name, hire_date, department_id
FROM employees
WHERE YEAR(hire_date) > 1997
  AND department_id IN (80, 90, 110)
  AND commission_pct IS NOT NULL;

# 7.查询公司中入职超过10000天的员工姓名、入职时间
SELECT last_name, hire_date
FROM employees
WHERE DATEDIFF(CURDATE(), hire_date) > 10000;

# 8.做一个查询，产生下面的结果
#<last_name> earns <salary> monthly but wants <salary*3>
SELECT CONCAT(last_name, ' earns ', salary, ' monthly but wants ', salary * 3) AS "Dream Salary"
FROM employees;

# 9.使用case-when，按照下面的条件：
/*
job_id                 grade
AD_PRES              	A
ST_MAN               	B
IT_PROG              	C
SA_REP               	D
ST_CLERK             	E
*/
SELECT last_name, job_id,
       CASE job_id
           WHEN 'AD_PRES' THEN 'A'
           WHEN 'ST_MAN' THEN 'B'
           WHEN 'IT_PROG' THEN 'C'
           WHEN 'SA_REP' THEN 'D'
           WHEN 'ST_CLERK' THEN 'E'
           ELSE 'Unknown'
           END AS grade
FROM employees;
### 2 聚合函数练习题
#1.where子句可否使用组函数进行过滤?
# 不可以

#2.查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees;

#3.查询各job_id的员工工资的最大值，最小值，平均值，总和
SELECT job_id, MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees
GROUP BY job_id;

#4.选择具有各个job_id的员工人数
SELECT job_id, COUNT(*) AS employee_count
FROM employees
GROUP BY job_id;
# 5.查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT MAX(salary) - MIN(salary) AS DIFFERENCE
FROM employees;
# 6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT manager_id, MIN(salary) AS min_salary
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;

# 7.查询所有部门的名字，location_id，员工数量和平均工资，并按平均工资降序
SELECT d.department_name, d.location_id, COUNT(e.employee_id) AS employee_count, AVG(e.salary) AS avg_salary
FROM departments d
         LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name, d.location_id
ORDER BY avg_salary DESC;

# 8.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT d.department_name, e.job_id, MIN(e.salary) AS min_salary
FROM employees e
         JOIN departments d ON e.department_id = d.department_id
GROUP BY e.job_id, e.department_id;