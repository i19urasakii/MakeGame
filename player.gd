extends CharacterBody2D

# 移動スピード（ピクセル/秒）
const SPEED = 200.0

func _physics_process(delta):
	# 十字キー（矢印キーまたはWASD）の入力を取得
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 移動処理
	velocity = direction * SPEED
	move_and_slide()
