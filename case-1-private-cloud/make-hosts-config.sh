#!/bin/bash
cat << EOF > hosts-config.ini
[case1_app]
$1

[case1_db]
$2
EOF
