-- 1. Cleanup
DROP TABLE IF EXISTS employees CASCADE;

-- 2. Schema Creation
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    hire_date DATE NOT NULL,
    city VARCHAR(50) NOT NULL,
    is_remote BOOLEAN DEFAULT false
);

-- 3. Data Insertion (25 Rows)
INSERT INTO employees (first_name, last_name, email, department, job_title, salary, hire_date, city, is_remote) VALUES
('Alice', 'Smith', 'alice.smith@techcorp.com', 'Engineering', 'Backend Developer', 85000.00, '2021-03-15', 'New York', true),
('Bob', 'Jones', 'bob.jones@techcorp.com', 'Engineering', 'Frontend Developer', 78000.00, '2022-06-01', 'Chicago', false),
('Charlie', 'Brown', 'charlie.brown@techcorp.com', 'Marketing', 'SEO Specialist', 62000.00, '2020-01-10', 'New York', true),
('Diana', 'Prince', 'diana.prince@techcorp.com', 'Human Resources', 'HR Manager', 75000.00, '2019-11-20', 'Austin', false),
('Ethan', 'Hunt', 'ethan.hunt@techcorp.com', 'Sales', 'Account Executive', 68000.00, '2023-02-14', 'Chicago', true),
('Fiona', 'Gallagher', 'fiona.gallagher@techcorp.com', 'Engineering', 'DevOps Engineer', 92000.00, '2020-08-05', 'Austin', false),
('George', 'Clark', 'george.clark@techcorp.com', 'Finance', 'Financial Analyst', 71000.00, '2021-10-11', 'New York', false),
('Hannah', 'Abbott', 'hannah.abbott@techcorp.com', 'Engineering', 'QA Engineer', 65000.00, '2022-09-01', 'Chicago', true),
('Ian', 'Malcolm', 'ian.malcolm@techcorp.com', 'Data', 'Data Scientist', 98000.00, '2018-05-23', 'Austin', true),
('Julia', 'Roberts', 'julia.roberts@techcorp.com', 'Marketing', 'Content Strategist', 59000.00, '2023-01-09', 'New York', false),
('Kevin', 'Bacon', 'kevin.bacon@techcorp.com', 'Sales', 'Sales Director', 115000.00, '2017-04-18', 'Chicago', false),
('Laura', 'Croft', 'laura.croft@techcorp.com', 'Engineering', 'Security Specialist', 91000.00, '2021-12-01', 'Austin', true),
('Michael', 'Scott', 'michael.scott@techcorp.com', 'Sales', 'Regional Manager', 82000.00, '2016-03-01', 'Scranton', false),
('Nina', 'Williams', 'nina.williams@techcorp.com', 'Data', 'Data Engineer', 89000.00, '2022-03-15', 'New York', true),
('Oscar', 'Martinez', 'oscar.martinez@techcorp.com', 'Finance', 'Senior Accountant', 76000.00, '2018-09-10', 'Scranton', false),
('Pam', 'Beesly', 'pam.beesly@techcorp.com', 'Human Resources', 'HR Assistant', 48000.00, '2020-05-12', 'Scranton', false),
('Quentin', 'Tarantino', 'quentin.tarantino@techcorp.com', 'Marketing', 'Video Producer', 67000.00, '2021-07-19', 'Austin', true),
('Rachel', 'Green', 'rachel.green@techcorp.com', 'Sales', 'Account Executive', 64000.00, '2022-11-01', 'New York', false),
('Steve', 'Rogers', 'steve.rogers@techcorp.com', 'Engineering', 'Engineering Manager', 125000.00, '2015-06-15', 'New York', false),
('Tony', 'Stark', 'tony.stark@techcorp.com', 'Engineering', 'Principal Architect', 145000.00, '2014-01-01', 'Austin', true),
('Ulysses', 'Grant', 'ulysses.grant@techcorp.com', 'Finance', 'Finance Director', 11000.000, '2019-02-28', 'Chicago', false),
('Victoria', 'Secret', 'victoria.secret@techcorp.com', 'Marketing', 'Marketing Manager', 83000.00, '2020-10-05', 'Austin', true),
('Walter', 'White', 'walter.white@techcorp.com', 'Data', 'Data Analyst', 72000.00, '2023-04-03', 'Chicago', false),
('Xena', 'Warrior', 'xena.warrior@techcorp.com', 'Human Resources', 'Recruiter', 55000.00, '2022-08-15', 'New York', true),
('Yusuf', 'Islam', 'yusuf.islam@techcorp.com', 'Sales', 'Sales Associate', 51000.00, '2023-06-20', 'Austin', false);

