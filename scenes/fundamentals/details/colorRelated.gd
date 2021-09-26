extends CanvasLayer


onready var rect = $ColorRect
onready var tintRect = $tintRect
onready var transition_player = $transitionPlayer
onready var tint_player = $tintPlayer

var tintOn = false


func fadeout(time):
	
	rect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "ColorRect:color")
	animation.set_length(time)
	animation.track_insert_key(track_index, 0, Color(0,0,0,0))
	animation.track_insert_key(track_index, time, Color(0,0,0,1))
	transition_player.add_animation("fadeout", animation)
	transition_player.play("fadeout")
	

func fadein(time):
	
	rect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "ColorRect:color")
	animation.set_length(time)
	animation.track_insert_key(track_index, 0, Color(0,0,0,1))
	animation.track_insert_key(track_index, time, Color(0,0,0,0))
	transition_player.add_animation("fadein", animation)
	transition_player.play("fadein")
	
# DO NOT USE tint AND tintREPEAT AT THE SAME TIME!
# ALWAYS REMOVE tint OR REMOVE REPEAT 

func tint(c: Color, time: float):
	
	if tintOn: # if tint is already on, overwrite old tint
		removeTint()
	
	tintRect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "tintRect:color")
	animation.set_length(time)
	animation.track_insert_key(track_index, 0, Color(0,0,0,0))
	animation.track_insert_key(track_index, time, c)
	tint_player.add_animation("displaytint", animation)
	tint_player.play("displaytint")
	tintOn = true
	
	
func removeTint():
	tintOn = false
	tintRect.visible = false
	if tint_player.has_animation("displaytint"):
		tint_player.remove_animation("displaytint")
		
	if tint_player.has_animation("tintWave"):
		tint_player.remove_animation("tintWave")

	
func tintWave(c:Color,time:float):
	
	if tintOn: # overwrite old tint
		removeTint()
	
	tintRect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "tintRect:color")
	animation.set_length(time)
	animation.set_loop(true)
	animation.track_insert_key(track_index, 0, Color(0,0,0,0))
	animation.track_insert_key(track_index, time/4, c)
	animation.track_insert_key(track_index, 3*time/4, c)
	animation.track_insert_key(track_index, time, Color(0,0,0,0))
	tint_player.add_animation("tintWave", animation)
	tint_player.play("tintWave")
	tintOn = true


func pixellate_out(t:float):
	rect.visible = true
	rect.material = load("res://customShaders/pixellate.tres")
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "ColorRect:material:shader_param/time")
	animation.set_length(t)
	animation.track_insert_key(track_index, 0, 0.0)
	animation.track_insert_key(track_index, t, 1.562)
	transition_player.add_animation("pixel_in", animation)
	transition_player.play("pixel_in")

# Pixellate is only used during a screen transition. So if pixellate out
# is called, then color rect already has loaded the material
func pixellate_in(t:float):
	rect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "ColorRect:material:shader_param/time")
	animation.set_length(t)
	animation.track_insert_key(track_index, 0, 1.562)
	animation.track_insert_key(track_index, t, 3.2)
	transition_player.add_animation("pixel_out", animation)
	transition_player.play("pixel_out")


func _on_transitionPlayer_animation_finished(anim_name):
	if anim_name == "fadein" or anim_name == "fadeout":
		rect.visible = false
		transition_player.remove_animation(anim_name)
	elif anim_name == 'pixel_in':
		transition_player.remove_animation('pixel_in')
	elif anim_name == 'pixel_out':
		rect.visible = false
		rect.material = null
		transition_player.remove_animation('pixel_out')
	else:
		pass
		
