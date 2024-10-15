# Handles the notifications.
extends Label
class_name NotificationLabel


func create_notification(notification_text: String):
	text = notification_text
	fade_out()


func fade_out(duration: float = 0.5, delay: float = 3.0):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, duration).set_delay(delay)
	await tween.finished
	self.queue_free()
