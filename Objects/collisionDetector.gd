extends Area3D

# What this means is, when a collision body enters/exits, it calls this. 
# The difference is that we supply what node it's coming from, being "self"
signal bodyEnteredCircumstances(me, body)
signal bodyExitedCircumstances(me, body)

func _ready():
	body_entered.connect(sendBodyEnteredSignal)
	body_exited.connect(sendBodyExitedSignal)


func sendBodyEnteredSignal(body):
	bodyEnteredCircumstances.emit(self, body)


func sendBodyExitedSignal(body):
	bodyExitedCircumstances.emit(self, body)
