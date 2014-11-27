from bs4 import BeautifulSoup
import urllib2
import re

root_url = 'http://mitathletics.com/sports/m-baskbl/2014-15/boxscores/20141114_gmhh.xml?view='
box_score_url = root_url + 'boxscore'
play_by_play_url = root_url + 'plays'
first_half_url = root_url + 'box1'
second_half_url = root_url + 'box2'
shot_pattern = re.compile('.*(jump shot|layup|tip in|dunk).*')
reb_pattern = re.compile('.*rebound.*')
steal_pattern = re.compile('.*Steal.*')
to_pattern = re.compile('.*Turnover.*')
ft_pattern = re.compile('.*free throw.*')
foul_pattern = re.compile('.*Foul.*')
assist_pattern = re.compile('.*Assist.*')
timeout_pattern = re.compile('.*TIMEOUT.*')
sub_pattern = re.compile('.*(enters|goes).*')
block_pattern = re.compile('.*Block.*')
home_score = 0
away_score = 0
home_fouls = 0
away_fouls = 0
half_score = ''

## Retrieve box score for 1st half starters
response = urllib2.urlopen(box_score_url)
box_score_html = response.read()
box_score_soup = BeautifulSoup(box_score_html)

## Retrieve play by play soup
reponse = urllib2.urlopen(play_by_play_url)
play_by_play_html = response.read()
play_by_play_soup = BeautifulSoup(play_by_play_html)

## Retrieve 2nd half box score for 2nd half starters
response = urllib2.urlopen(second_half_url)
second_half_html = response.read()
second_half_soup = BeautifulSoup(second_half_html)

## Retrieve title for opponent, location and date info
title = box_score_soup.title.string
game = title.split('|')[0].strip()
game_date = title.split('|')[2].split('-')[0].strip()

## Define function for parsing starters and stats
def parse_summary(box_url):
	response = urllib2.urlopen(box_url)
	box_html = response.read()
	box_soup = BeautifulSoup(box_html)
	boxes = box_soup.find_all(class_='stats-fullbox details clearfix')
	# Parse out the starters and total stats for MIT
	boxes = box_soup.find_all(class_='stats-fullbox details clearfix')
	# Find the right table
	table = None
	for box in boxes:
		table = box.contents[1]
		team = box.contents[1].contents[1].contents[0].contents[0].string
		if team=='MIT':
			break
	# Retrieve the data
	stats = {}
	starters = []
	player_counter = 0
	if table != None:
		players = table.find_all(class_='player-name')
		for player in players:
			name = player.string.strip()
			player_stats = []
			number = 0
			if name == 'TEAM':
				number = 'TM'
				player_stats.append(name)
				for i, field in enumerate(player.parent.parent.contents):
					if i<5:
						continue
					if field=='\n':
						continue
					if field.string==None:
						player_stats.append('')
					else:
						player_stats.append(field.string.strip())
			else:
				number = player.parent.parent.previous_sibling.previous_sibling.string.strip()
				if player_counter < 5:
					player_counter += 1
					starters.append(number)
				player_stats.append(name)
				for sibling in player.parent.parent.next_siblings:
					if sibling.string=='\n':
						continue
					if sibling.string==None:
						player_stats.append("")
					else:
						player_stats.append(sibling.string.strip())
			stats[number] = player_stats
	return starters, stats

## Parse out the starters and total stats for MIT
starters, stats = parse_summary(box_score_url)

## Parse out 1st half starters and stats for MIT
first_starters, first_stats = parse_summary(first_half_url)

## Parse out 2nd half starters and stats for MIT
second_starters, second_stats = parse_summary(second_half_url)

## Define the parameters surrounding a play-by-play event
class GameEvent:
	team = ''
	away_score = 0
	home_score = 0
	away_players = []
	home_players = []
	away_fouls = 0
	home_fouls = 0
	event_type = ''
	period = 0
	game_clock = 0
	shot_clock = 35
	away_event = ''
	home_event = ''
	def __init__(self, away_score, home_score):
		self.away_score = away_score
		self.home_score = home_score
	def __str__(self):
		return self.event_type + ': ' + str(self.__dict__)

## Define Steal event
class StealEvent(GameEvent):
	player = ''
	event_type = 'steal'

## Define Turnover events with associated steal or offensive foul
class TurnoverEvent(GameEvent):
	player = ''
	type = ''
	foul = None
	steal = None
	event_type = 'turnover'

## Define Rebound events
class ReboundEvent(GameEvent):
	player = ''
	type = ''
	event_type = 'rebound'

## Define free throw events
class FreeThrowEvent(GameEvent):
	player = ''
	make = False
	event_type = 'ft'

## Define foul events linked to possibly resulting free throws
class FoulEvent(GameEvent):
	player = ''
	shooting = False
	free_throws = []
	event_type = 'foul'
	
## Define assist event
class AssistEvent(GameEvent):
	player = ''
	event_type = 'assist'

## Define block event
class BlockEvent(GameEvent):
	player = ''
	event_type = 'block'

## Define Shooting events (assists, blocks and maybe rebounds included)
class ShotEvent(GameEvent):
	shooter = ''
	make = False
	shot_type = ''
	foul = None
	free_throws = []
	assist = None
	block = None
	rebound = None
	event_type = 'shot'
	
## Define Timeout events
class TimeoutEvent(GameEvent):
	team = ''
	type = ''	
	event_type = 'timeout'
	
## Define Substitution events
class SubstitutionEvent(GameEvent):
	player_out = ''
	player_in = ''
	event_type = 'substitution'
	
## Function to parse event details
def parse_event(row):
	global home_score
	global away_score
	global home_fouls
	global away_fouls
	event = GameEvent(away_score, home_score)
	fields = row.contents
	time = fields[1].string
	if time != None:
		time = re.sub('\s+', ' ', time.strip())
	away = fields[3].string
	if away != None:
		away = re.sub('\s+', ' ', away.strip())
	home = fields[7].string
	if home != None:
		home = re.sub('\s+', ' ', home.strip())
	# Handle home event
	if not away and len(fields[3].contents) < 3:
		# Handle home shots
		if re.match(shot_pattern, str(home)):
			event = ShotEvent(away_score, home_score)
			x = home.split()
			event.player = event.shooter = x[0]
			event.make = True if x[1]=='made' else False
			type = x[2]
			if type=='3-pt.' or type=='dunk' or type=='layup':
				event.shot_type = type
			else:
				if type=='in':
					event.make = True
					event.shot_type = 'tip'
				else:
					event.shot_type = '2-pt'
		# Handle home rebounds
		elif re.match(reb_pattern, str(home)):
			event = ReboundEvent(away_score, home_score)
			x = home.split()
			event.player = x[0]
			event.type = x[1]
		# Handle home steals
		elif re.match(steal_pattern, str(home)):
			event = StealEvent(away_score, home_score)
			x = home.split()
			event.player = x[2]
		# Handle home turnovers
		elif re.match(to_pattern, str(home)):
			event = TurnoverEvent(away_score, home_score)
			x = home.split()
			event.player = x[2]
		# Handle home free throws
		elif re.match(ft_pattern, str(home)):
			event = FreeThrowEvent(away_score, home_score)
			x = home.split()
			event.player = x[0]
			if x[1] == 'made':
				event.make = True
			else:
				event.make = False
		# Handle home fouls
		elif re.match(foul_pattern, str(home)):
			event = FoulEvent(away_score, home_score)
			home_fouls += 1
			event.home_fouls = home_fouls
			x = home.split()
			event.player = x[2]
		# Handle home assists
		elif re.match(assist_pattern, str(home)):
			event = AssistEvent(away_score, home_score)
			x = home.split()
			event.player = x[2]
		# Handle home sub
		elif re.match(sub_pattern, str(home)):
			event = SubstitutionEvent(away_score, home_score)
			x = home.split()
			if x[1]=='enters':
				event.player_in = x[0]
			else:
				event.player_out = x[0]
		# Handle home block
		elif re.match(block_pattern, str(home)):
			event = BlockEvent(away_score, home_score)
			x = home.split()
			event.player = x[2]
		# Handle home timeouts
		else:
			event = TimeoutEvent(away_score, home_score)
			event.team = 'Home'
			event.type = fields[7].contents[1].contents[0].split()[0]
	# Handle away events
	else:
		# Handle away shots
		if re.match(shot_pattern, str(away)):
			event = ShotEvent(away_score, home_score)
			x = away.split()
			event.player = event.shooter = x[0]
			event.make = True if x[1]=='made' else False
			type = x[2]
			if type=='3-pt.' or type=='dunk' or type=='layup':
				event.shot_type = type
			else:
				if type=='in':
					event.make = True
					event.shot_type = 'tip'
				else:
					event.shot_type = '2-pt'
		# Handle away rebounds
		elif re.match(reb_pattern, str(away)):
			event = ReboundEvent(away_score, home_score)
			x = away.split()
			event.player = x[0]
			event.type = x[1]
		# Handle away steals
		elif re.match(steal_pattern, str(away)):
			event = StealEvent(away_score, home_score)
			x = away.split()
			event.player = x[2]
		# Handle away turnovers
		elif re.match(to_pattern, str(away)):
			event = TurnoverEvent(away_score, home_score)
			x = away.split()
			event.player = x[2]
		# Handle away free throws
		elif re.match(ft_pattern, str(away)):
			event = FreeThrowEvent(away_score, home_score)
			x = away.split()
			event.player = x[0]
			if x[1] == 'made':
				event.make = True
			else:
				event.make = False
		# Handle away fouls
		elif re.match(foul_pattern, str(away)):
			event = FoulEvent(away_score, home_score)
			away_fouls += 1
			x = away.split()
			event.player = x[2]
			event.away_fouls = away_fouls
		# Handle away assists
		elif re.match(assist_pattern, str(away)):
			event = AssistEvent(away_score, home_score)
			x = away.split()
			event.player = x[2]
		# Handle away sub
		elif re.match(sub_pattern, str(away)):
			event = SubstitutionEvent(away_score, home_score)
			x = away.split()
			if x[1]=='enters':
				event.player_in = x[0]
			else:
				event.player_out = x[0]
		# Handle away block
		elif re.match(block_pattern, str(away)):
			event = BlockEvent(away_score, home_score)
			x = away.split()
			event.player = x[2]
		# Handle away timeouts
		else:
			event = TimeoutEvent(away_score, home_score)
			event.team = 'Away'
			event.type = fields[3].contents[1].contents[0].split()[0]
	if (str(time) != 'Time' and str(time) != None):
		event_min = int(time.split(":")[0])
		event_sec = int(time.split(":")[1])
		event.game_clock = 1200 - (event_min*60 + event_sec)
	# Update scores
	score = fields[5].string
	if score != None:
		score = re.sub('\s+', ' ', score.strip())
		scores = score.split('-')
		if len(scores) > 1 and scores[0]:
			away_score = int(scores[0])
			home_score = int(scores[1])
	# Final Event
	return event
	
## Define function to parse a game's play by play
# Need to account for overtimes
def parse_plays(play_url, half=''):
	global home_score
	global away_score
	global home_fouls
	global away_fouls
	events = []
	response = urllib2.urlopen(play_url)
	play_html = response.read()
	play_soup = BeautifulSoup(play_html, 'html.parser')
	#First half processing
	if half != 'second':
		away_score = 0
		home_score = 0
		away_fouls = 0
		home_fouls = 0
		first_half_table = play_soup.find(id='prd1').parent.parent
		it = iter(first_half_table.next_siblings)
		it.next()
		it.next()
		while True:
			try:
				row = it.next()
				#print row
				if row=='\n':
					continue
				fields = row.contents
				if len(fields) < 4:
					break
				event = parse_event(row)
				subevents = []
				if event.event_type == 'shot':
					while True:
						row = it.next()
						print row
						if row != '\n':
							break
					print 'Here'
					e = parse_event(row)
					subevents.append(e)
					if e.event_type == 'rebound':
						event.rebound = e
					elif e.event_type == 'assist':
						event.assist = e
					elif e.event_type == 'block':
						event.block = e
					elif e.event_type == 'foul':
						event.foul = e
						while True:
							while True:
								row = it.next()
								print row
								if row != '\n':
									break
							print row
							e = parse_event(row)
							subevents.append(e)
							if e.event_type == 'ft': 
								event.foul.free_throws.append(e)
							else:
								break
				events.append(event)
				for ev in subevents:
					events.append(ev)
			except:
				break
		for ev in events:
			print ev
	print '\n\n-------------END OF FIRST HALF-----------\n\n'
	#Second half processing
	if half != 'first':
		home_fouls = 0
		away_fouls = 0
		second_half_table = play_soup.find(id='prd2').parent.parent
		it = iter(second_half_table.next_siblings)
		it.next()
		it.next()
		while True:
			try:
				row = it.next()
				if row=='\n':
					continue
				fields = row.contents
				if len(fields) < 4:
					break
				parse_event(row)
			except:
				break
	#Overtimes processing
	#if half != 'first' and half != 'second':