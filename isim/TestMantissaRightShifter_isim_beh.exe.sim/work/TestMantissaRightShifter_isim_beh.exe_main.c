/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *STD_STANDARD;
char *IEEE_P_2592010699;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    work_a_3058044882_3212880686_init();
    work_a_3078907365_3212880686_init();
    work_a_3049446332_3212880686_init();
    work_a_3019944331_3212880686_init();
    work_a_2974787342_3212880686_init();
    work_a_2962083129_3212880686_init();
    work_a_2999677792_3212880686_init();
    work_a_3003717975_3212880686_init();
    work_a_3092602474_3212880686_init();
    work_a_3113694301_3212880686_init();
    work_a_1819220383_3212880686_init();
    work_a_1840083880_3212880686_init();
    work_a_1877724657_3212880686_init();
    work_a_1848223686_3212880686_init();
    work_a_1801892163_3212880686_init();
    work_a_1789188980_3212880686_init();
    work_a_1759667501_3212880686_init();
    work_a_1763708698_3212880686_init();
    work_a_1652312103_3212880686_init();
    work_a_1673404944_3212880686_init();
    work_a_2128262769_3212880686_init();
    work_a_2132335686_3212880686_init();
    work_a_2103337503_3212880686_init();
    work_a_4143380455_3212880686_init();
    work_a_0876153047_2372691052_init();


    xsi_register_tops("work_a_0876153047_2372691052");

    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);

    return xsi_run_simulation(argc, argv);

}
