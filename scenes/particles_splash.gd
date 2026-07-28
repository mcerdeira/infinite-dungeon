extends Node2D
var mini = false

func _emit():
	if mini:
		$GPUParticles2D4.emitting = true
	else:
		$GPUParticles2D.emitting = true
		$GPUParticles2D2.emitting = true
		$GPUParticles2D3.emitting = true
		$GPUParticles2D4.emitting = true

func _on_gpu_particles_2d_4_finished() -> void:
	queue_free()
