#!/bin/bash
# Script to setup combined audio monitor to stream audio on Discord
# Based on https://wiki.archlinux.org/index.php/PulseAudio/Examples#Mixing_additional_audio_into_the_microphone's_audio

# USAGE:
# Run the script.
# Using pavucontrol:
#   Set Discord to record from "src_main" and output to "sink_main" (WEBRTC VoiceEngine)
#   Set other application(s) to output to "sink_fx"
#
# Run with "-reset" to unload the new audio modules we created

# fname="/tmp/audio_modules.txt"
# 
# if [ "$1" == "-reset" ]; then
#     while read line; do
#         pactl unload-module $line
#         echo "Unloaded module $line"
#     done < $fname
#     exit
# fi

microphone="alsa_input.pci-0000_00_1f.3.analog-stereo"
speakers="alsa_output.pci-0000_00_1f.3.analog-stereo"

echo "Setting up echo cancellation"
pactl load-module module-echo-cancel use_master_format=1 aec_method=webrtc \
      aec_args="analog_gain_control=0\\ digital_gain_control=1\\ experimental_agc=1\\ noise_suppression=1\\ voice_detection=1\\ extended_filter=1" \
      source_master="$microphone" source_name=src_ec  source_properties=device.description=src_ec \
      sink_master="$speakers"     sink_name=sink_main sink_properties=device.description=sink_main

echo "Creating virtual output devices"
pactl load-module module-null-sink sink_name=sink_fx  sink_properties=device.description=sink_fx
pactl load-module module-null-sink sink_name=sink_mix sink_properties=device.description=sink_mix

echo "Creating remaps"
pactl load-module module-remap-source master=sink_mix.monitor \
      source_name=src_main source_properties="device.description=src_main"

echo "Setting default devices"
pactl set-default-source src_main
pactl set-default-sink   sink_main

echo "Creating loopbacks"
pactl load-module module-loopback latency_msec=60 adjust_time=6 source=src_ec          sink=sink_mix
pactl load-module module-loopback latency_msec=60 adjust_time=6 source=sink_fx.monitor sink=sink_mix
pactl load-module module-loopback latency_msec=60 adjust_time=6 source=sink_fx.monitor sink=sink_main

# echo "Setting up echo cancellation"
# NUM=$(pactl load-module module-echo-cancel use_master_format=1 aec_method=webrtc aec_args="analog_gain_control=0\\ digital_gain_control=1\\ experimental_agc=1\\ noise_suppression=1\\ voice_detection=1\\ extended_filter=1" source_master="$microphone" source_name=src_ec  source_properties=device.description=src_ec sink_master="$speakers" sink_name=sink_main sink_properties=device.description=sink_main)
# echo $NUM | tee $fname
# 
# echo "Creating virtual output devices"
# NUM=$(pactl load-module module-null-sink sink_name=sink_fx
# sink_properties=device.description=sink_fx)
# echo $NUM | tee -a $fname
# 
# NUM=$(pactl load-module module-null-sink sink_name=sink_mix
# sink_properties=device.description=sink_mix)
# echo $NUM | tee -a $fname
# 
# echo "Creating remaps"
# NUM=$(pactl load-module module-remap-source master=sink_mix.monitor source_name=src_main source_properties="device.description=src_main")
# echo $NUM | tee -a $fname
# 
# echo "Setting default devices"
# pactl set-default-source src_main
# pactl set-default-sink   sink_main
# 
# echo "Creating loopbacks"
# NUM=$(pactl load-module module-loopback latency_msec=60 adjust_time=6 source=src_ec sink=sink_mix)
# echo $NUM | tee -a $fname
# NUM=$(pactl load-module module-loopback latency_msec=60 adjust_time=6
# source=sink_fx.monitor sink=sink_mix)
# echo $NUM | tee -a $fname
# NUM=$(pactl load-module module-loopback latency_msec=60 adjust_time=6
# source=sink_fx.monitor sink=sink_main)
# echo $NUM | tee -a $fname
