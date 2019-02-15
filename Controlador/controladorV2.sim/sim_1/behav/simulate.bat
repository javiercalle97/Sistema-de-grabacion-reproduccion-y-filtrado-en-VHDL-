@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim fir_filter_tb2secuencia_behav -key {Behavioral:sim_1:Functional:fir_filter_tb2secuencia} -tclbatch fir_filter_tb2secuencia.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
