CREATE USER 'hpsa'@'localhost' IDENTIFIED BY 'demo';
GRANT ALL ON hpsa_demo.* TO 'hpsa'@'%' IDENTIFIED BY 'demo';
