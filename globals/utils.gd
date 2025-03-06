extends Node

func parse_time_data(time_data: int) -> String:
	var seconds: int = time_data % 60
	var minutes: int = (time_data % 3600) / 60
	var hours: int = time_data / 3600
	var days: int = time_data / 86400

	var f_seconds := "%02d" % seconds
	var f_minutes := "%02d" % minutes
	var f_hours := "%02d" % hours
	var f_days := "%02d" % days

	var f_time = "{day}{hour}:{min}:{sec}"
	var formatter_things = {
		"sec": f_seconds,
		"min": f_minutes,
		"hour": f_hours,
		"day": (f_days+":") if days > 0 else ""
	}

	return f_time.format(formatter_things)
