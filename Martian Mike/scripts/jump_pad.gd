extends Area2D


func _on_body_entered(body):
	if body is Player:
		AudioPlayer.play_sfx("jump")
		body.velocity.y = -300
		$AnimatedSprite2D.play("jump")
