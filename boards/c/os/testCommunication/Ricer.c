/*
 * Ricer.c
 *
 *  Created on: 30 avr. 2018
 *      Author: djidi
 */


#include <network/mac/pw-mac/pw-mac.h>
#include <drivers/radio/cc112x.h>
//#include <drivers/wurx/wurx.h>
#include <tools/timer/timer.h>
#include <stddef.h>
#include <string.h>
#include <config.h>
#include <stdlib.h>
#include <stdbool.h>
#include "stdint.h"
#include <pt/pt.h>
#include <tools/misc.h>


#define SOURCE
//#define SINK

// Frames Types (2 bits)
#define BCN         0b00000000u
#define ACK         0b01000000u
#define DATA        0b10000000u
#define NACK        0b11000000u // Failure ACK
#define DATAS       0b00100000u // Data with sync request
#define ACKS        0b01100000u // ACK with sync information

/*
 * Convert the time unit used by CC112X RX timer to slow rate MCU timer
 */
//#define TIME_CONV_CC112X_TO_SLOW(x) (x / 400)

struct nack_frame
{
    uint8   type;   // Type
    uint16  bw;     // Backoff window
};

struct acks_frame
{
    uint8   misc;           // Type + SEQ
    uint32  current_time;   // Sink time
};

// Frame length
#define BCN_SIZE    1u
#define ACK_SIZE    1u
#define NACK_SIZE   sizeof(struct nack_frame)
#define ACKS_SIZE   sizeof(struct acks_frame)

/***********************************************************************
 Fifo variable: shared with the ap threads*/

struct fifo_pkt_t tx_fifo[TX_FIFO_SIZE];
struct fifo_pkt_t rx_fifo[RX_FIFO_SIZE];

uint8 tx_fifo_first =0u;
uint8 tx_fifo_last=0u;
uint8 rx_fifo_first=0u;
uint8 rx_fifo_last=0u;

//************************************************************************

//priviate variables
//thread to schedule when the RX FIFO is not empty
static struct pt *_rx_fifo_cons;


//sendung thread

static struct pt _sender_thread_pt;


//receiving thread

static struct pt _recv_thread_pt;

/************************************************************************
 //sender thread*/


static PT_THREAD (sender_thread(void *args))

  {


    uint8 r,buf[PKT_SIZE+2], length, adress, type, retry=0u;

    PT_BEGIN (&_sender_thread_pt);


    for ( ;; ){

        cc112x_sleep();
        WAIT_EVENT (&_sender_thread_pt);

        //attendre periodic timer

        // wait for the beacon :)

      //  r=cc112x_rx_pkt(buf, &length, &adress, true);

      do{
            r=cc112x_rx_pkt(buf, &length, &adress, true);
            type =buf [0];

        }  while ((r != RXPKT_SUCCESS) && (type != BCN));

        uart_puts("beacon was received\n\r");
        }

    PT_END(&_sender_thread_pt);

    }




/*************************************************************************
 //receiver thread*/



static PT_THREAD (recv_thread(void*args))
        {

    uint8 r,misc, length, adress, type, retry=0;

    PT_BEGIN (&_recv_thread_pt);

    for ( ;; ){

        cc112x_sleep();
        WAIT_EVENT (&_recv_thread_pt);

        //time to send beacon :)
       // cc112x_wub_mode();
        // cca should be enable but i disable it because of a problem in the lab
        //cc112x_set_cca(CCA_RSSI);
        cc112x_set_cca(CCA_NO);

        misc=BCN; //No seq for BCN

       r= cc112x_tx_pkt (&misc, BCN_SIZE, BROADCAST_ADDRESS);
       //r = cc112x_tx_wub(misc);
        if (r!=TXPKT_SUCCESS){

            uart_puts("beacon was not sent\n\r");
            //continue;
        }

        else {
            uart_puts("beacon was sent\n\r");}



       // If the RX fifo is not empty, the RX FIFO consummer thread is scheduled
              if (!FIFO_IS_EMPTY(rx_fifo_first, rx_fifo_last)) {
                  schedule_thread(_rx_fifo_cons, true);
              }
    }


    PT_END(&_recv_thread_pt);

        }


/***************************************************************************************************
 *Initialize the MAC protocol
 */


void ricer_init(struct pt *rx_fifo_cons)
{
    _rx_fifo_cons = rx_fifo_cons;

    // initialiser uart

    uart_init();

    // Initalizes the CC1120
    cc112x_init(2u);

    // Enable the device address filtering and set the device address
    cc112x_set_addr_check(ADDR_CHK_B1, SELF_MAC_ADDRESS);

    // Putting radio chip in sleep state
    cc112x_sleep();

    // Initializing the sender thread

    if (rx_fifo_cons == NULL) {
    PT_INIT(&_sender_thread_pt, sender_thread, NULL);
    register_thread(&_sender_thread_pt, true);
    set_periodic_timer(&_recv_thread_pt, RCV_WAKEUP_INTERVAL);
    }
    // Initializing the sender thread only of a receving thread is specified
    else {
        PT_INIT(&_recv_thread_pt, recv_thread, NULL);
        register_thread(&_recv_thread_pt, true);
        set_periodic_timer(&_recv_thread_pt, RCV_WAKEUP_INTERVAL);
    }
}


/*************************************************************************************************
 * main
 */
static struct pt sink_thread_pt;
void main (void){

    msp2zigv_init();
    WDT_DISABLE;
    timer_init();
    _EINT();
    spi_init();
#ifdef SOURCE

    ricer_init (NULL);
    start_threads();

#elif  defined SINK

    ricer_init (&sink_thread_pt);
    start_threads ();

#endif
}
