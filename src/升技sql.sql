

SELECT a.username,


a01 = (SELECT c_keytitle FROM t_key WHERE n_keyid = (SELECT top 1 b.n_keyid  FROM t_result b WHERE b.username = a.username AND b.n_subid = '95')),
a02 = (SELECT c_keytitle FROM t_key WHERE n_keyid = (SELECT top 1 b.n_keyid  FROM t_result b WHERE b.username = a.username AND b.n_subid = '96')),
a03 = (SELECT c_keytitle FROM t_key WHERE n_keyid = (SELECT top 1 b.n_keyid  FROM t_result b WHERE b.username = a.username AND b.n_subid = '97')),
a04 = (SELECT c_keytitle FROM t_key WHERE n_keyid = (SELECT top 1 b.n_keyid  FROM t_result b WHERE b.username = a.username AND b.n_subid = '98')),
a05 = (SELECT c_keytitle FROM t_key WHERE n_keyid = (SELECT top 1 b.n_keyid  FROM t_result b WHERE b.username = a.username AND b.n_subid = '99')),

 a.c_reuslt





FROM t_result a

WHERE a.n_keyid = '392' ORDER BY username


