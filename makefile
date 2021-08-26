#Nombre del proyecto
TARGET = temp
#Archivos a compilar
SRCS  = main.c app_ints.c app_msps.c app_utils.c startup_stm32f070xb.s system_stm32f0xx.c
SRCS += list.c tasks.c queue.c timers.c port.c heap_1.c
SRCS += SEGGER_SYSVIEW.c SEGGER_RTT.c SEGGER_SYSVIEW_Conf.c SEGGER_SYSVIEW_FreeRTOS.c SEGGER_RTT_printf.c
SRCS += stm32f0xx_hal.c stm32f0xx_hal_cortex.c stm32f0xx_hal_pwr.c stm32f0xx_hal_rcc.c stm32f0xx_hal_rcc_ex.c stm32f0xx_hal_flash.c
SRCS += stm32f0xx_hal_gpio.c stm32f0xx_hal_uart.c stm32f0xx_hal_uart_ex.c stm32f0xx_hal_dma.c stm32f0xx_hal_rtc.c stm32f0xx_hal_wwdg.c
#archivo linker a usar
LINKER = linker.ld
#Simbolos globales del programa (#defines globales)
SYMBOLS = -DSTM32F070xB -DUSE_HAL_DRIVER
#directorios con archivos a compilar (.c y .s)
SRC_PATHS  = app
SRC_PATHS += cmsisf0/startups
SRC_PATHS += half0/Src
SRC_PATHS += rtos/source
SRC_PATHS += rtos/MemMang
SRC_PATHS += rtos/portable/ARM_CM0
SRC_PATHS += sysview/Config
SRC_PATHS += sysview/OS
SRC_PATHS += sysview/SEGGER
#direcotrios con archivos .h
INC_PATHS  = app
INC_PATHS += app/config
INC_PATHS += cmsisf0/core
INC_PATHS += cmsisf0/registers
INC_PATHS += half0/Inc
INC_PATHS += rtos/include
INC_PATHS += rtos/portable/ARM_CM0
INC_PATHS += sysview/Config
INC_PATHS += sysview/OS
INC_PATHS += sysview/SEGGER

#compilador y opciones de compilacion
TOOLCHAIN = arm-none-eabi
CPU = -mcpu=cortex-m0 -mthumb -mfloat-abi=soft
CFLAGS  = $(CPU) -Wall -g3 -Os -std=c99
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -MMD -MP
AFLAGS = $(CPU)
LFLAGS = $(CPU) -Wl,--gc-sections --specs=rdimon.specs --specs=nano.specs -Wl,-Map=Build/$(TARGET).map

#automate strign substitution and prefix added
OBJS  := $(SRCS:%.c=Build/obj/%.o)
OBJS  := $(OBJS:%.s=Build/obj/%.o)
DEPS  = $(OBJS:%.o=%.d)
VPATH = $(SRC_PATHS)
INCS  =  $(addprefix -I, $(INC_PATHS))

#Instrucciones de compilacion
all : build $(TARGET)

$(TARGET) : $(addprefix Build/, $(TARGET).elf)
	$(TOOLCHAIN)-objcopy -Oihex $< Build/$(TARGET).hex
	$(TOOLCHAIN)-objdump -S $< > Build/$(TARGET).lst
	$(TOOLCHAIN)-size --format=berkeley $<

Build/$(TARGET).elf : $(OBJS)
	$(TOOLCHAIN)-gcc $(LFLAGS) -T $(LINKER) -o $@ $^

Build/obj/%.o : %.c
	$(TOOLCHAIN)-gcc $(CFLAGS) $(INCS) $(SYMBOLS) -o $@ -c $<

Build/obj/%.o : %.s
	$(TOOLCHAIN)-as $(AFLAGS) -o $@ -c $<

build:
	mkdir -p Build/obj

#resolve dependencies
-include $(DEPS)

#borrar archivos generados
clean :
	rm -rf Build

#RTT viewver to viuasualize print functions output 
terminal :
	JLinkRTTClient

#Programar al tarjeta
flash :
	openocd -f interface/jlink.cfg -c "transport select swd" -f target/stm32f0x.cfg -c "program Build/$(TARGET).hex verify reset" -c shutdown

#Conectar OpenOCD con al Tarjeta
open :
	JLinkGDBServer -if SWD -device $(MCU) -nogui

#Lanzar sesion de debug (es necesario primero Conectar la tarjeta con JLinkGDBServer)
debug :
	$(TOOLSET)-gdb Build/$(PROJECT).elf -iex "set auto-load safe-path /" -iex "target remote localhost:2331"

