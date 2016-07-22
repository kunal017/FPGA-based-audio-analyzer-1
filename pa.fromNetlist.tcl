
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name audio_process -dir "C:/Users/Mudit-PC/Downloads/audio_process_final/audio_process/planAhead_run_3" -part xc3s500efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Mudit-PC/Downloads/audio_process_final/audio_process/audio_process.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Mudit-PC/Downloads/audio_process_final/audio_process} {ipcore_dir} }
add_files [list {ipcore_dir/fft_core.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "ucf_file.ucf" [current_fileset -constrset]
add_files [list {ucf_file.ucf}] -fileset [get_property constrset [current_run]]
link_design
