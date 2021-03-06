# Category=HVAC

$v_test_thermostat = new Voice_Cmd("Send Thermostat cmd [ping,poll_mode,mode_off,mode_heat,mode_cool,mode_auto,mode_pgm_heat,mode_pgm_cool,mode_pgm_auto,fan_on,fan_auto,poll_temp,poll_setpoint]");

# Create the Object in user code:
#use Insteon_Thermostat;
#$thermostat = new Insteon_Thermostat($plm,'12.34.56');

# or in items.mht (read_table_A)
#IPLT, 12.34.56,, thermostat, HVAC, plm

# poll_setpoint also runs poll_mode
if ($Startup || $Reload) {
   $thermostat->poll_setpoint();
}

# Poll the temp.
if ( new_minute(5) && $Hour != 2 ) { # Skip the ALDB scanning hour
   $thermostat->poll_temp();
}

# Do stuff on temp_change
if (my $state = state_now $thermostat) {
   print_log("[HVAC] Got new thermostat state: $state");
   if ($state eq 'temp_change') {
      print_log("[HVAC] Thermostat temp_change to " . $thermostat->get_temp);
   }
}


if (my $state = said $v_test_thermostat) {
   if ($state eq 'ping') {
      $thermostat->ping();
   }elsif ($state eq 'poll_mode') {
      $thermostat->poll_mode();
   }elsif ($state eq 'poll_temp') {
      $thermostat->poll_temp();
   }elsif ($state eq 'poll_setpoint') {
      $thermostat->poll_setpoint();
   }elsif ($state eq 'mode_off') {
      $thermostat->mode('off');
   }elsif ($state eq 'mode_heat') {
      $thermostat->mode('heat');
   }elsif ($state eq 'mode_cool') {
      $thermostat->mode('cool');
   }elsif ($state eq 'mode_auto') {
      $thermostat->mode('auto');
   }elsif ($state eq 'mode_pgm_heat') {
      $thermostat->mode('program_heat');
   }elsif ($state eq 'mode_pgm_cool') {
      $thermostat->mode('program_cool');
   }elsif ($state eq 'mode_pgm_auto') {
      $thermostat->mode('program_auto');
   }elsif ($state eq 'fan_on') {
      $thermostat->fan('on');
   }elsif ($state eq 'fan_auto') {
      $thermostat->fan('auto');
   } else {
      print_log('[hvac.pl] Uknown state from said v_test_thermostat');
   }
}

$v_get_thermostat_info = new Voice_Cmd('Get thermostat info');

if (said $v_get_thermostat_info) {
   print_log("Thermostat mode: ". $thermostat->get_mode);
   print_log("Thermostat temperature: ". $thermostat->get_temp);
   print_log("Thermostat heat setpoint: ". $thermostat->get_heat_sp);
   print_log("Thermostat cool setpoint: ". $thermostat->get_cool_sp);
}

$v_set_normal_setpoints = new Voice_Cmd('Set thermostat normal setpoints');
if (said $v_set_normal_setpoints) {
   $thermostat->mode('auto');
   $thermostat->heat_setpoint(73);
   $thermostat->cool_setpoint(77);
   $thermostat->poll_setpoint();
}   
$v_set_nighttime_setpoints = new Voice_Cmd('Set thermostat nighttime setpoints');
if (said $v_set_nighttime_setpoints) {
   $thermostat->mode('auto');
   $thermostat->heat_setpoint(70);
   $thermostat->cool_setpoint(75);
   $thermostat->poll_setpoint();
}   
$v_set_conserve_setpoints = new Voice_Cmd('Set thermostat conserve setpoints');
if (said $v_set_conserve_setpoints) {
   $thermostat->mode('auto');
   $thermostat->heat_setpoint(66);
   $thermostat->cool_setpoint(82);
   $thermostat->poll_setpoint();
}   
