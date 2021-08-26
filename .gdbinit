#---gdb settings
set pagination off
set confirm off
set verbose off
set height 0
set width 0

#---connect and load program
#target remote localhost:3333 #openocd
#target remote localhost:2331 #jlink
#mon arm semihosting enable #openocd
#mon semihosting enable #jlink
#mon reset
#load
#break main
#continue


define reset
    mon reset halt
end


