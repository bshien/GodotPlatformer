#See https://docs.unity3d.com/ScriptReference/Mathf.MoveTowards.html for what this does
static func moveTowards(current: float, target: float, maxDelta: float) -> float:
	if (abs(target - current) <= maxDelta):
		return target
	return current + sign(target - current) * maxDelta