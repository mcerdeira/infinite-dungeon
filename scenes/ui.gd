extends Control

func calc_flask():
	$flask.frame = Global.FLASK

func _physics_process(delta: float) -> void:
	$lbl_debug.text = str(Global.player_posision)
	
func got_homing():
	$arrow1.animation = "homing"
	$arrow2.animation = "homing"
	$arrow3.animation = "homing"
	$arrow4.animation = "homing"
	$arrow5.animation = "homing"
	$arrow6.animation = "homing"

func got_bomb():
	$arrow1.animation = "bomb"
	$arrow2.animation = "bomb"
	$arrow3.animation = "bomb"
	$arrow4.animation = "bomb"
	$arrow5.animation = "bomb"
	$arrow6.animation = "bomb"

func calc_life():
	if Global.LIFE == 6:
		$heart1.frame = 0
		$heart2.frame = 0
		$heart3.frame = 0
	elif Global.LIFE == 5:
		$heart1.frame = 0
		$heart2.frame = 0
		$heart3.frame = 1
	elif Global.LIFE == 4:
		$heart1.frame = 0
		$heart2.frame = 0
		$heart3.frame = 2
	elif Global.LIFE == 3:
		$heart1.frame = 0
		$heart2.frame = 1
		$heart3.frame = 2
	elif Global.LIFE == 2:
		$heart1.frame = 0
		$heart2.frame = 2
		$heart3.frame = 2
	elif Global.LIFE == 1:
		$heart1.frame = 1
		$heart2.frame = 2
		$heart3.frame = 2
	elif Global.LIFE == 0:
		$heart1.frame = 2
		$heart2.frame = 2
		$heart3.frame = 2
		
func calc_arrows():
	$lbl_more.visible = false
	if Global.ARROWS == 0:
		$arrow1.frame = 1
		$arrow2.frame = 1
		$arrow3.frame = 1
		$arrow4.frame = 1
		$arrow5.frame = 1
		$arrow6.frame = 1
	elif Global.ARROWS == 1:
		$arrow1.frame = 0
		$arrow2.frame = 1
		$arrow3.frame = 1
		$arrow4.frame = 1
		$arrow5.frame = 1
		$arrow6.frame = 1
	elif Global.ARROWS == 2:
		$arrow1.frame = 0
		$arrow2.frame = 0
		$arrow3.frame = 1
		$arrow4.frame = 1
		$arrow5.frame = 1
		$arrow6.frame = 1
	elif Global.ARROWS == 3:
		$arrow1.frame = 0
		$arrow2.frame = 0
		$arrow3.frame = 0
		$arrow4.frame = 1
		$arrow5.frame = 1
		$arrow6.frame = 1
	elif Global.ARROWS == 4:
		$arrow1.frame = 0
		$arrow2.frame = 0
		$arrow3.frame = 0
		$arrow4.frame = 0
		$arrow5.frame = 1
		$arrow6.frame = 1
	elif Global.ARROWS == 5:
		$arrow1.frame = 0
		$arrow2.frame = 0
		$arrow3.frame = 0
		$arrow4.frame = 0
		$arrow5.frame = 0
		$arrow6.frame = 1
	elif Global.ARROWS == 6:
		$arrow1.frame = 0
		$arrow2.frame = 0
		$arrow3.frame = 0
		$arrow4.frame = 0
		$arrow5.frame = 0
		$arrow6.frame = 0
	elif Global.ARROWS > 6:
		$arrow1.frame = 0
		$arrow2.frame = 0
		$arrow3.frame = 0
		$arrow4.frame = 0
		$arrow5.frame = 0
		$arrow6.frame = 0
		$lbl_more.visible = true
		$lbl_more.text = "x" + str(Global.ARROWS)
