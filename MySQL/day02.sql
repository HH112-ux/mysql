
SELECT employee_id,last_name,salary*12  "ANNUAL SALARY" FROM employees;
SELECT employee_id,last_name,salary*12*(1 + IFNULL(commission_pct,0))  "ANNUAL SALARY" FROM employees;
SELECT DISTINCT job_id FROM employees;
SELECT last_name,salary FROM employees WHERE salary > 12000;
SELECT last_name,department_id FROM employees WHERE employee_id = 176;
DESC departments;
SELECT * FROM departments;

SELECT first_name, last_name, salary FROM employees WHERE salary NOT BETWEEN 5000 AND 12000;
SELECT first_name, last_name, department_id FROM employees WHERE department_id IN (20, 50);
SELECT first_name, last_name, job_id FROM employees WHERE manager_id IS NULL;
SELECT first_name, last_name, salary, commission_pct FROM employees WHERE commission_pct IS NOT NULL;
SELECT first_name, last_name FROM employees WHERE first_name LIKE '__a%';
SELECT first_name, last_name FROM employees WHERE first_name LIKE '%a%' AND first_name LIKE '%k%';
SELECT *FROM employees WHERE first_name LIKE '%e';
SELECT first_name, last_name, job_id FROM employees WHERE department_id BETWEEN 80 AND 100;
SELECT first_name, last_name, salary, manager_id FROM employees WHERE manager_id IN (100, 101, 110);