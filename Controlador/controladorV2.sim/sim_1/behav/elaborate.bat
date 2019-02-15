@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 885f208b721543d992bc05edee3a27f7 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot fir_filter_tb2secuencia_behav xil_defaultlib.fir_filter_tb2secuencia -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
