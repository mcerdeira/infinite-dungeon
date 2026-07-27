extends Node2D

func _emit():
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$GPUParticles2D4.emitting = true

func _on_gpu_particles_2d_4_finished() -> void:
	return
	queue_free()
