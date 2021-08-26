/** Template RTOS V2.1 */
#include "stm32f0xx.h"
#include <stdint.h>
#include "app_bsp.h"
#include "app_utils.h"
#include "FreeRTOS.h"
#include "task.h"

static void vTask( void *parameters );

/**------------------------------------------------------------------------------------------------
Brief.- Punto de entrada del programa
-------------------------------------------------------------------------------------------------*/
int main( void )
{
    vSetupHardware( );
    
    xTaskCreate( vTask, "Task", 128u, NULL, 1u, NULL );
    
    vTaskStartScheduler( );
    vPrintString( "ERROR" );
    return 0u;
}

static void vTask( void *parameters )
{
    for( ; ; )
    {
        vPrintString( "Hola mundo" );
        vDelay( 1000u );
    }
}

/**------------------------------------------------------------------------------------------------
Brief.- general puorpse ISR vector, in reality this is the TSC interrupt vector but for didacting 
        pourpose is renamed
-------------------------------------------------------------------------------------------------*/
void vInterruptHandler( void )
{

}

/**------------------------------------------------------------------------------------------------
Brief.- general pourpse ISR callback, this is not an ISR vector, is just the callback placed in the
        real vector which is the HAL_GPIO_EXTI_IRQHandler. it is renamed for didactic pourpose
-------------------------------------------------------------------------------------------------*/
void vInterruptButton( uint16_t GPIO_Pin )
{
    
}

/**------------------------------------------------------------------------------------------------
Brief.- Clock alarm ISR callback, this is not an ISR vector, is just the callback placed in the
        real vector which is the RTC_IRQHandler. it is renamed for didactic pourpose
        This fucntion is called everytime the clock time match the alarm value
-------------------------------------------------------------------------------------------------*/
void vInterruptAlarm( RTC_HandleTypeDef *hrtc )
{
    
}

/**------------------------------------------------------------------------------------------------
Brief.- Uart reception ISR callback, this is not an ISR vector, is just the callback placed in the
        real vector which is the RTC_IRQHandler. it is renamed for didactic pourpose
        This function is called every time a single byte is received.
        To access the received byte just call the function xSerialReceiveFromISR()
-------------------------------------------------------------------------------------------------*/
void vInterruptSerialRx( UART_HandleTypeDef *huart )
{

}
