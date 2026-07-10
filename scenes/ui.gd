extends Control


func calc_arrows():
	if Global.ARROWS == 0:
		$arrow1.visible = false
		$arrow2.visible = false
		$arrow3.visible = false
		$arrow4.visible = false
		$arrow5.visible = false
	elif Global.ARROWS == 1:
		$arrow1.visible = true
		$arrow2.visible = false
		$arrow3.visible = false
		$arrow4.visible = false
		$arrow5.visible = false
	elif Global.ARROWS == 2:
		$arrow1.visible = true
		$arrow2.visible = true
		$arrow3.visible = false
		$arrow4.visible = false
		$arrow5.visible = false
	elif Global.ARROWS == 3:
		$arrow1.visible = true
		$arrow2.visible = true
		$arrow3.visible = true
		$arrow4.visible = false
		$arrow5.visible = false
	elif Global.ARROWS == 4:
		$arrow1.visible = true
		$arrow2.visible = true
		$arrow3.visible = true
		$arrow4.visible = true
		$arrow5.visible = false
	elif Global.ARROWS == 5:
		$arrow1.visible = true
		$arrow2.visible = true
		$arrow3.visible = true
		$arrow4.visible = true
		$arrow5.visible = true
