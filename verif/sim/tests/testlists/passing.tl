REGRESS_OPTIONS {
}

pcounter_test_irq_wait_for_trans_by_signame -pass_pattern='Qgpio Response :: \(Time: 1000 ns\) Signal: :: Value:         88'
pcounter_test_irq_wait_for_trans_by_sigloc  -pass_pattern='Qgpio Response :: \(Time: 2220 ns\) Signal: :: Value:         28'
pcounter_test_irq_wait_for_next_trans       -pass_pattern='Qgpio Response :: \(Time: 1420 ns\) Signal: :: Value:         39'
pcounter_test_irq_wait_for_value_by_signame  -pass_pattern='Qgpio Response :: \(Time: 800 ns\) Signal: :: Value:         68'
pcounter_test_irq_wait_for_value_by_sigloc -pass_pattern='Qgpio Response :: \(Time: 800 ns\) Signal: :: Value:         68'
pcounter_test_irq_wait_for_next_value -pass_pattern='Qgpio Response :: \(Time: 810 ns\) Signal: :: Value:         69'
pcounter_test_gpio_get_value_by_sigloc_sequential -pass_pattern='Qgpio Response :: \(Time: 400 ns\) Signal: :: Value:         28'
pcounter_test_gpio_get_value_by_signame_parallel -pass_pattern='Qgpio Response :: \(Time: 400 ns\) Signal: :: Value:         28'
pcounter_test_gpio_set_value_by_sigloc_sequential -pass_pattern='Qgpio Response :: \(Time: 1510 ns\) Signal: :: Value:         32'
pcounter_test_gpio_set_value_by_signame_parallel -pass_pattern='Qgpio Response :: \(Time: 2020 ns\) Signal: :: Value:         34'
pcounter_test_qclk_change_clock_period -pass_pattern='Qgpio Response :: \(Time: 9455 ns\) Signal: :: Value:         67'
pcounter_test_qclk_change_clock_gating -pass_pattern='Qgpio Response :: \(Time: 3300 ns\) Signal: :: Value:         27'

