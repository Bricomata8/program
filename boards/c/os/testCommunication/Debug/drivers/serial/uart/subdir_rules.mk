################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

# Each subdirectory must supply rules for building sources it contributes
drivers/serial/uart/uart.obj: ../drivers/serial/uart/uart.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: MSP430 Compiler'
	"C:/ti/ccsv7/tools/compiler/ti-cgt-msp430_16.9.3.LTS/bin/cl430" -vmsp --use_hw_mpy=16 --include_path="C:/ti/ccsv7/ccs_base/msp430/include" --include_path="Z:/PowTest1/testCommunication" --include_path="C:/ti/ccsv7/tools/compiler/ti-cgt-msp430_16.9.3.LTS/include" --advice:power=all --define=__MSP430F1612__ -g --printf_support=minimal --diag_warning=225 --diag_wrap=off --display_error_number --preproc_with_compile --preproc_dependency="drivers/serial/uart/uart.d" --obj_directory="drivers/serial/uart" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


