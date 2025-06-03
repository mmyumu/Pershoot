class_name Datetime extends Resource

@export var timestamp: float = Time.get_unix_time_from_system():
	set(value):
		timestamp = value
		_update()

var year: int
var month: int
var day: int
var hour: int
var minute: int
var second: int

func _init(timestamp_to_set: float = -1):
	if timestamp_to_set == -1:
		timestamp_to_set = Time.get_unix_time_from_system()
	timestamp = timestamp_to_set

func spend(time_to_spend):
	timestamp += time_to_spend
	return self

func _update():
	var datetime = _timestamp_to_date(timestamp)
	year = datetime[0]
	month = datetime[1]
	day = datetime[2]
	hour = datetime[3]
	minute = datetime[4]
	second = datetime[5]

func changed_day(other_date: Datetime):
	return other_date != null and (year != other_date.year or month != other_date.month or day != other_date.day)

func changed_hour(other_date: Datetime):
	return other_date != null and (year != other_date.year or month != other_date.month or day != other_date.day or hour != other_date.hour)

func get_date_str():
	return "%d-%02d-%02d" % [year, month, day]

func get_time_str():
	return "%02d:%02d:%02d" % [hour, minute, second]

func get_datetime_str():
	return "%s %s" % [get_date_str(), get_time_str()]

func _timestamp_to_date(current_timestamp):
	var seconds_in_day = 86400
	var days = current_timestamp / seconds_in_day
	var timestamp_year = 1970

	while days >= 365 + _is_leap_year(timestamp_year):
		days -= 365 + _is_leap_year(timestamp_year)
		timestamp_year += 1

	var timestamp_month = 1
	while days >= _get_days_in_month(timestamp_month, timestamp_year):
		days -= _get_days_in_month(timestamp_month, timestamp_year)
		timestamp_month += 1

	var timestamp_day = 1 + days
	
	var remaining_seconds = int(current_timestamp) % seconds_in_day
	var timestamp_hour = remaining_seconds / 3600
	remaining_seconds %= 3600
	var timestamp_minute = remaining_seconds / 60
	var timestamp_second = remaining_seconds % 60
	
	return [timestamp_year, timestamp_month, timestamp_day, timestamp_hour, timestamp_minute, timestamp_second]

func _is_leap_year(year):
	return 1 if year % 4 == 0 and (year % 100 != 0 or year % 400 == 0) else 0

func _get_days_in_month(month, year):
	if month in [1, 3, 5, 7, 8, 10, 12]:
		return 31
	elif month in [4, 6, 9, 11]:
		return 30
	elif month == 2:
		return 29 if _is_leap_year(year) else 28
	return 0
