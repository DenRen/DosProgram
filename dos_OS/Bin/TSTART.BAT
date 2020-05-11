echo off

tasm /la /m code.asm
tlink /t code.obj

cd /bin/td/
td ../code.com
cd /bin

echo on