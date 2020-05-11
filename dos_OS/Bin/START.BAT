echo off

tasm /la /m code.asm
tlink /t code.obj
code.com

echo on